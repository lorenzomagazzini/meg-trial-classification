function [ output_args ] = get_wthn_chan_variance( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%store trials into 3D matrix (good and bad trials distinguished later)
trl = cat(3, data.trial{:});

nTrial = size(trl,3);
chanvarsum_arr = nan(1,nTrial);
chanvarmax_arr = nan(1,nTrial);
for iTrial = 1: nTrial
    
    %select single trial
    chantimematrix = squeeze(trl(:,:,1));
%     figure, imagesc(chantimematrix)
    
    %calculate within-channel variance
    chanvar = var(chantimematrix,[],2);
    
    %sum variance over channels
    chanvarsum = sum(chanvar);
    
    %max variance across trials
    chanvarmax = max(chanvar);
    
    %store in array
    chanvarsum_arr(iTrial) = chanvarsum;
    chanvarmax_arr(iTrial) = chanvarmax;
    
end

end

