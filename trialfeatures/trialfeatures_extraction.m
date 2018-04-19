
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


%% plot visually rejected trials

% cfg = [];
% cfg.yLim = [-1 1]*5e-12;
% cfg.title = 'Visually rejected trials';
% [hSubplots, hFigure, hTitle] = amprej_multitrialplot(cfg, data, trls_rjct)


%% metric: within-channel variance (sum & max across trials)

%calculate variance
wthn_chan_var = get_wthn_chan_variance(data);

%sum variance over channels
wthn_chan_var_sum = sum(wthn_chan_var);

%max variance across trials
wthn_chan_var_max = max(wthn_chan_var);


%% plot within-channel  stuff

% %plot (channels x trials matrix)
% mtrc = wthn_chan_var;
% figure
% imagesc(log(mtrc))
% % colormap(cmocean('amp'))

%compare variance sum VS variance max
mtrc1 = wthn_chan_var_sum;
mtrc2 = wthn_chan_var_max;
mtrc1_label = 'var sum';
mtrc2_label = 'var max';
plot_wthn_chan_variance_comparison( mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct )


%% feature: between-channel variance over time (we can sum this later, use sliding windows etc)

trl = cat(3, data.trial{:});
allvar = squeeze(var(trl,[],1))'; %variance across channels: trials x time matrix

btwnchanvarmax_arr = max(allvar,[],2);


%% plot both types of variance
figure;
subplot(2,2,1); plot(1:num_bad, chanvarsum_arr(trls_rjct==1),'.r',num_bad+1:100, chanvarsum_arr(trls_keep),'.b'); title('Within-channel variance (per trial)')
subplot(2,2,2); plot(data.time{1},squeeze(median(allvar(trls_rjct,:),1)),'r',data.time{1},squeeze(median(allvar(trls_keep,:),1)),'b');title('Between-channel variance (median)')
subplot(2,2,3); plot(data.time{1},allvar(trls_rjct,:),'r');title('Between-channel variance (per trial - bad)')
subplot(2,2,4); plot(data.time{1},allvar(trls_keep,:),'b');title('Between-channel variance (per trial - good)')
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


%% plot histogram bars separately for keep and reject trials

close all

% metric_toplot = chanvarsum_arr;
% metric_toplot = chanvarmax_arr;
% metric_toplot = btwnchanvarmax_arr;
% metric_toplot = kurt_sum;
metric_toplot = kurt_chan_mean;

n_bins = 20;
hist_bins = linspace(min(metric_toplot), max(metric_toplot), n_bins);
hist_step = hist_bins(2)-hist_bins(1);

metric_keptrials = metric_toplot(trls_keep);
n_keptrials = length(metric_keptrials);
[keptrials_hist_freq, keptrials_hist_bins] = hist(metric_keptrials, hist_bins);

metric_rejtrials = metric_toplot(trls_rjct);
n_rejtrials = length(metric_rejtrials);
[rejtrials_hist_freq, rejtrials_hist_bins] = hist(metric_rejtrials, hist_bins);

figure('color','w')
hold on
h_kepbar = bar(keptrials_hist_bins-(hist_step/10), keptrials_hist_freq, 'facecolor',[.4 .4 .4]);
h_rejbar = bar(rejtrials_hist_bins+(hist_step/10), rejtrials_hist_freq, 'facecolor',[1 .4 .4]);

xlabel('summed within-channel variance')
ylabel('n trials')
h_leg = legend([h_kepbar, h_rejbar], [num2str(n_keptrials) ' keep trials'], [num2str(n_rejtrials) ' reject trials']);
h_leg.Box = 'off';


