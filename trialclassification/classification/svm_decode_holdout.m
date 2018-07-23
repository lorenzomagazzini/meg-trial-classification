function results = svm_decode_holdout (train_data, train_labels, test_data, test_labels, varargin)
% Basic classification function using LibLinear SVM implementation for classification and independent (pre-specified) training and test sets.
%
% Inputs: training and testing data(trials x features), training and testing abels. 
% Optional: svm parameters and desired optional performance metrics.
%
% Name-value pairs: 
% 'solver', default 1: L2-regularized dual problem solver (LibLinear);
% 'boxconstraint', default 1
% 'standardize', default true (recommended; across training set)
% 'weights', default false (output vector of classifier weights & activation patterns associated with them cf. Haufe 2014)
% 
%
% Outputs results structure with non-optional metrics: accuracy, Fscore, sensitivity, specificity.
% Optional (as above): weights and weight-derived patterns. (Set 'weights',true)
%
% DC Dima 2018 (diana.dima@gmail.com)

%parse inputs
svm_par = svm_args;
list = fieldnames(svm_par);
p = inputParser;
for ii = 1:length(properties(svm_args))
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
parse(p, varargin{:});
svm_par = p.Results;
clear p;

if abs(nargin)<4 %at least 4 arguments needed
    error('Separate training and testing data and labels are needed as inputs.')
end;

%double precision data is required by LibLinear
if ~isa(train_data, 'double')
    train_data = double(train_data);
end;
if ~isa(test_data, 'double')
    test_data = double(test_data);
end;

%scale values using range and minimum of training set 
if svm_par.standardize
    train_data = (train_data - repmat(min(train_data, [], 1), size(train_data, 1), 1)) ./ repmat(max(train_data, [], 1) - min(train_data, [], 1), size(train_data, 1), 1);
    test_data = (test_data - repmat(min(train_data, [], 1), size(test_data, 1), 1)) ./ repmat(max(train_data, [], 1) - min(train_data, [], 1), size(test_data, 1), 1);
end;

%train and test the model
svm_model = train(train_labels, sparse(train_data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));
[scores, accuracy, ~] = predict(test_labels, sparse(test_data), svm_model, '-q 1'); %this outputs labels, accuracy, and standard error

%add performance metrics to a scalar results structure
results.Accuracy = accuracy(1); %accuracy
results.AccuracyMSError = accuracy(2); %accuracy mean squared error
results.Confusion = confusionmat(test_labels,scores); %get the confusion matrix
if numel(results.Confusion)>1 %check that this was output right first
    results.Sensitivity = results.Confusion(1,1)/(sum(results.Confusion(1,:))); %TP/allP = TP/(TP+FN)
    PP = results.Confusion(1,1)/(sum(results.Confusion(:,1))); %positive predictive value: class1
    results.Specificity = results.Confusion(2,2)/(sum(results.Confusion(2,:))); %TN/allN = TN/(FP+TN)
    NP = results.Confusion(2,2)/(sum(results.Confusion(:,2))); %negative predictive value: class2
    results.Fscore1 = (2*PP*results.Sensitivity)/(PP+results.Sensitivity); %F1-score: class 1
    results.Fscore2 = (2*NP*results.Specificity)/(NP+results.Specificity); %F1-score: class 2
    results.WeightedFscore = ((sum(results.Confusion(:,1))/sum(results.Confusion(:)))*results.Fscore1) + ((sum(results.Confusion(:,2))/sum(results.Confusion(:)))*results.Fscore2); %F1-score weighted by class size
    results.Label = svm_model.Label; %save class order
end;

%calculate weights and compute activation patterns as per Haufe et al. (2014)
if svm_par.weights
    results.Weights = svm_model.w;
    results.WeightPatterns = abs(cov(train_data)*results.Weights'/cov(train_data*results.Weights'));
    results.WeightPatternsNorm = (results.WeightPatterns-min(results.WeightPatterns))/(max(results.WeightPatterns)-min(results.WeightPatterns));
end;


end
        
