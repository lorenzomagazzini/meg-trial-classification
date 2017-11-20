function results = svm_decode_kfold (data, labels, varargin)
% Inputs: data(trials x features), labels. Optional: svm
% parameters and desired optional performance metrics.
% Name-value pairs: 
% 'solver', default 1: L2-regularized dual problem solver (LibLinear);
% 'boxconstraint', default 1
% 'kfold', default 5
% 'standardize', default true (recommended; across training set)
% 'weights', default false (output vector of classifier weights & activation patterns associated with them cf. Haufe 2014)
%
% Outputs results structure with non-optional metrics: accuracy, Fscore, sensitivity, specificity. 
% Optional (as above): weights and weight-derived patterns.
% Basic function using LibLinear implementation of svm for classification. Only implements kfold crossvalidation.

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

if abs(nargin)<2 
    error('Data and labels are needed as inputs.')
end;

cv = cvpartition(labels, 'kfold', svm_par.kfold);
allscore = zeros(length(labels),1); accuracy = zeros(3,5);

for ii = 1:svm_par.kfold
    
    %scale values using range and minimum of training set
    kdata = data; %ensures we keep original data
    if svm_par.standardize
        data = (kdata - repmat(min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1)) ./ repmat(max(data(cv.training(ii),:), [], 1) - min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1);
    end;
    
    svm_model = train(labels(cv.training(ii)), sparse(data(cv.training(ii),:)), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint)); %dual-problem L2 solver with C=1
    [allscore(cv.test(ii)), accuracy(:,ii), ~] = predict(labels(cv.test(ii)), sparse(data(cv.test(ii),:)), svm_model, '-q 1');
    
end;

results.Accuracy = mean(accuracy(1,:));
results.AccuracyMSError = mean(accuracy(2,:));
results.AccuracyFold = accuracy(1,:);
results.Confusion = confusionmat(labels,allscore);
results.Sensitivity = results.Confusion(1,1)/(sum(results.Confusion(1,:))); %TP/allP = TP/(TP+FN)
results.Specificity = results.Confusion(2,2)/(sum(results.Confusion(2,:))); %TN/allN = TN/(FP+TN)
results.Fscore1 = (2*PP*results.Sensitivity)/(PP+results.Sensitivity);
results.Fscore2 = (2*NP*results.Specificity)/(NP+results.Specificity);
results.WeightedFscore = ((sum(results.Confusion(:,1))/sum(results.Confusion(:)))*results.Fscore1) + ((sum(results.Confusion(:,2))/sum(results.Confusion(:)))*results.Fscore2);

%calculate weights and compute activation patterns as per Haufe (2014)
if svm_par.weights
    data = (kdata - repmat(min(kdata, [], 1), size(kdata, 1), 1)) ./ repmat(max(kdata, [], 1) - min(kdata, [], 1), size(kdata, 1), 1);
    svm_model = train(labels, sparse(data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));
    results.Weights = svm_model.w;
    results.WeightPatterns = abs(results.Weights*cov(data));
end;


end
        
