% this script runs a linear SVM with different types of cross-validation 
% on features from MEG partnership data.
%% paths and definitions

%Lorenzo's paths:
% addpath(genpath('~/git-lab/Trial-classification/'))
%Diana's:
addpath(genpath('/cubric/scratch/c1465333/trial_classification/Trial-classification/'));

%output_path = '/cubric/collab/meg-cleaning/classification/';
feature_path = '/cubric/collab/meg-cleaning/cdf/resteyesopen/trainfeatures/';
base_path = '/cubric/collab/meg-cleaning/';

filenames = dir(feature_path);
filenames = {filenames(3:end-1).name};
feature_set = input('Choose feature set to use: max, within, between, within-between, single-value: ', 's');
output_path = [base_path 'classification/output/' feature_set '/'];

%% read in features and labels for each subject
all_data = cell(1,length(filenames));
all_labels = cell(1,length(filenames));

for s = 1:length(filenames)
    
    all_feat = [];
    load([feature_path filenames{s}]);
    
    for f = 1:3
        
        feat = features(f); %each filtering condition
        
        data = get_svm_data(feat, feature_set);
        all_feat = [all_feat data];
        
    end;
    
    all_data{s} = all_feat; %broadband, high-pass, low-pass features concatenated
    all_labels{s} = double(trl_idx); 
    
end;

%% (1) kfold CV on all participants

% data_kfold = cat(1,all_data{:});
% labels_kfold = cat(1,all_labels{:});
% 
% results = svm_decode_kfold(data_kfold,labels_kfold, 'weights',true);
% save([output_path 'results_5foldcv_allfeat.mat'],'results');

%% (2) leave-one-subject-out cross-validation
clearvars -EXCEPT all_data all_labels feature_path output_path filenames feature_set;

for fold = 1:length(all_data)
    
    testdata = all_data{fold};
    testlabels = all_labels{fold}';
    traindata = all_data; traindata(fold) = []; traindata = cat(1,traindata{:});
    trainlabels = all_labels; trainlabels(fold) = []; trainlabels = cat(2,trainlabels{:})';
    
    res = svm_decode_holdout(traindata, trainlabels, testdata, testlabels, 'weights', true);
    results(fold) = res;
    
end;

save([output_path 'results_loo_cdf.mat'],'results');

%% (3) separate classification on each feature set; note - I haven't updated this and need some more sensible indexing here
switch feature_set
    case 'max'
        setsize = 5;
    case 'within'
        setsize = 272*3;
    case 'between' 
        setsize = 1201*2;
    case 'within-between'
        setsize = 272*3+1201*2;
    case 'single-value'
        setsize = 8;
end;

results = cell(1,3);
data_kfold = cat(1,all_data{:});
labels_kfold = cat(1,all_labels{:});
feat_idx = 1:setsize:size(data_kfold,2); %doing this manually for now

for f = 1:3
    
    data = data_kfold(:,feat_idx(f):feat_idx(f)+setsize-1);
    results{f} = svm_decode_kfold(data,labels_kfold,'weights',true);
end;

save([output_path 'results_5foldcv_feat_sets.mat'],'results');

%% (4) cross-participant -- deprecated (for previous 3-participant set)

results = cell(3,3);

for fold = 1:3
    
    testdata_all = all_data{fold};
    testlabels = all_labels{fold};
    traindata_all = all_data; traindata_all(fold) = []; traindata_all = cat(1,traindata_all{:});
    trainlabels = all_labels; trainlabels(fold) = []; trainlabels = cat(1,trainlabels{:});
    
    for f = 1:3
        
        traindata = traindata_all(:,feat_idx(f):feat_idx(f)+setsize-1);
        testdata = testdata_all(:,feat_idx(f):feat_idx(f)+setsize-1);
        
        results{fold,f} = svm_decode_holdout(traindata, trainlabels, testdata, testlabels, 'weights', true);
        
    end
    
end

save([output_path 'results_cross_subj_feat_sets.mat'],'results');

%% (5) RFE on full dataset
% this would take a while with thousands of features

% data_kfold = cat(1,all_data{:});
% labels_kfold = cat(1,all_labels{:});
% 
% [num_feat, Fscores] = RFE_CV(data_kfold,labels_kfold,'kfold',5);
% num_features = mode(num_feat);
% [data_RFE, idx_RFE] = RFE(data_kfold, labels_kfold, num_features);
% 
% % check what performance we get after this - although note that we should use separate sets for feature selection & testing
% results = svm_decode_kfold(data_RFE,labels_kfold,'weights',true); %this is not better!
% 
% save([output_path 'RFE_results.mat'],'data_RFE','idx_RFE','results','num_features','num_feat');
