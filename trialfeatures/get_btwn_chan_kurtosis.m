function [ btwn_chan_kurt ] = get_btwn_chan_kurtosis( data )
%   Calculate between-channel kurtosis, separately for each trial.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       wthn_chan_kurt: NTime x NTrl matrix.

trl = cat(3, data.trial{:});
btwn_chan_kurt = squeeze(kurtosis(trl,[],1)); %kurtosis along time axis


end

