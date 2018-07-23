function [ wthn_chan_kurt ] = get_wthn_chan_kurtosis( data, slide_window )
%[ wthn_chan_kurt ] = get_wthn_chan_kurtosis( data, slide_window )
%   Calculate within-channel kurtosis, separately for each trial.
%   Input:
%       data:           struct, with field data.trial (1 x NTrl cell array), when slide_window is false.
%                       NChan x 1 x NTrl matrix, when optional input slide_window is true.
%       slide_window:   logical, optional input determining the dimension of the output matrix wthn_chan_kurt.
%   Output:
%       wthn_chan_kurt: NChan x NTrl matrix, when slide_window is false.
%                       NChan x 1 x NTrl matrix, when slide_window is true.

% Written by Diana Dima
% Re-written in May 2018 by Lorenzo Magazzini (magazzinil@gmail.com)

%%

%do not slide window by default
if nargin<2 || isempty(slide_window)
    slide_window = false;
else
    slide_window = istrue(slide_window);
end

%return 3D matrix for sliding window approach
if slide_window
    
    trl = data; %data is already a 3D matrix, not a structure
    wthn_chan_kurt(:,1,:) = kurtosis(trl,[],2); %kurtosis along time axis
    
%return 2D matrix otherwise
elseif ~slide_window
    
    trl = cat(3, data.trial{:}); %store trials in 3D matrix
    wthn_chan_kurt = squeeze(kurtosis(trl,[],2)); %calculate within-channel kurtosis, separately for each trial (NChan x NTrl)
    
end

