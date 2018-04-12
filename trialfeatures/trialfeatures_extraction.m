
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

