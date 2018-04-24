
%Lorenzo's paths:
% addpath('~/git-lab/Trial-classification/trialfeatures/')
%Diana's:
% addpath('/cubric/scratch/c1465333/trial_classification/Trial-classification/trialfeatures');


%%

clear

base_path = '/cubric/collab/meg-cleaning/';
cd(base_path)

%define subj and task
subj_label = 's001';
task_label = 'visuomotor';


%% load data

data_path = fullfile(base_path,'rawdata');
cd(data_path)

%load raw meg data
data_filename = [subj_label '_' task_label '.mat'];
data = load(data_filename);


%% load trial labels

datalabel_path = fullfile(base_path,'trialrej');
cd(datalabel_path)

%load rejTrialsIndex_visual & rejTrials_visual
datalabel_filename = [subj_label '_' task_label '_rejTrials_visual.mat'];
load(datalabel_filename)

%trials to keep
trls_keep = ~rejTrials_visual;
trls_indx_keep = find(trls_keep);
ntrl_keep = length(trls_indx_keep);

%trials to reject
trls_rjct = rejTrials_visual;
trls_indx_rjct = find(trls_rjct);
ntrl_rjct = length(trls_indx_rjct);

ntrl = ntrl_keep+ntrl_rjct;


%% plot visually rejected trials

% cfg = [];
% cfg.yLim = [-1 1]*5e-12;
% cfg.title = 'Visually rejected trials';
% [hSubplots, hFigure, hTitle] = amprej_multitrialplot(cfg, data, trls_rjct)


%% metric: within-channel variance ( sum & max across channels )

%calculate variance
wthn_chan_var = get_wthn_chan_variance(data);

%plot (channels x trials matrix)
close all
figure
imagesc(log(wthn_chan_var'))
colorbar
title('log within-channel variance')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%sum variance over channels
wthn_chan_var_sum = sum(wthn_chan_var);

%max variance across trials
wthn_chan_var_max = max(wthn_chan_var);

%plot comparison of compare variance sum VS variance max
mtrc1 = wthn_chan_var_sum;
mtrc2 = wthn_chan_var_max;
mtrc1_label = 'var sum';
mtrc2_label = 'var max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel variance ( average & max over time )

%calculate variance
btwn_chan_var = get_btwn_chan_variance(data);

%plot (channels x trials matrix)
% close all
figure
imagesc(log(btwn_chan_var'))
colorbar
title('log between-channel variance')
xlabel('time')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%average variance over time
btwn_chan_var_avg = mean(btwn_chan_var);

%max variance across time
btwn_chan_var_max = max(btwn_chan_var);

% plot_metric_comparison
mtrc1 = btwn_chan_var_avg;
mtrc2 = btwn_chan_var_max;
mtrc1_label = 'var avg';
mtrc2_label = 'var max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% compare within-channel (sum) and between-channel (avg) variance

% plot_metric_comparison
mtrc1 = wthn_chan_var_sum;
mtrc2 = btwn_chan_var_avg;
mtrc1_label = 'within-chan var sum';
mtrc2_label = 'between-chan var avg';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% close all

figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1500 300];

mtrc = wthn_chan_var_sum;
mtrc_label = 'within-channel variance sum';
subplot(1,4,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_var_max;
mtrc_label = 'within-channel variance max';
subplot(1,4,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_var_avg;
mtrc_label = 'between-channel variance avg';
subplot(1,4,3)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_var_max;
mtrc_label = 'between-channel variance max';
subplot(1,4,4)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% %% metric: within-channel kurtosis ( mean & max across channels )

%calculate variance
wthn_chan_kurt = get_wthn_chan_kurtosis(data);

%plot (channels x trials matrix)
% close all
figure
imagesc(log(wthn_chan_kurt'))
colorbar
title('log within-channel kurtosis')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%sum variance over channels
wthn_chan_kurt_mean = mean(wthn_chan_kurt);

%max variance across trials
wthn_chan_kurt_max = max(wthn_chan_kurt);

%plot comparison of compare variance sum VS variance max
mtrc1 = wthn_chan_kurt_mean;
mtrc2 = wthn_chan_kurt_max;
mtrc1_label = 'kurt mean';
mtrc2_label = 'kurt max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel kurtosis ( average & max over time )

%calculate variance
btwn_chan_kurt = get_btwn_chan_kurtosis(data);

%plot (channels x trials matrix)
% close all
figure
imagesc(log(btwn_chan_kurt'))
colorbar
title('log between-channel kurtosis')
xlabel('time')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%average variance over time
btwn_chan_kurt_mean = mean(btwn_chan_kurt);

%max variance across time
btwn_chan_kurt_max = max(btwn_chan_kurt);

% plot_metric_comparison
mtrc1 = btwn_chan_kurt_mean;
mtrc2 = btwn_chan_kurt_max;
mtrc1_label = 'kurt mean';
mtrc2_label = 'kurt max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% close all

figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1500 300];

mtrc = wthn_chan_kurt_mean;
mtrc_label = 'within-channel kurtosis mean';
subplot(1,4,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_kurt_max;
mtrc_label = 'within-channel kurtosis max';
subplot(1,4,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_kurt_mean;
mtrc_label = 'between-channel kurtosis mean';
subplot(1,4,3)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_kurt_max;
mtrc_label = 'between-channel kurtosis max';
subplot(1,4,4)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% compare variance with kurtosis!

% plot_metric_comparison
mtrc1 = btwn_chan_var_max; %between-channel variance, max across time
mtrc2 = wthn_chan_kurt_max; %within-channel kurtosis, max across channels
mtrc1_label = 'btwn-chan var';
mtrc2_label = 'wthn-chan kurt';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% channel correlations (trials with artifacts will have higher between-channel correlation)
%(not sure if a noisy channel will correlate less with its neighbours)

chan_corr = get_chan_correlation(data);

figure
color_keep = [35,139,69]/255;
color_rjct = [215,48,31]/255;
for t = 1:size(chan_corr,2)
    if trls_keep(t)
        tmp_color = color_keep;
    else
        tmp_color = color_rjct;
    end
    hold on
    plot(chan_corr(:,t), 'color',tmp_color)
end

mean_chan_corr = mean(chan_corr,1);

%plot (channels x trials matrix)
% close all
figure
imagesc(chan_corr')
colorbar
title('channel correlation')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end


% plot histogram bars separately for keep and reject trials
figure('color','w')

mtrc = mean_chan_corr;
mtrc_label = 'mean channel correlation';
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% metric: Hurst exponent ( average & range across channels )

%calculate variance
hexp = get_hurst_exponent(data);

%plot (channels x trials matrix)
close all
figure
imagesc(hexp')
colorbar
title('Hurst exponent')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%average Hurst exp across channels
hexp_mean = mean(hexp);

%range of Hurst exp across channels (any deviation whether + or - can indicate noise)
hexp_range = max(hexp) - min(hexp);

% plot_metric_comparison
mtrc1 = hexp_mean;
mtrc2 = hexp_range;
mtrc1_label = 'Hurst exp mean';
mtrc2_label = 'Hurst exp range';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

close all

figure('color','w')

mtrc = hexp_mean;
mtrc_label = 'Hurst exponent mean';
subplot(1,2,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = hexp_range;
mtrc_label = 'Hurst exponent range';
subplot(1,2,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

%% deviation of trial from other trials - tentative...
% if using supervised ML - this has to be applied while maintaining
% train/test independence....

trl_dev = get_trial_deviation(data);
sum_trl_dev = sum(abs(trl_dev),1); %sum of deviations across channels

% plot histogram bars separately for keep and reject trials

figure('color','w')

mtrc = sum_trl_dev;
mtrc_label = 'sum trial deviation';
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% Do we still need this?
% feature: z-value modelled after ft_artifact_zvalue


cfg = [];
cfg.bpfilter = 'yes';
cfg.bpfreq = [110 140]; %e.g. for muscle artifacts
cfg.bpfiltord = 8;
hf = ft_preprocessing(cfg,data);
trl = cat(3,hf.trial{:});

sumval = nansum(trl,2); %sum amplitudes across samples
sumsq = nansum(trl.^2,2); %sum of squares across samples
datavg = squeeze(sumval./size(trl,2)); %average for all channels
datstd = squeeze(sqrt(sumsq./size(trl,2) - (sumval./size(trl,2)).^2)); %SD for all channels

%now create z-score data matrix by looping through trials
zdata = zeros(size(trl));
for i = 1:size(trl,3)
    zdata(:,:,i) = (trl(:,:,i) - datavg(:,i*ones(1,size(trl,2))))./datstd(:,i*ones(1,size(trl,2)));
end;

%get summary metrics of z-scores across channles
zsum = squeeze(nansum(zdata,1))';
zmax = squeeze(max(zdata,[],1))';
%zvar = squeeze(var(zdata,[],1))';

demean = 0; %demean flag - CHANGE ME
if demean
    for ii = 1:size(zmax,1)
        zmax(ii,:) = zmax(ii,:) - mean(zmax(ii,:),2);
        zsum(ii,:) = zsum(ii,:) - mean(zsum(ii,:),2);
        %zvar(ii,:) = zvar(ii,:) - mean(zvar(ii,:),2);
    end;
end;
zvar = zsum./sqrt(size(trl,1)); 

%plot z-value metrics
figure;
subplot(3,2,1); plot(1:num_bad, var(zvar(trls_rjct,:),[],2),'.r',num_bad+1:100, var(zvar(trls_keep,:),[],2),'.b'); title('Variance of z-value'); 
subplot(3,2,2); plot(1:num_bad, var(zmax(trls_rjct,:),[],2),'.r',num_bad+1:100, var(zmax(trls_keep,:),[],2),'.b'); title('Maximal z-value')
subplot(3,2,3); plot(data.time{1},zvar(trls_rjct,:),'r');title('Var z (per trial - bad)'); ylim([min(zvar(:)) max(zvar(:))])
subplot(3,2,4); plot(data.time{1},zvar(trls_keep,:),'b');title('Var z (per trial - good)'); ylim([min(zvar(:)) max(zvar(:))])
subplot(3,2,5); plot(data.time{1},zmax(trls_rjct,:),'r');title('Max z-value (per trial - bad)'); ylim([min(zmax(:)) max(zmax(:))])
subplot(3,2,6); plot(data.time{1},zmax(trls_keep,:),'b');title('Max z-value (per trial - good)'); ylim([min(zmax(:)) max(zmax(:))])



