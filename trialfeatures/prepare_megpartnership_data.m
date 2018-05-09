
%Lorenzo's paths:
addpath('/home/c1356674/git-lab/Trial-classification/trialfeatures/')
addpath('/home/c1356674/git-lab/ampreject/functions')
addpath('/cubric/collab/meg-partnership/git-lab/meguk-data-management/meguk_anonym')

%CUBRIC paths:
addpath('/cubric/software/MEG/CUBRIC/FileIO/ctf/')


clear

%path to MEG Partnership data in collab
base_path = '/cubric/collab/meg-partnership/Analysis';

%path to save data temporarily, before copying to final destination path
temp_savepath = '/cubric/scratch/c1356674/meg-cleaning/tempdata';
if ~exist(temp_savepath,'dir'), mkdir(temp_savepath); end
unix(['chmod -R 700 ' temp_savepath])
unix('chmod 700 /cubric/scratch/c1356674/meg-cleaning/')

%path to save data and bad trials .mat files
data_savepath = '/cubric/collab/meg-cleaning/megpartnership/restopen/traindata';
if ~exist(data_savepath,'dir'), mkdir(data_savepath); end
unix(['chmod -R 700 ' data_savepath])
unix('chmod 700 /cubric/collab/meg-cleaning/megpartnership/restopen/')
unix('chmod 700 /cubric/collab/meg-cleaning/megpartnership/')

%path to save figures
fig_savepath = '/cubric/collab/meg-cleaning/megpartnership/restopen/trainfigures';
if ~exist(fig_savepath,'dir'), mkdir(fig_savepath); end
unix(['chmod -R 700 ' fig_savepath])


%% get list of participants

cd(base_path)
tmp_dir = dir('7*');

subj_list = {tmp_dir(:).name}';
clear tmp*

nsubj = length(subj_list);


%% read data and ClassFile

%definitions for filtering/plotting
hp_freq = 100;
lp_freq = 4;

%every other subject, starting from first subj (training data)
for s = 1:2:nsubj
    
    
    %subject ID and dataset
    subj = subj_list{s};
    tmp_dir = dir(fullfile(base_path, subj, [subj '*RestO*']));
    dataset = fullfile(base_path, subj, tmp_dir.name);
    clear tmp*
    
    
    %raw data, high-pass filtered
    cfg = [];
    cfg.dataset = dataset;
    cfg.channel = {'MEG'};
    cfg.hpfilter = 'yes';
    cfg.hpfreq = 1;
    data = ft_preprocessing(cfg)
    
    %anonymise data
    data.cfg.dataset = '';
    data.cfg.datafile = '';
    data.cfg.headerfile = '';
    data.cfg.callinfo = [];
    
    
    %index to bad trials
    classfile = fullfile(dataset, 'ClassFile.cls');
    trialclass = readClassFile(classfile);
    badtrialsindex = trialclass.trial
    
    %boolean bad trials array
    badtrialsboolean = zeros(1,length(data.trial));
    badtrialsboolean(badtrialsindex) = 1;
    
    
    %save data to temporary path
    id = partnership2meguk(subj, '/cubric/collab/meg-partnership/cardiff/private/id_conversion_cardiff.mat');
    data_savename = ['sub-' id '_data.mat'];
    save(fullfile(temp_savepath, data_savename), '-v7.3', '-struct', 'data')
    
    %save bad trials to temporary path
    badtrials_savename = ['sub-' id '_cls-bethvisual.mat'];
    save(fullfile(temp_savepath, badtrials_savename), '-v7.3', 'badtrialsindex', 'badtrialsboolean')
    
    
    close all
    
    %plot bad trials
    cfg = [];
    cfg.yLim = [-1 1]*5e-12;
    cfg.title = 'Visually rejected trials';
    cfg.drawnow = 'no';
    [~, hFigure1] = amprej_multitrialplot(cfg, data, badtrialsboolean);
    drawnow
    pause(1)
    
    %save figure to temporary path
    fig_savename = ['sub-' id '_cls-bethvisual_broadband.png'];
    saveas(hFigure1, fullfile(temp_savepath, fig_savename))
    
    
    %high-pass filter data
    cfg = [];
    cfg.hpfilter = 'yes';
    cfg.hpfreq = hp_freq;
    data_hp = ft_preprocessing(cfg, data)
    
    %plot bad trials
    cfg = [];
    cfg.yLim = [-1 1]*5e-12;
    cfg.title = ['Visually rejected trials (high-pass ' num2str(hp_freq) ' Hz)'];
    cfg.drawnow = 'no';
    [~, hFigure2] = amprej_multitrialplot(cfg, data_hp, badtrialsboolean);
    drawnow
    pause(1)
    
    %save figure to temporary path
    fig_savename = ['sub-' id '_cls-bethvisual_hp-' num2str(hp_freq) 'Hz.png'];
    saveas(hFigure2, fullfile(temp_savepath, fig_savename))
    
    
    %low-pass filter data
    cfg = [];
    cfg.lpfilter = 'yes';
    cfg.lpfreq = lp_freq;
    data_lp = ft_preprocessing(cfg, data)
    
    %plot bad trials
    cfg = [];
    cfg.yLim = [-1 1]*5e-12;
    cfg.title = ['Visually rejected trials (low-pass ' num2str(lp_freq) ' Hz)'];
    cfg.drawnow = 'no';
    [~, hFigure3] = amprej_multitrialplot(cfg, data_lp, badtrialsboolean);
    drawnow
    pause(1)
    
    %save figure to temporary path
    fig_savename = ['sub-' id '_cls-bethvisual_lp-' num2str(lp_freq) 'Hz.png'];
    saveas(hFigure3, fullfile(temp_savepath, fig_savename))
    
    
end

%to-do: copy data from  scratch to collab




