function [ results ] = svm_decode_kfold_libsvm( data, labels, varargin )
% Basic classification function using libSVM implementation of svm. Only implements stratified kfold crossvalidation with random partition.
% Inputs: data(trials x features), labels. 
% Optional: svm parameters and desired optional performance metrics.
% This function uses LibSVM and calculates posterior probabilities from SVM
% scores to get AUC and ROC curve. It is slower than the "svm_decode_kfold" function
% (which uses the LibLinear implementation and does not output AUROC).
% Not recommended for large repetitions of classification iterations.
% Note that LibSVM and LibLinear can have somewhat different results even
% when linear kernel is used (like here).
%
% Name-value pairs:
%   'kernel', default 0: linear
%   'AUC', default true (compute AUC: longer time)
%   'plotROC', default false (plot ROC curve).
%   'boxconstraint', default 1
%   'kfold', default 5
%   'iterate_cv', default 1, number of cross-validation iterations
%   'standardize', default true (recommended; across training set)
%   'weights', default false (output vector of classifier weights & activation patterns associated with them cf. Haufe 2014)
%
% Outputs results structure with non-optional metrics: AUC, ROC, accuracy, Fscore, sensitivity, specificity.
% Optional: weights and weight-derived patterns.
%
% DC Dima 2018 (diana.dima@gmail.com)


%parse inputs
svm_par = svm_args;
list = fieldnames(svm_par);
p = inputParser;
for ii = 1:length(properties(svm_args))
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
addParameter(p, 'AUC', true);
addParameter(p,'plotROC', false);
parse(p, varargin{:});
svm_par = p.Results;
clear p;

if abs(nargin)<2 %minimum 2 arguments required
    error('Data and labels are needed as inputs.')
end;

if ~isa(data, 'double') %double precision required
    data = double(data);
end;

results = struct;

for icv = 1: svm_par.iterate_cv %loop through cross-validation iterations
    
    cv = cvpartition(labels, 'kfold', svm_par.kfold); %divide up dataset for cross-validation
    allscore = zeros(length(labels),1); accuracy = zeros(3,5); post_prob=zeros(length(labels),2); %initialize outputs

    for ii = 1:svm_par.kfold %for each fold
        
        %scale values using range and minimum of training set
        kdata = data; %ensures we keep original data
        if svm_par.standardize
            data = (kdata - repmat(min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1)) ./ repmat(max(data(cv.training(ii),:), [], 1) - min(data(cv.training(ii),:), [], 1), size(kdata, 1), 1);
        end;
        
        %train and test classifier
        if svm_par.AUC %if AUC required, we need to train with flag -b set to 1, and get posterior probabilities
            svm_model = svmtrain(labels(cv.training(ii)), data(cv.training(ii),:), sprintf('-t %d -c %d -b 1 -q 1', svm_par.kernel, svm_par.boxconstraint));
            [allscore(cv.test(ii)), accuracy(:,ii), post_prob(cv.test(ii),:)] = svmpredict(labels(cv.test(ii)), data(cv.test(ii),:), svm_model, '-b 1 -q 1');
        else %otherwise just get scores and accuracy
            svm_model = svmtrain(labels(cv.training(ii)), data(cv.training(ii),:), sprintf('-t %d -c %d -b 0 -q 1', svm_par.kernel, svm_par.boxconstraint));
            [allscore(cv.test(ii)), accuracy(:,ii),~] = svmpredict(labels(cv.test(ii)), data(cv.test(ii),:), svm_model, '-b 0 -q 1');
        end;
        
    end;
    
    %get performance metrics
    results.Accuracy(icv) = mean(accuracy(1,:));
    results.AccuracyMSError(icv) = mean(accuracy(2,:));
    results.AccuracyFold(icv,:) = accuracy(1,:);
    results.Confusion{icv} = confusionmat(labels,allscore);
    results.Sensitivity(icv) = results.Confusion{icv}(1,1)/(sum(results.Confusion{icv}(1,:))); %TP/allP = TP/(TP+FN)
    results.Specificity(icv) = results.Confusion{icv}(2,2)/(sum(results.Confusion{icv}(2,:))); %TN/allN = TN/(FP+TN)
    PP = results.Confusion{icv}(1,1)/(sum(results.Confusion{icv}(:,1))); %positive predictive value: class1
    NP = results.Confusion{icv}(2,2)/(sum(results.Confusion{icv}(:,2))); %negative predictive value: class2
    results.Fscore1(icv) = (2*PP*results.Sensitivity(icv))/(PP+results.Sensitivity(icv)); %F1-score: class1
    results.Fscore2(icv) = (2*NP*results.Specificity(icv))/(NP+results.Specificity(icv)); %F1-score: class2
    results.WeightedFscore(icv) = ((sum(results.Confusion{icv}(:,1))/sum(results.Confusion{icv}(:)))*results.Fscore1(icv)) + ((sum(results.Confusion{icv}(:,2))/sum(results.Confusion{icv}(:)))*results.Fscore2(icv)); %weighted F1-score
    results.Label = svm_model.Label; %save class order
    
    %calculated AUC if requested
    if svm_par.AUC
        [results.ROC{icv}(:,1),results.ROC{icv}(:,2),~,results.AUC(icv)] = perfcurve(labels, post_prob(:,1),'1');
    end;
    
    %plot ROC if requested
    if svm_par.plotROC
        figure;
        plot(results.ROC{icv}(:,1),results.ROC{icv}(:,2), 'k');
        xlabel('False positive rate');
        ylabel('True positive rate');
        title('ROC Curve', 'FontWeight', 'normal');
    end;
    
end;

%calculate weights and compute activation patterns as per Haufe (2014)
if svm_par.weights
    data = (kdata - repmat(min(kdata, [], 1), size(kdata, 1), 1)) ./ repmat(max(kdata, [], 1) - min(kdata, [], 1), size(kdata, 1), 1);
    svm_model = train(labels, sparse(data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));
    results.Weights = svm_model.w;
    results.WeightPatterns = abs(cov(data)*results.Weights'/cov(data*results.Weights')); 
    results.WeightPatternsNorm = (results.WeightPatterns-min(results.WeightPatterns))/(max(results.WeightPatterns)-min(results.WeightPatterns));
end;


end

