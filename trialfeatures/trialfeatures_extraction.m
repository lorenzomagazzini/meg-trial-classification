
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

num_bad = length(rejTrialsIndex_visual);
num_good = length(rejTrials_visual)-num_bad;

%% plot visually rejected trials

cfg = [];
cfg.yLim = [-1 1]*5e-12;
cfg.title = 'Visually rejected trials';
[hSubplots, hFigure, hTitle] = amprej_multitrialplot(cfg, data, rejTrials_visual)


%% feature: within-channel variance summed over channels and max across trials

%loop over all trials, distinguish good and rejected trials later
nTrial = length(data.trial);
chanvarsum_arr = nan(1,nTrial);
chanvarmax_arr = nan(1,nTrial);
for iTrial = 1: nTrial
    
    %select single trial
    chantimematrix = data.trial{iTrial};
%     figure, imagesc(chantimematrix)
    
    %calculate within-channel variance
    chanvar = var(chantimematrix,[],2);
    
    %sum variance over channels
    chanvarsum = sum(chanvar);
    
    %max variance across trials
    chanvarmax = max(chanvar);
    
    %store in array
    chanvarsum_arr(iTrial) = chanvarsum;
    chanvarmax_arr(iTrial) = chanvarmax;
    
end


%% plot histogram bars separately for keep and reject trials

close all

metric_toplot = chanvarsum_arr;
% metric_toplot = chanvarmax_arr;

n_bins = 20;
hist_bins = linspace(min(metric_toplot), max(metric_toplot), n_bins);
hist_step = hist_bins(2)-hist_bins(1);

metric_keptrials = metric_toplot(rejTrials_visual==0);
n_keptrials = length(metric_keptrials);
[keptrials_hist_freq, keptrials_hist_bins] = hist(metric_keptrials, hist_bins);

metric_rejtrials = metric_toplot(rejTrials_visual==1);
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


%% feature: between-channel variance over time (we can sum this later, use sliding windows etc)

trl = cat(3, data.trial{:});
allvar = squeeze(var(trl,[],1))'; %variance across channels: trials x time matrix

%% plot both types of variance
figure;
subplot(2,2,1); plot(1:num_bad, chanvarsum_arr(rejTrials_visual==1),'.r',num_bad+1:100, chanvarsum_arr(rejTrials_visual==0),'.b'); title('Within-channel variance (per trial)')
subplot(2,2,2); plot(data.time{1},squeeze(median(allvar(rejTrials_visual==1,:),1)),'r',data.time{1},squeeze(median(allvar(rejTrials_visual==0,:),1)),'b');title('Between-channel variance (median)')
subplot(2,2,3); plot(data.time{1},allvar(rejTrials_visual==1,:),'r');title('Between-channel variance (per trial - bad)')
subplot(2,2,4); plot(data.time{1},allvar(rejTrials_visual==0,:),'b');title('Between-channel variance (per trial - good)')
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
subplot(3,2,1); plot(1:num_bad, var(zvar(rejTrials_visual==1,:),[],2),'.r',num_bad+1:100, var(zvar(rejTrials_visual==0,:),[],2),'.b'); title('Variance of z-value'); 
subplot(3,2,2); plot(1:num_bad, var(zmax(rejTrials_visual==1,:),[],2),'.r',num_bad+1:100, var(zmax(rejTrials_visual==0,:),[],2),'.b'); title('Maximal z-value')
subplot(3,2,3); plot(data.time{1},zvar(rejTrials_visual==1,:),'r');title('Var z (per trial - bad)'); ylim([min(zvar(:)) max(zvar(:))])
subplot(3,2,4); plot(data.time{1},zvar(rejTrials_visual==0,:),'b');title('Var z (per trial - good)'); ylim([min(zvar(:)) max(zvar(:))])
subplot(3,2,5); plot(data.time{1},zmax(rejTrials_visual==1,:),'r');title('Max z-value (per trial - bad)'); ylim([min(zmax(:)) max(zmax(:))])
subplot(3,2,6); plot(data.time{1},zmax(rejTrials_visual==0,:),'b');title('Max z-value (per trial - good)'); ylim([min(zmax(:)) max(zmax(:))])

%% feature: kurtosis
trl = cat(3, data.trial{:});
kurt = kurtosis(trl,[],2); %kurtosis along time axis
kurt_sum = squeeze(sum(kurt,1)); %sum it across channels
kurt_chan = squeeze(kurtosis(trl,[],1)); %kurtosis along channel axis
kurt_chan_mean = squeeze(mean(kurt,1)); %average it over time

figure;
subplot(2,2,1); plot(1:num_bad, kurt_sum(rejTrials_visual==1),'.r',num_bad+1:100, kurt_sum(rejTrials_visual==0),'.b'); title('Time kurtosis summed across channels'); 
subplot(2,2,2); plot(1:num_bad, kurt_chan_mean(rejTrials_visual==1),'.r',num_bad+1:100, kurt_chan_mean(rejTrials_visual==0),'.b'); title('Channel kurtosis averaged across time'); 
subplot(2,2,3); plot(data.time{1},kurt_chan(:,rejTrials_visual==1),'r');title('Channel kurtosis'); ylim([min(kurt_chan(:)) max(kurt_chan(:))])
subplot(2,2,4); plot(data.time{1},kurt_chan(:,rejTrials_visual==0),'b');title('Channel kurtosis'); ylim([min(kurt_chan(:)) max(kurt_chan(:))])

