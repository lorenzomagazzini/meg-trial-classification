
%Lorenzo's paths:
% addpath('~/git-lab/Trial-classification/trialfeatures/')
% addpath('/home/c1356674/git-lab/ampreject/functions')

%Diana's:
% addpath('/cubric/scratch/c1465333/trial_classification/Trial-classification/trialfeatures');


%% definitions

clear

base_path = '/cubric/collab/meg-cleaning/';
cd(base_path)

%list of participants
subj_list = {'s001' 's002' 's003'};
nsubj = length(subj_list);

%define subj and task
% subj_label = 's001';
task_label = 'visuomotor';

%pre-processing (high freq)
do_bpfilt = 0;% 1;% 
bpfilt_freq = [110 140]; %e.g. for muscle artifacts

%pre-processing (low freq)
do_lpfilt = 0;% 1;% 
lpfilt_freq = 4; %e.g, for blinks and eye-movement artifacts

%prepare cell array for storing subject data structures
data_arr = cell(1,nsubj);

%loop over subjects
for s = 1:nsubj

%define subj from list
subj_label = subj_list{s};

%load data
data_path = fullfile(base_path,'rawdata');
cd(data_path)

%load raw meg data
data_filename = [subj_label '_' task_label '.mat'];
data = load(data_filename);

%preprocess data (if requested)
if do_bpfilt == 1
    
    %check settings
    if do_lpfilt == 1, error('specifying both band-pass and low-pass is not allowed'); end
    
    %preprocessing
    cfg = [];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = bpfilt_freq;
    cfg.padding = 0.5*(abs(data.time{1}(end)-data.time{1}(1)))+abs(data.time{1}(end)-data.time{1}(1));
    data = ft_preprocessing(cfg,data);
    
elseif do_lpfilt == 1
    
    %check settings
    if do_bpfilt == 1, error('specifying both low-pass and band-pass is not allowed'); end
    
    %preprocessing
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 4;
    cfg.padding = 0.5*(abs(data.time{1}(end)-data.time{1}(1)))+abs(data.time{1}(end)-data.time{1}(1));
    data = ft_preprocessing(cfg,data);
    
end

%add data to cell array
data_arr{s} = data;
clear data

end

%create new data structure by appending subjects
cfg = [];
data = ft_appenddata(cfg, data_arr{:})


%% load trial labels

%prepare for lazy concatenation
rejTrials_visual_arr = [];

%loop over subjects
for s = 1:nsubj

%define subj from list
subj_label = subj_list{s};

datalabel_path = fullfile(base_path,'trialrej');
cd(datalabel_path)

%load rejTrialsIndex_visual & rejTrials_visual
datalabel_filename = [subj_label '_' task_label '_rejTrials_visual.mat'];
load(datalabel_filename)

%concatenate
rejTrials_visual_arr = [rejTrials_visual_arr; rejTrials_visual];

end

%rename and clear
rejTrials_visual = logical(rejTrials_visual_arr);
clear rejTrials_visual_arr
clear rejTrialsIndex_visual

%trials to keep
trls_keep = ~rejTrials_visual;
trls_indx_keep = find(trls_keep);
ntrl_keep = length(trls_indx_keep);

%trials to reject
trls_rjct = rejTrials_visual;
trls_indx_rjct = find(trls_rjct);
ntrl_rjct = length(trls_indx_rjct);

ntrl = ntrl_keep+ntrl_rjct;


%rejected trials re-visited
trls_indx_rjct = [6 7 18 28 56 63 65 70 84 89 90 93 99 110 112 115 116 120 129 130 138 147 157 190 197  249 264];
trls_rjct = logical(zeros(size(rejTrials_visual)));
trls_rjct(trls_indx_rjct) = 1;
trls_keep = ~trls_rjct;
trls_indx_keep = find(trls_keep);
ntrl_keep = length(trls_indx_keep);
ntrl_rjct = length(trls_indx_rjct);
ntrl = ntrl_keep+ntrl_rjct;


%% extract trial features

% features = extract_trialfeatures(data)
% 
% %save to file
% feature_file = 'features.mat';
% cd('/cubric/collab/meg-cleaning/trialfeatures')
% save(feature_file, '-v7.3', '-struct', 'features')


%% visualise

% %run script
% cd('/cubric/collab/meg-cleaning/trialfeatures')
% visualise_trialfeatures


%% plot features pairwise

%note: features is a structure with multiple fields, but only fields of
%1xNTrial size are used for plotting

cd('/cubric/collab/meg-cleaning/trialfeatures')
features = load(feature_file);
plot_featurepairs(features, ntrl, trls_keep, trls_rjct)
set(get(gcf,'children'),'FontSize',6)


%% plot visually rejected trials

% cfg = [];
% cfg.yLim = [-1 1]*5e-12;
% cfg.title = 'Visually rejected trials';
% [hSubplots, hFigure, hTitle] = amprej_multitrialplot(cfg, data, trls_rjct)


%% metric: within-channel variance ( sum & max across channels )

% %calculate variance
% wthn_chan_var = get_wthn_chan_variance(data);

% %plot (channels x trials matrix)
% close all
% figure
% imagesc(log(wthn_chan_var'))
% colorbar
% title('log within-channel variance')
% xlabel('channels')
% ylabel('trials')
% try colormap(cmocean('amp')); catch, colormap('hot'); end

% %sum variance over channels
% wthn_chan_var_sum = sum(wthn_chan_var);
% 
% %max variance across trials
% wthn_chan_var_max = max(wthn_chan_var);

% %plot comparison of compare variance sum VS variance max
% mtrc1 = wthn_chan_var_sum;
% mtrc2 = wthn_chan_var_max;
% mtrc1_label = 'var sum';
% mtrc2_label = 'var max';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel variance ( average & max over time )

% %calculate variance
% btwn_chan_var = get_btwn_chan_variance(data);

% %plot (channels x trials matrix)
% % close all
% figure
% imagesc(log(btwn_chan_var'))
% colorbar
% title('log between-channel variance')
% xlabel('time')
% ylabel('trials')
% try colormap(cmocean('amp')); catch, colormap('hot'); end

% %average variance over time
% btwn_chan_var_avg = mean(btwn_chan_var);
% 
% %max variance across time
% btwn_chan_var_max = max(btwn_chan_var);

% %plot_metric_comparison
% mtrc1 = btwn_chan_var_avg;
% mtrc2 = btwn_chan_var_max;
% mtrc1_label = 'var avg';
% mtrc2_label = 'var max';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% compare within-channel (sum) and between-channel (avg) variance

% %plot_metric_comparison
% mtrc1 = wthn_chan_var_sum;
% mtrc2 = btwn_chan_var_avg;
% mtrc1_label = 'within-chan var sum';
% mtrc2_label = 'between-chan var avg';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% % close all
% 
% figure('color','w')
% hF = gcf;
% hF.Units = 'pixels';
% hF.Position = [0 500 1500 300];
% 
% mtrc = wthn_chan_var_sum;
% mtrc_label = 'within-channel variance sum';
% subplot(1,4,1)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = wthn_chan_var_max;
% mtrc_label = 'within-channel variance max';
% subplot(1,4,2)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = btwn_chan_var_avg;
% mtrc_label = 'between-channel variance avg';
% subplot(1,4,3)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = btwn_chan_var_max;
% mtrc_label = 'between-channel variance max';
% subplot(1,4,4)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% metric: within-channel kurtosis ( mean & max across channels )

% %calculate variance
% wthn_chan_kurt = get_wthn_chan_kurtosis(data);

% %plot (channels x trials matrix)
% % close all
% figure
% imagesc(log(wthn_chan_kurt'))
% colorbar
% title('log within-channel kurtosis')
% xlabel('channels')
% ylabel('trials')
% try colormap(cmocean('amp')); catch, colormap('hot'); end

% %sum variance over channels
% wthn_chan_kurt_mean = mean(wthn_chan_kurt);
% 
% %max variance across trials
% wthn_chan_kurt_max = max(wthn_chan_kurt);

% %plot comparison of compare variance sum VS variance max
% mtrc1 = wthn_chan_kurt_mean;
% mtrc2 = wthn_chan_kurt_max;
% mtrc1_label = 'kurt mean';
% mtrc2_label = 'kurt max';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel kurtosis ( average & max over time )

% %calculate variance
% btwn_chan_kurt = get_btwn_chan_kurtosis(data);

% %plot (channels x trials matrix)
% % close all
% figure
% imagesc(log(btwn_chan_kurt'))
% colorbar
% title('log between-channel kurtosis')
% xlabel('time')
% ylabel('trials')
% try colormap(cmocean('amp')); catch, colormap('hot'); end

% %average variance over time
% btwn_chan_kurt_mean = mean(btwn_chan_kurt);
% 
% %max variance across time
% btwn_chan_kurt_max = max(btwn_chan_kurt);

% %plot_metric_comparison
% mtrc1 = btwn_chan_kurt_mean;
% mtrc2 = btwn_chan_kurt_max;
% mtrc1_label = 'kurt mean';
% mtrc2_label = 'kurt max';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% % close all
% 
% figure('color','w')
% hF = gcf;
% hF.Units = 'pixels';
% hF.Position = [0 500 1500 300];
% 
% mtrc = wthn_chan_kurt_mean;
% mtrc_label = 'within-channel kurtosis mean';
% subplot(1,4,1)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = wthn_chan_kurt_max;
% mtrc_label = 'within-channel kurtosis max';
% subplot(1,4,2)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = btwn_chan_kurt_mean;
% mtrc_label = 'between-channel kurtosis mean';
% subplot(1,4,3)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = btwn_chan_kurt_max;
% mtrc_label = 'between-channel kurtosis max';
% subplot(1,4,4)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% compare variance with kurtosis!

% %plot_metric_comparison
% mtrc1 = btwn_chan_var_max; %between-channel variance, max across time
% mtrc2 = wthn_chan_kurt_max; %within-channel kurtosis, max across channels
% mtrc1_label = 'btwn-chan var';
% mtrc2_label = 'wthn-chan kurt';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% channel correlations (trials with artifacts will have higher between-channel correlation)
%(not sure if a noisy channel will correlate less with its neighbours)

% %calculate average correlation (of each channel with all other channels)
% chan_corr = get_chan_correlation(data);
% 
% %calculate average correlation across channels
% chan_corr_mean = mean(chan_corr);
% 
% %calculate max correlation across channels
% chan_corr_max = max(chan_corr);


% %plot
% % close all
% figure('color','w')
% hF = gcf;
% hF.Units = 'pixels';
% hF.Position = [0 500 1200 300];
% subplot(1,3,1)
% color_keep = [35,139,69]/255;
% color_rjct = [215,48,31]/255;
% color_plot = nan(ntrl,3);
% for t = 1:ntrl
%     if trls_keep(t)
%         color_plot(t,:) = color_keep;
%     else
%         color_plot(t,:) = color_rjct;
%     end
%     hold on
%     plot(chan_corr(:,t), 'color',color_plot(t,:))
%     xlim([1 size(chan_corr,1)])
%     ylim([0 1])
%     xlabel('channels')
%     ylabel('avg corr')
% end
% title('avg chan corr')
% subplot(1,3,2)
% scatter(1:ntrl, chan_corr_mean, 10, color_plot, 'filled')
% xlim([1 ntrl])
% ylim([0 1])
% xlabel('trials')
% title('mean avg chan corr')
% subplot(1,3,3)
% scatter(1:ntrl, chan_corr_max, 10, color_plot, 'filled')
% xlim([1 ntrl])
% ylim([0 1])
% xlabel('trials')
% title('max avg chan corr')
% 
% 
% %plot (channels x trials matrix)
% % close all
% figure
% imagesc(chan_corr')
% colorbar
% title('channel correlation')
% xlabel('channels')
% ylabel('trials')
% try colormap(cmocean('amp')); catch, colormap('hot'); end
% 
% 
% %plot histogram bars separately for keep and reject trials
% figure('color','w')
% hF = gcf;
% hF.Units = 'pixels';
% hF.Position = [0 500 900 300];
% 
% mtrc = chan_corr_mean;
% mtrc_label = 'mean channel correlation';
% subplot(1,2,1)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = chan_corr_max;
% mtrc_label = 'max channel correlation';
% subplot(1,2,2)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

