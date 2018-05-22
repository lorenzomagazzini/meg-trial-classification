
%Lorenzo's paths:
addpath('/home/c1356674/git-lab/Trial-classification/trialfeatures/')
addpath('/home/c1356674/git-lab/ampreject/functions')
addpath('/cubric/collab/meg-partnership/git-lab/meguk-data-management/meguk_anonym')
addpath('/cubric/collab/meg-partnership/git-lab/meguk-data-analysis')

%CUBRIC paths:
addpath('/cubric/software/MEG/CUBRIC/FileIO/ctf/')


clear

%path to MEGUK BIDS dataset
bids_path = '/cubric/collab/meg-partnership/cardiff/bids';

%path to save raw data
base_path = '/cubric/collab/meg-cleaning/megpartnership/restopen';
data_savepath = fullfile(base_path, 'traindata');
if ~exist(data_savepath,'dir'), mkdir(data_savepath); end

%path to save figures
fig_savepath = fullfile(base_path, 'trainfigures');
if ~exist(fig_savepath,'dir'), mkdir(fig_savepath); end

%set permissions
unix(['chmod -R 770 ' base_path])
unix(['addWriteAccessTo 1205074 ' base_path])
unix(['addWriteAccessTo 1205074 ' fullfile(base_path, 'traindata')])
unix(['addWriteAccessTo 1205074 ' fullfile(base_path, 'trainfigures')])


%% define list of MEGUK IDs

id_list = define_megpartnership_ids;
nsubj = length(id_list);


%% get raw resteyesopen data from BIDS directory

cfg = [];
cfg.total_duration = 300; %in seconds
cfg.trial_duration = 2; %in seconds
cfg.anonymise = 'no';

for s = 1:nsubj %missing MarkerFile: 8, 17, 20, 25, 30, 33, 36
    
    %define subject, dataset, markerfile
    subj = ['sub-' id_list{s}];
    cfg.dataset = fullfile(bids_path, subj, 'meg', [subj '_task-resteyesopen_meg.ds']);
    markerfile = fullfile(cfg.dataset, 'MarkerFile.mrk');
    
    %find marker (if MarkerFile exists)
    if exist(markerfile,'file')
        
        mrk = readmarkerfile(cfg.dataset);
        if mrk.number_markers == 1
            cfg.eventtype = mrk.marker_names{1};
        else
            error('multiple markers found')
        end
        
	%otherwise, try reading events (for example, sub-cdf067)
    else
        
        evt = ft_read_event(cfg.dataset);
        if isempty(evt)
            cfg.eventtype = '';
            cfg.eventvalue = [];
        else
            cfg.eventtype = 'UPPT002';
            evt_index = find(ismember({evt(:).type}, cfg.eventtype)); %first trigger is taken, in case of multiple UPPT002 events
            cfg.eventvalue = evt(evt_index(1)).value;
        end
        
    end
    
    %epoch dataset (no preprocessing such as filtering or demeaning, at this stage)
    [data_epoc, data_cont] = epoch_resteyesopen(cfg);
    
    %save continuous .mat file
    [~, dataset_name] = fileparts(cfg.dataset);
    cont_savename = [dataset_name '-continuous.mat'];
    fprintf('saving file %s to %s\n', cont_savename, data_savepath)
    save(fullfile(data_savepath, cont_savename), '-v7.3', '-struct', 'data_cont')
    
    %save epoched .mat file
    epoc_savename = [dataset_name '-epoched.mat'];
    fprintf('saving file %s to %s\n', cont_savename, epoc_savename)
    save(fullfile(data_savepath, epoc_savename), '-v7.3', '-struct', 'data_epoc')
    
end

