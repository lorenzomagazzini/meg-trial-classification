function [ hexp ] = get_hurst_exponent( data )
%   Calculate the timeseries Hurst exponent separately for each trial and channel. 
%   Uses the discrete second derivative estimator as implemented in
%   Matlab's Wavelet Toolbox.
%   Input:
%       data: struct, with field data.trial (1 x NTrl cell array).
%   Output:
%       hexp: NChan x NTrl matrix.

trl = cat(3, data.trial{:});
hexp = nan(size(trl,1), size(trl,3)); %initialize NChan x NTrl matrix

for t = 1:size(trl,3)
    for c = 1:size(trl,1)
        h = wfbmesti(squeeze(trl(c,:,t)));
        hexp(c,t) = h(1);
    end;
end;



end

