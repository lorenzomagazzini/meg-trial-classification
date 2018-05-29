
%Lorenzo's paths:
addpath('/home/c1356674/git-lab/ampreject/functions')


clear

%path to collab
base_path = '/cubric/collab/meg-cleaning/cdf/resteyesopen';
cd(base_path)


%path to raw data (.mat files)
data_path = fullfile(base_path, 'traindata');

%save path for bad trials index (classifier labels)
labels_savepath = fullfile(base_path, 'trainlabels');

%save path for figures
fig_savepath = fullfile(base_path, 'trainfigures');

%list of files
dir_struct = dir(fullfile(data_path, 'sub-*epoched.mat'));
file_list = {dir_struct(:).name}';
nsubj = length(file_list);


%%

%define subj from list (Lorenzo to mark odd-indexed participants, Diana to mark even-indexed ones)
s = 19

%define files
data_filename = file_list{s}
labels_filename = strrep(data_filename, 'meg-epoched', 'epoch-labels')

%load data
cd(data_path)
data_epoc = load(data_filename);

%%%%% %%%%% %%%%% %%%%%    do preprocessing here    %%%%% %%%%% %%%%% %%%%%

%demean MEG channels
cfg = [];
cfg.channel = {'MEG'};
cfg.demean = 'yes';
data = ft_preprocessing(cfg, data_epoc)

% %1Hz high-pass filter (not recommended...)
% cfg = [];
% cfg.hpfilter    = 'yes';
% cfg.hpfreq      = 1;
% cfg.padding    	= 2*ceil(abs(data.time{1}(end)-data.time{1}(1)));
% cfg.padtype    	= 'mirror';
% data = ft_preprocessing(cfg, data)

close all
cd(base_path)


%% 4 Hz low-pass

%low-pass filtering
cfg = [];
cfg.lpfilter    = 'yes';
cfg.lpfreq      = 4;
cfg.padding     = 2*ceil(abs(data.time{1}(end)-data.time{1}(1)));
data_lp = ft_preprocessing(cfg, data);

%interactive multitrial plot
cfgplot = [];
cfgplot.drawnow = 'yes';
cfgplot.ylim = [];
cfgplot.chandownsamp = 4;
cfgplot.timedownsamp = 40;
cfgplot.badtrialscolor = [];
cfgplot.numrows = [];
cfgplot.numcolumns = [];
cfgplot.interactive = 'yes';

%load badtrialsindex_lp, if file exists
clear badtrialsindex_lp
if exist(fullfile(labels_savepath, labels_filename), 'file')
    try load(fullfile(labels_savepath, labels_filename), 'badtrialsindex_lp'); end
end

%use badtrialsindex_lp, if variable exists
if exist('badtrialsindex_lp', 'var')
    cfgplot.badtrialsindex = badtrialsindex_lp;
else
    cfgplot.badtrialsindex = [];
end

cfgplot.ylim = [-1 1]*5e-12;
cfgplot.title = 'mark low-pass artifacts only';

%plot low-pass trials
[badtrialsindex_lp, h] = amprej_multitrialplot(cfgplot, data_lp);


%% 60 Hz high-pass

%high-pass filtering
cfg = [];
cfg.hpfilter    = 'yes';
cfg.hpfreq      = 60;
cfg.padding    	= 2*ceil(abs(data.time{1}(end)-data.time{1}(1)));
data_hp = ft_preprocessing(cfg, data);

%load badtrialsindex_hp, if file exists
clear badtrialsindex_hp
if exist(fullfile(labels_savepath, labels_filename), 'file')
    try load(fullfile(labels_savepath, labels_filename), 'badtrialsindex_hp'); end
end

%use badtrialsindex_hp, if variable exists
if exist('badtrialsindex_hp', 'var')
    cfgplot.badtrialsindex = badtrialsindex_hp;
else
    cfgplot.badtrialsindex = [];
end

cfgplot.ylim = [-1 1]*2e-12;
cfgplot.title = 'mark high-pass artifacts only';

%plot high-pass trials
[badtrialsindex_hp, h] = amprej_multitrialplot(cfgplot, data_hp);


%% broadband

% %load badtrialsindex, if file exists
% clear badtrialsindex
% if exist(fullfile(labels_savepath, labels_filename), 'file')
%     try load(fullfile(labels_savepath, labels_filename), 'badtrialsindex'); end
% end

%concatenate badtrialsindex_lp & badtrialsindex_hp
clear badtrialsindex
try
    badtrialsindex = sort(unique([badtrialsindex_lp badtrialsindex_hp]));
catch
    badtrialsindex = sort(unique([badtrialsindex_lp; badtrialsindex_hp]));
end

cfgplot.interactive = 'no';
cfgplot.badtrialsindex = badtrialsindex;
cfgplot.ylim = [-1 1]*5e-12;
cfgplot.title = 'mark all artifacts';

%plot broadband trials
[badtrialsindex, h] = amprej_multitrialplot(cfgplot, data);

%initialise interactive mode, if necessary
badtrialsindex = init_multitrialplot_interactive(cfgplot);


%% save files (and figures?)

%save bad trials index
save(fullfile(labels_savepath, labels_filename), '-v7.3', 'badtrialsindex', 'badtrialsindex_lp', 'badtrialsindex_hp')

%save figure
fig_filename = strrep(labels_filename, '.mat', '.png')
saveas(gcf, fullfile(fig_savepath, fig_filename))


