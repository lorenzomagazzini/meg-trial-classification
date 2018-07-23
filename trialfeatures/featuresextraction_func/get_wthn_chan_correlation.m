function [ wthn_chan_corr ] = get_wthn_chan_correlation( data, slide_window )
%[ wthn_chan_corr ] = get_wthn_chan_correlation( data, slide_window )
%   Calculate each channel's mean correlation with all other channels across time,
%   separately for each trial. Ignore sign of correlation (take abs).
%   Input:
%       data:           struct, with field data.trial (1 x NTrl cell array), when slide_window is false.
%                       NChan x 1 x NTrl matrix, when optional input slide_window is true.
%       slide_window:   logical, optional input determining the dimension of the output matrix wthn_chan_kurt.
%   Output:
%       wthn_chan_corr:	NChan x NTrl matrix, when slide_window is false.
%                       NChan x 1 x NTrl matrix, when slide_window is true.

% Written by Diana Dima (diana.dima@gmail.com)
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
    
    wthn_chan_corr = nan(size(trl,1), 1, size(trl,3));
    for t = 1:size(trl,3)
        rho = corr(trl(:,:,t)'); %correlate each channel with each other channel
        wthn_chan_corr(:,1,t) = mean(abs(rho),1); %take the average corr for each channel
%         wthn_chan_corr(:,1,t) = var(abs(rho),[],1); %take the average corr for each channel
    end
    
%return 2D matrix otherwise
elseif ~slide_window
    
    trl = cat(3, data.trial{:}); %store trials in 3D matrix
    
    wthn_chan_corr = nan(size(trl,1),size(trl,3),1);
    for t = 1:size(trl,3)
        rho = corr(trl(:,:,t)'); %correlate each channel with each other channel
        wthn_chan_corr(:,t) = mean(abs(rho),1); %take the average corr for each channel
%         wthn_chan_corr(:,t) = var(abs(rho),[],1); %take the average corr for each channel
    end
    
end

