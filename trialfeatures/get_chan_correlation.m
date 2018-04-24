function [ chan_corr ] = get_chan_correlation( data )
%   Calculate each channel's mean correlation with all other channels, 
%   separately for each trial.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       chan_corr: NChan x NTrl matrix.

trl = cat(3, data.trial{:});
chan_corr = nan(size(trl,1),size(trl,3),1);

for t = 1:size(trl,3)
    rho = corr(trl(:,:,t)');
    chan_corr(:,t) = mean(rho,1);
end;



end

