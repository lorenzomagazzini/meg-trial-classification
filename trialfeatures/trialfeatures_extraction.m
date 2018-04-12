
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


%% feature: within-channel variance summed over channels

%loop over all trials, distinguish good and rejected trials later
nTrial = length(data.trial);
chanvarsum_arr = nan(1,nTrial);
for iTrial = 1: nTrial
    
    %select single trial
    chantimematrix = data.trial{iTrial};
%     figure, imagesc(chantimematrix)
    
    %calculate within-channel metric
    chanvar = var(chantimematrix,[],2);
    
    %sum metric across channels
    chanvarsum = sum(chanvar);
    
    %store in array
    chanvarsum_arr(iTrial) = chanvarsum;
    
end

%% feature: between-channel variance over time (we can sum this later, use sliding windows etc)

alltrials = cat(3, data.trial{:});
allvar = squeeze(var(alltrials,1))'; %trials x time

%% plot them
figure;

subplot(1,2,1); plot(1:num_bad, chanvarsum_arr(rejTrials_visual==1),'r',num_bad+1:100, chanvarsum_arr(rejTrials_visual==0),'b'); title('Within-channel variance')
subplot(1,2,2); plot(data.time{1},squeeze(mean(allvar(rejTrials_visual==1,:),1)),'r',data.time{1},squeeze(mean(allvar(rejTrials_visual==0,:),1)),'b');title('Between-channel variance')
