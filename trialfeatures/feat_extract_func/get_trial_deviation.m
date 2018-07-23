function [ trl_dev ] = get_trial_deviation( data )
%   Calculate each trial's deviation from mean of all other trials, 
%   separately for each channel & trial.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       trl_dev: NChan x NTrl matrix.

trl = cat(3, data.trial{:});
avg_amp = squeeze(mean(trl,2)); %average amplitude over time
trl_dev = nan(size(trl,1),size(trl,3));

for t = 1:size(trl,3)
    avg_other = avg_amp; avg_other(:,t) = [];
    trl_dev(:,t) = avg_amp(:,t) - mean(avg_other,2);
end;

end

