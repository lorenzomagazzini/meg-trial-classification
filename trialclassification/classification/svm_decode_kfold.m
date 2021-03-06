function results = svm_decode_kfold (data, labels, varargin)
% Basic classification function using LibLinear SVM implementationl, implements stratified kfold crossvalidation with random partition.
%
% Inputs: data(trials x features), labels. 
% Optional: svm parameters and desired optional performance metrics.
%
% Name-value pairs: 
% 'solver', default 1: L2-regularized dual problem solver (LibLinear);
% 'boxconstraint', default 1
% 'kfold', default 5
% 'iterate_cv', default 1, number of cross-validation iterations
% 'standardize', default true (recommended; based on training set)
% 'weights', default false (output vector of classifier weights & activation patterns associated with them cf. Haufe et al. 2014)
%            Note: weights are computed by retraining classifier on whole dataset
%
% Outputs results structure with non-optional metrics: accuracy, Fscore, sensitivity, specificity. 
% Optional (as above): weights and weight-derived patterns. (Set 'weights',true)
%
% DC Dima 2018 (diana.c.dima@gmail.com)

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

if abs(nargin)<2 %at least two arguments required 
    error('Data and labels are needed as inputs.')
end;

if ~isa(data, 'double') %data matrix needs to have double precision
    data = double(data);
end;

results = struct; %initialize results structure

for icv = 1: svm_par.iterate_cv % loop through cross-validation iterations

    cv = cvpartition(labels, 'kfold', svm_par.kfold); %get the cross-validation indices - random but stratified (balanced classes)
    allscore = zeros(length(labels),1); accuracy = zeros(3,svm_par.kfold); 
    
    for ii = 1:svm_par.kfold %for each fold
        
        %scale values using range and minimum of training set
        kdata = data; %keep original data
        if svm_par.standardize %standardize features
            data = (kdata - repmat(min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1)) ./ repmat(max(data(cv.training(ii),:), [], 1) - min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1);
        end;
        
        %train and test classifier using given parameters
        svm_model = train(labels(cv.training(ii)), sparse(data(cv.training(ii),:)), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint)); %dual-problem L2 solver with C=1
        [allscore(cv.test(ii)), accuracy(:,ii), ~] = predict(labels(cv.test(ii)), sparse(data(cv.test(ii),:)), svm_model, '-q 1');
        
    end;

    %save performance metrics in results structure. The structure dimensions are given by the number of cross-validations performed
    results.Accuracy(icv) = mean(accuracy(1,:)); %accuracy, averaged across folds
    results.AccuracyMSError(icv) = mean(accuracy(2,:)); %average mean square error across folds (this is given by the predict function)
    results.AccuracyFold(icv,:) = accuracy(1,:); %accuracy for each fold
    results.Confusion{icv} = confusionmat(labels,allscore); %confusion matrix
    results.Sensitivity(icv) = results.Confusion{icv}(1,1)/(sum(results.Confusion{icv}(1,:))); %TP/allP = TP/(TP+FN)
    results.Specificity(icv) = results.Confusion{icv}(2,2)/(sum(results.Confusion{icv}(2,:))); %TN/allN = TN/(FP+TN)
    PP = results.Confusion{icv}(1,1)/(sum(results.Confusion{icv}(:,1))); %positive predictive value: class1
    NP = results.Confusion{icv}(2,2)/(sum(results.Confusion{icv}(:,2))); %negative predictive value: class2
    results.Fscore1(icv) = (2*PP*results.Sensitivity(icv))/(PP+results.Sensitivity(icv)); %F1-score: class1
    results.Fscore2(icv) = (2*NP*results.Specificity(icv))/(NP+results.Specificity(icv)); %F1-score: class2
    results.WeightedFscore(icv) = ((sum(results.Confusion{icv}(:,1))/sum(results.Confusion{icv}(:)))*results.Fscore1(icv)) + ((sum(results.Confusion{icv}(:,2))/sum(results.Confusion{icv}(:)))*results.Fscore2(icv)); %weighted F-score
    results.Label = svm_model.Label; %save class order
end;

%calculate weights using whole dataset and compute activation patterns as per Haufe et al. (2014)
if svm_par.weights
    data = (kdata - repmat(min(kdata, [], 1), size(kdata, 1), 1)) ./ repmat(max(kdata, [], 1) - min(kdata, [], 1), size(kdata, 1), 1);
    svm_model = train(labels, sparse(data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));
    results.Weights = svm_model.w;
    results.WeightPatterns = abs(cov(data)*results.Weights'/cov(data*results.Weights'));
    results.WeightPatternsNorm = (results.WeightPatterns-min(results.WeightPatterns))/(max(results.WeightPatterns)-min(results.WeightPatterns));
end;


end
        
