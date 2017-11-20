function [ results ] = svm_decode_kfold_auc( data, labels, varargin )
% Inputs: data(trials x features), labels. Optional: svm
% parameters and desired optional performance metrics.
% This function uses LibSVM and calculates posterior probabilities from SVM
% scores to get AUC and ROC curve. It is slower than the "svm_decode_kfold" function 
% (which uses the LibLinear implementation and does not output AUROC). 
% Not recommended for large repetitions of classification iterations. 
% Note that LibSVM and LibLinear can have somewhat different results even 
% when linear kernel is used (like here).
%
% Name-value pairs: 
%   'plotROC', default false (plot ROC curve).
%   'boxconstraint', default 1
%   'kfold', default 5
%   'standardize', default true (recommended; across training set)
%   'weights', default false (output vector of classifier weights & activation patterns associated with them cf. Haufe 2014)
%
% Outputs results structure with non-optional metrics: AUC, ROC, accuracy, Fscore, sensitivity, specificity. 
% Optional: weights and weight-derived patterns.
% Basic function using libSVM implementation of svm for classification. Only implements kfold crossvalidation.

%parse inputs
svm_par = svm_args;
list = fieldnames(svm_par);
p = inputParser;
for ii = 1:length(properties(svm_args))
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
addParameter(p,'plotROC', false);
parse(p, varargin{:});
svm_par = p.Results;
clear p;

if abs(nargin)<2 
    error('Data and labels are needed as inputs.')
end;

cv = cvpartition(labels, 'kfold', svm_par.kfold);
allscore = zeros(length(labels),1); accuracy = zeros(3,5); post_prob=zeros(length(labels),2);

for ii = 1:svm_par.kfold
    
    %scale values using range and minimum of training set
    kdata = data; %ensures we keep original data
    if svm_par.standardize
        data = (kdata - repmat(min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1)) ./ repmat(max(data(cv.training(ii),:), [], 1) - min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1);
    end;
    
    svm_model = svmtrain(labels(cv.training(ii)), data(cv.training(ii),:), sprintf('-s 0 -t 0 -c %d -b 1 -q 1', svm_par.boxconstraint));
    [allscore(cv.test(ii)), accuracy(:,ii), post_prob(cv.test(ii),:)] = svmpredict(labels(cv.test(ii)), data(cv.test(ii),:), svm_model, '-b 1 -q 1');
    
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
[results.ROC(:,1),results.ROC(:,2),~,results.AUC] = perfcurve(labels, post_prob(:,1),'1');

if svm_par.plotROC
    figure;
    plot(results.ROC(:,1),results.ROC(:,2), 'k');
    xlabel('False positive rate');
    ylabel('True positive rate');
    title('ROC Curve', 'FontWeight', 'normal');
end;

%calculate weights and compute activation patterns as per Haufe (2014)
if svm_par.weights
    data = (kdata - repmat(min(kdata, [], 1), size(kdata, 1), 1)) ./ repmat(max(kdata, [], 1) - min(kdata, [], 1), size(kdata, 1), 1);
    svm_model = train(labels, sparse(data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));
    results.Weights = svm_model.w;
    results.WeightPatterns = abs(results.Weights*cov(data));
end;


end

