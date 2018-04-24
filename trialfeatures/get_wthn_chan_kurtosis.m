function [ wthn_chan_kurt ] = get_wthn_chan_kurtosis( data )
%   Calculate within-channel kurtosis, separately for each trial.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       wthn_chan_kurt: NChan x NTrl matrix.

trl = cat(3, data.trial{:});
wthn_chan_kurt = squeeze(kurtosis(trl,[],2)); %kurtosis along time axis


end

