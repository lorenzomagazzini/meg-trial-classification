function [ output_args ] = get_wthn_chan_variance( data )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%loop over all trials, distinguish good and rejected trials later
nTrial = length(data.trial);
chanvarsum_arr = nan(1,nTrial);
chanvarmax_arr = nan(1,nTrial);
for iTrial = 1: nTrial
    
    %select single trial
    chantimematrix = data.trial{iTrial};
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

