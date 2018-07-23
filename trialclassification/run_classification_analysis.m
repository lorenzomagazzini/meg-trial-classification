function [  ] = run_classification_analysis( featurefiles, savepath )
%Extracts requested set of features from series of files, runs a linear classifier and plots results.
%Inputs:
%       featurefiles = file(s) containing features extracted using feature
%                      extraction code. If several, can be provided as cell array. Each
%                      file must contain variables: features, trl_idx, filtering_order.
%       savepath = path to where the results should be saved.
%
%Outputs:
%       1. Runs a within-subject 5-fold cross-validation analysis for each file (assumed
%          to correspond to each subject). Results are saved and plotted.
%       2. Runs a cross-subject leave-one-subject out CV, and a
%          cross-subject 5-fold CV (If several files provided). Results are plotted and saved.
%
%The function will ask for your input: 1. to choose the feature metrics to extract
%                                      2. to decide if majority class should be subsampled
%                                      3. to select which filtered features you want to use.
%
% DC Dima 2018 (diana.dima@gmail.com)

%Choose what feature set you want to test (see get_svm_data.m):
feature_set = input('Choose feature set to use: max, within, between, within-between, single-value: ', 's');

%Choose if you want to subsample the majority class, so as to have balanced classes:
do_balance = input('Balance classes? 0 = no, 1 = yes: ');

all_data = cell(1,length(featurefiles)); all_labels = cell(1,length(featurefiles));
results_kfold = struct; 

%Loop through files, extracting data.
for subject = 1:length(featurefiles)

    %Load file containing extracted trial features:
    load(featurefiles{subject}, 'features', 'filtering_order','trl_idx'); %load structure containing features, filter indices, and trial labels
 
    %Select the filter you want to use for features:
    if length(features)>1
        if subject==1 %only ask for input once, but check correct indexing for every file separately
            fidx = input('Select 1 (broadband features), 2 (high-pass features), or 3 (low-pass features):');
        end
        if fidx==1 %make sure we got the indices right
            f = find(strcmp(filtering_order,'broadband')); 
        elseif fidx==2
            f = find(strcmp(filtering_order,'high-pass'));
        elseif fidx==3
            f = find(strcmp(filtering_order,'low-pass'));
        end
    end
       
    %Extract the features requested:
    data = get_svm_data(features(f), feature_set);
    
    %Randomly subsample majority class if requested:
    if do_balance
        class1 = find(trl_idx==0); class2 = find(trl_idx==1); d = length(class1)-length(class2);
        if d>0
            rm_idx = class1(randperm(length(class1),d));
        elseif d<0
            rm_idx = class2(randperm(length(class2),abs(d)));
        end
        data(rm_idx,:) = [];
    end
    
    labels = double(trl_idx); %convert labels to double
    
    %Run 5-fold cross-validation within-subject:
    results_kfold(subject) = svm_decode_kfold(data,labels', 'weights',true);
    
    all_data{subject} = data; all_labels{subject} = labels;
    
end

    %Plot within-subject kfold results:
    figure; plot_classification_results(results_kfold);
    save(fullfile(savepath, 'results_kfold_within.mat'), 'results_kfold');
    
    %Next, cross-subject analyses, if several datasets were input.
    if length(all_data)>1
        
        %Run leave-one-subject-out cross-validation, and plot results:  
        results_loocv = struct;
        for fold = 1:length(all_data)
            
            testdata = all_data{fold};
            testlabels = all_labels{fold}';
            traindata = all_data; traindata(fold) = []; traindata = cat(1,traindata{:});
            trainlabels = all_labels; trainlabels(fold) = []; trainlabels = cat(2,trainlabels{:})';
            
            res = svm_decode_holdout(traindata, trainlabels, testdata, testlabels, 'weights', true);
            results_loocv(fold) = res;
        end
        
        figure;plot_loocv_classification_results(results_loocv);
        save(fullfile(savepath, 'results_loocv.mat'), 'results_loocv');
        
        %Finally, run 5-fold cross-validation across subjects:
        all_data_kfold = cat(1,all_data{:});
        all_labels_kfold = cat(2,all_labels{:});
        results_kfold_across = svm_decode_kfold(all_data_kfold,all_labels_kfold', 'weights',true);
        
        figure; plot_classification_results(results_kfold_across);
        save(fullfile(savepath, 'results_kfold_across.mat'), 'results_kfold_across');
        
    end
    
end

