
%Lorenzo's paths:
% addpath('~/git-lab/Trial-classification/trialfeatures/')
% addpath('/home/c1356674/git-lab/ampreject/functions')

%Diana's:
% addpath('/cubric/scratch/c1465333/trial_classification/Trial-classification/trialfeatures');

clear

%path to collab
base_path = '/cubric/collab/meg-cleaning/cdf/resteyesopen';
cd(base_path)

%path to raw data (.mat files)
data_path = fullfile(base_path, 'traindata');

%path to bad trials index (classifier labels)
label_path = fullfile(base_path, 'trainlabels');

%savepath for extracted features
% feature_path = fullfile(base_path, 'trainfeatures');
feature_path = fullfile(base_path, 'trainfeatures_sw');

%list of files
dir_struct = dir(fullfile(data_path, 'sub-*epoched.mat'));
file_list = {dir_struct(:).name}';
nsubj = length(file_list);

%% load and preprocess data for each filtering condition

%set filtering flags and save indexing order for later
hpfilt = [0,1,0]; lpfilt = [0,0,1];
filtering_order = {'broadband','high-pass','low-pass'};

%loop over subjects
for s = 1:20%:nsubj
    
    %load data
    cd(data_path)
    data = load(file_list{s});
    
    for filt = 1:3 %giant filtering loop
        
        
        %pre-processing (high freq) e.g. for muscle artifacts
        do_hpfilt = hpfilt(filt);% 1;%
        hpfilt_freq = 90;% [110 140];
        
        %pre-processing (low freq) e.g, for blinks and eye-movement artifacts
        do_lpfilt = lpfilt(filt);% 1;%
        lpfilt_freq = 4;
        
        %prepare cell array for storing subject data structures
        data_arr = cell(1,nsubj);

        %preprocess data (if requested)
        if do_hpfilt == 1
            
            %check settings
            if do_lpfilt == 1, error('specifying both band-pass and low-pass is not allowed'); end
            fprintf('\nPerforming high-pass filtering...');
            
            %preprocessing
            cfg = [];
            cfg.hpfilter = 'yes';
            cfg.hpfreq = hpfilt_freq;
            cfg.padding = 2*ceil(abs(data.time{1}(end)-data.time{1}(1)));
            cfg.channel = 'MEG';
            cfg.demean = 'yes';
            data = ft_preprocessing(cfg,data);
            
        elseif do_lpfilt == 1
            
            %check settings
            if do_hpfilt == 1, error('specifying both low-pass and band-pass is not allowed'); end
            fprintf('\nPerforming low-pass filtering...');
            
            %preprocessing
            cfg = [];
            cfg.lpfilter = 'yes';
            cfg.lpfreq = 4;
            cfg.padding = 2*ceil(abs(data.time{1}(end)-data.time{1}(1)));
            cfg.channel = 'MEG';
            cfg.demean = 'yes';
            data = ft_preprocessing(cfg,data);
            
        else
            
            %select channels,demean and any other preproc we might need
            cfg = [];
            cfg.channel = 'MEG';
            cfg.demean = 'yes';
            data = ft_preprocessing(cfg,data);
            
        end
        
        
        %now load the trial labels
        label_filename = strrep(file_list{s}, 'meg-epoched', 'epoch-labels');
        load(fullfile(label_path, label_filename));
        %create trial index
        trl_idx = zeros(1,length(data.trial)); trl_idx(badtrialsindex) = 1;
        
%         f = extract_trialfeatures(data);
        f = extract_trialfeatures_sw(data);
        features(filt) = deal(f);
        
    end
    
    save(fullfile(feature_path, [num2str(s,'%02d') 'features.mat']), '-v7.3', 'filtering_order','trl_idx','features'); %keeping this as struct - as coded in svm data extraction script; labels are also here
    clear features;
end

%% get MDS plots
for i = 1:20
    
    load([feature_path num2str(i,'%02d') 'features.mat']);
    plot_mds_features(features, trl_idx, sprintf('/cubric/collab/meg-cleaning/cdf/resteyesopen/trainfeatures/mds/%d_mds',i))
    
end