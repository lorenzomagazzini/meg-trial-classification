function [ id_list ] = define_megpartnership_ids(  )
% [ id_list ] = define_megpartnership_ids(  )

% %% get list of Partnership IDs
%
% %path to MEG Partnership data in collab (Analysis folder) ... only used for the IDs!
% partnership_path = '/cubric/collab/meg-partnership/Analysis';
%
% cd(partnership_path)
% tmp_dir = dir('7*');
% subj_list = {tmp_dir(:).name}';
% nsubj = length(subj_list);
% clear tmp*
%
%
% %% get list of MEGUK IDs
%
% id_list = cell(size(subj_list,1)/2, 1);
% s_count = 0;
% for s = 1:2:nsubj %every other subject, starting from first Partnership subj
%     s_count = s_count + 1;
%     subj = subj_list{s}; %subject ID (Partnership)
%     id_list{s_count} = partnership2meguk(subj, '/cubric/collab/meg-partnership/cardiff/private/id_conversion_cardiff.mat'); %MEGUK ID
% end
% id_list = sort(id_list); %sort subjects by MEGUK ID


%% define list of MEGUK IDs

id_list = {...
    'cdf004'
    'cdf007'
    'cdf009'
    'cdf011'
    'cdf012'
    'cdf013'
    'cdf015'
    'cdf020'
    'cdf021'
    'cdf023'
    'cdf024'
    'cdf026'
    'cdf027'
    'cdf029'
    'cdf030'
    'cdf031'
    'cdf033'
    'cdf034'
    'cdf038'
    'cdf041'
    'cdf043'
    'cdf044'
    'cdf045'
    'cdf046'
    'cdf048'
    'cdf049'
    'cdf050'
    'cdf051'
    'cdf060'
    'cdf063'
    'cdf064'
    'cdf065'
    'cdf067'
    'cdf068'
    'cdf069'
    'cdf070'
    'cdf075'
    'cdf076'
    'cdf077'
    'cdf078'
    'cdf079'
    'cdf083'
    'cdf084'
    'cdf088'};

end