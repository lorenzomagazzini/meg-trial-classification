function [ num_feat_to_keep, Fscores ] = RFE_CV(data, labels, varargin )
%Runs SVM recursive feature elimination with cross-validation.
%Outputs number of features to keep for maximum performance in each CV fold.
%Note - LibLinear has to be on path.

if abs(nargin)<2 
    error('Data and labels are needed as inputs.')
end;

%use SVM object to initialize parameters
svm_par = svm_args;
list = fieldnames(svm_par);
p = inputParser;
for ii = 1:length(properties(svm_args))
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
parse(p, varargin{:});
svm_par = p.Results;
clear p;

num_features = size(data,2);
num_feat_to_keep = nan(1,svm_par.kfold);
Fscores = nan(num_features,svm_par.kfold);
cv = cvpartition(labels, 'kfold', svm_par.kfold);
kdata = data; %ensures we keep original data    

for ii = 1:svm_par.kfold %for each fold
    
    %scale values using range and minimum of training set
    if svm_par.standardize
        data = (kdata - repmat(min(kdata(cv.training(ii),:), [], 1), size(kdata, 1), 1)) ./ repmat(max(kdata(cv.training(ii),:), [], 1) - min(kdata(cv.training(ii),:), [], 1), size(kdata, 1), 1);
    end;
   
    for f = 1:size(data,2)-1 %each loop iteration eliminates one feature
    
        svm_model = train(labels(cv.training(ii)), sparse(data(cv.training(ii),:)), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint)); %dual-problem L2 solver with C=1
        [scores, ~, ~] = predict(labels(cv.test(ii)), sparse(data(cv.test(ii),:)), svm_model, '-q 1');
        
        %get the weighted Fscore (suitable for unbalanced classes)
        confusion = confusionmat(labels(cv.test(ii)),scores);
        sensitivity = confusion(1,1)/(sum(confusion(1,:))); %TP/allP = TP/(TP+FN)
        specificity = confusion(2,2)/(sum(confusion(2,:))); %TN/allN = TN/(FP+TN)
        PP = confusion(1,1)/(sum(confusion(:,1))); %positive predictive value: class1
        NP = confusion(2,2)/(sum(confusion(:,2))); %negative predictive value: class2
        Fscore1 = (2*PP*sensitivity)/(PP+sensitivity); %F-score for class 1
        Fscore2 = (2*NP*specificity)/(NP+specificity); %F-score for class 2
        WeightedFscore = ((sum(confusion(:,1))/sum(confusion(:)))*Fscore1) + ((sum(confusion(:,2))/sum(confusion(:)))*Fscore2);
        Fscores(f,ii) = WeightedFscore;    
        
        %eliminate one feature
        abs_w = abs(svm_model.w);
        elim_idx = find(abs_w==min(abs_w),1); %%find the minimal absolute weight
        data(:,elim_idx) = []; %remove feature from data
        
    end;
    
    maxF = find(Fscores(:,ii)==max(Fscores(:,ii)),1);
    if isempty(maxF) %all cases have been classified as one class, which leads to division by 0!
        num_feat_to_keep(ii) = NaN;
    else
        num_feat_to_keep(ii) = num_features - maxF; %number of features to keep for max performance in fold
    end;
    
end


end