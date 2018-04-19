
%Lorenzo's paths:
% addpath('~/git-lab/Trial-classification/trialfeatures/')


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
data = load(data_filename)


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
close all
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

close all

figure('color','w')

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


%% plot both types of variance (Diana's)

mtrcA = wthn_chan_var_sum;

figure;
subplot(2,2,1); plot(1:ntrl_rjct, mtrcA(trls_rjct),'.r',ntrl_rjct+1:ntrl, mtrcA(trls_keep),'.b'); title('Within-channel variance (per trial)')
subplot(2,2,2); plot(data.time{1},squeeze(median(btwn_chan_var(:,trls_rjct),2)),'r',data.time{1},squeeze(median(btwn_chan_var(:,trls_keep),2)),'b');title('Between-channel variance (median)')
subplot(2,2,3); plot(data.time{1},btwn_chan_var(:,trls_rjct),'r');title('Between-channel variance (per trial - bad)')
subplot(2,2,4); plot(data.time{1},btwn_chan_var(:,trls_keep),'b');title('Between-channel variance (per trial - good)')


%%                  !!! NOTE !!!

%the following code hasn't been checked by Lorenzo yet


%% feature: z-value modelled after ft_artifact_zvalue


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

%% feature: kurtosis
trl = cat(3, data.trial{:});
kurt = kurtosis(trl,[],2); %kurtosis along time axis
kurt_sum = squeeze(sum(kurt,1)); %sum it across channels
kurt_chan = squeeze(kurtosis(trl,[],1)); %kurtosis along channel axis
kurt_chan_mean = squeeze(mean(kurt,1)); %average it over time

figure;
subplot(2,2,1); plot(1:num_bad, kurt_sum(trls_rjct),'.r',num_bad+1:100, kurt_sum(trls_keep),'.b'); title('Time kurtosis summed across channels'); 
subplot(2,2,2); plot(1:num_bad, kurt_chan_mean(trls_rjct),'.r',num_bad+1:100, kurt_chan_mean(trls_keep),'.b'); title('Channel kurtosis averaged across time'); 
subplot(2,2,3); plot(data.time{1},kurt_chan(:,trls_rjct),'r');title('Channel kurtosis'); ylim([min(kurt_chan(:)) max(kurt_chan(:))])
subplot(2,2,4); plot(data.time{1},kurt_chan(:,trls_keep),'b');title('Channel kurtosis'); ylim([min(kurt_chan(:)) max(kurt_chan(:))])

