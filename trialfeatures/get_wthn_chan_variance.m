function [ wthn_chan_var ] = get_wthn_chan_variance( data )
%[ wthn_chan_var ] = get_wthn_chan_variance( data )
%   Calculate within-channel variance, separately for each trial.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       wthn_chan_var: NChan x NTrl matrix.

%store trials in 3D matrix (good and bad trials distinguished later)
trl = cat(3, data.trial{:});

%calculate within-channel variance, separately for each trial (NChan x NTrl)
wthn_chan_var = squeeze(var(trl,[],2));

