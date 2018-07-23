function [ sw_metric, sw_time ] = calculate_sliding_window_metric( data, sw )
%[ sw_metric, sw_time ] = calculate_sliding_window_metric( data, sw )
%   
%   Calculate metric using a sliding window approach.
%   
%   Input:
%       data:	struct, with fields:
%                   data.trial  (1 x NTrials cell array)
%                 	data.time   (1 x NTrials cell array)
%       sw:   	struct, with fields:
%                 	sw.metric   (string, metric to be calculated)
%                  	sw.width   	(scalar, width of the window in seconds)
%                  	sw.overlap  (scalar, overlap between adjacent windows, in seconds)
%   Output:
%       sw_metric:  NChannels x NTimes x NTrials matrix
%       sw_time:    1 x NTimes vector of timepoints (in seconds) at which the windows were centred

% Written in May 2018 by Lorenzo Magazzini (magazzinil@gmail.com)

%%

%data definitions
trl = cat(3, data.trial{:}); %store trials in 3D matrix
time = data.time{1}; %assuming same time-axis for all trials
fsample = data.fsample;
nsamples = size(trl,2);
nchannels = size(trl,1);
ntrials = size(trl,3);

%sliding window definitions
sw_width_seconds = sw.width;
sw_width_samples = sw_width_seconds*fsample;
sw_overlap_seconds = sw.overlap;
sw_overlap_samples = sw_overlap_seconds*fsample;

%metric to be calculated
metric = sw.metric;

%number of times the window will be slid
nslides = ceil( (nsamples-sw_overlap_samples) / (sw_width_samples-sw_overlap_samples) );

%metric output
switch metric
    case 'wthn_chan_var'
        sw_metric = nan(nchannels,nslides,ntrials);
    case 'btwn_chan_var'
        sw_metric = nan(sw_width_samples,nslides,ntrials);
    case 'wthn_chan_kurt'
        sw_metric = nan(nchannels,nslides,ntrials);
    case 'btwn_chan_kurt'
        sw_metric = nan(sw_width_samples,nslides,ntrials);
    case 'wthn_chan_corr'
        sw_metric = nan(nchannels,nslides,ntrials);
    case 'btwn_chan_corr'
        sw_metric = nan(sw_width_samples,nslides,ntrials);
    otherwise
        error(sprintf('metric %s not yet implemented', metric))
end

%time output
sw_time = nan(1,nslides);

%tell metric functions to return 3D output
slide_window = 'yes';

%loop over sliding windows
for s = 1:nslides
    
    %define sliding window start and end sample, starting from first sample
    sw_startsample = (sw_width_samples-sw_overlap_samples)*(s-1)+1;
    sw_endsample = sw_startsample + sw_width_samples - 1;
    
    %if the (last) window doesn't fit, fit it backwards from the last sample
    if sw_endsample > nsamples
        fprintf('fitting last sliding window from last sample backwards.\n')
        sw_startsample = nsamples - sw_width_samples + 1;
        sw_endsample = nsamples;
    end
    
    %select datapoints within sliding window
    sw_trl = trl(:,sw_startsample:sw_endsample,:);
    
    %calculate metric
    switch metric
        case 'wthn_chan_var'
            sw_metric(:,s,:) = get_wthn_chan_variance(sw_trl, slide_window);
        case 'btwn_chan_var'
            sw_metric(:,s,:) = get_btwn_chan_variance(sw_trl, slide_window);
        case 'wthn_chan_kurt'
            sw_metric(:,s,:) = get_wthn_chan_kurtosis(sw_trl, slide_window);
        case 'btwn_chan_kurt'
            sw_metric(:,s,:) = get_btwn_chan_kurtosis(sw_trl, slide_window);
        case 'wthn_chan_corr'
            sw_metric(:,s,:) = get_wthn_chan_correlation(sw_trl, slide_window);
        case 'btwn_chan_corr'
            sw_metric(:,s,:) = get_btwn_chan_correlation(sw_trl, slide_window);
        otherwise
            error(sprintf('metric %s not yet implemented', metric))
    end
    
    %return times at which the sliding window was centred, in seconds
    sw_time(1,s) = time( sw_startsample + (sw_width_samples / 2) );
    
end
