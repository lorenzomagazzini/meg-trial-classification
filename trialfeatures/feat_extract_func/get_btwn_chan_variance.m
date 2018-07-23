function [ btwn_chan_var ] = get_btwn_chan_variance( data, slide_window )
%[ btwn_chan_var ] = get_btwn_chan_variance( data, slide_window )
%   Calculate between-channel variance, separately for each trial.
%   Input:
%       data:           struct, with field data.trial (1 x NTrl cell array), when slide_window is false.
%                       NChan x 1 x NTrl matrix, when optional input slide_window is true.
%       slide_window:   logical, optional input determining the dimension of the output matrix wthn_chan_var (default = false).
%   Output:
%       btwn_chan_var:  NTime x NTrl matrix, when slide_window is false.
%                       NTime x 1 x NTrl matrix, when slide_window is true.

% Written by Lorenzo Magazzini (magazzinil@gmail.com)
% Re-written in May 2018

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
    btwn_chan_var(:,1,:) = permute(var(trl,[],1),[2 1 3]); %variance across channels
    
%return 2D matrix otherwise
elseif ~slide_window
    
    trl = cat(3, data.trial{:}); %store trials in 3D matrix
    btwn_chan_var = squeeze(var(trl,[],1)); %calculate variance across channels, separately for each trial (NTime x NTrl)
    
end

