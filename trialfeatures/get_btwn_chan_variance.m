function [ btwn_chan_var ] = get_btwn_chan_variance( data )
%[ btwn_chan_var ] = get_btwn_chan_variance( data )
%   Calculate between-channel variance, separately for each trial.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       btwn_chan_var: NTrl x NTime matrix.

%store trials in 3D matrix (good and bad trials distinguished later)
trl = cat(3, data.trial{:});

%calculate variance across channels, separately for each trial (NTime x NTrl)
btwn_chan_var = squeeze(var(trl,[],1))';

