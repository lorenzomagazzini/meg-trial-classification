function [ features ] = extract_trialfeatures( data )
%[ features ] = extract_trialfeatures( data )
%   Extract a number of different trial features from the input data


%% initialise output

features = struct;


%% metric: within-channel variance ( sum & max across channels )

%calculate variance
wthn_chan_var = get_wthn_chan_variance(data);

%sum variance over channels
wthn_chan_var_avg = mean(wthn_chan_var);

%max variance across trials
wthn_chan_var_max = max(wthn_chan_var);

%output
features.wthn_chan_var = wthn_chan_var;
features.wthn_chan_var_avg = wthn_chan_var_avg;
features.wthn_chan_var_max = wthn_chan_var_max;


%% metric: between-channel variance ( average & max over time )

%calculate variance
btwn_chan_var = get_btwn_chan_variance(data);

%average variance over time
btwn_chan_var_avg = mean(btwn_chan_var);

%max variance across time
btwn_chan_var_max = max(btwn_chan_var);

%output
features.btwn_chan_var = btwn_chan_var;
features.btwn_chan_var_avg = btwn_chan_var_avg;
features.btwn_chan_var_max = btwn_chan_var_max;


%% metric: within-channel kurtosis ( mean & max across channels )

%calculate variance
wthn_chan_kurt = get_wthn_chan_kurtosis(data);

%sum variance over channels
wthn_chan_kurt_avg = mean(wthn_chan_kurt);

%max variance across trials
wthn_chan_kurt_max = max(wthn_chan_kurt);

%output
features.wthn_chan_kurt = wthn_chan_kurt;
features.wthn_chan_kurt_avg = wthn_chan_kurt_avg;
features.wthn_chan_kurt_max = wthn_chan_kurt_max;


%% metric: between-channel kurtosis ( average & max over time )

%calculate variance
btwn_chan_kurt = get_btwn_chan_kurtosis(data);

%average variance over time
btwn_chan_kurt_avg = avg(btwn_chan_kurt);

%max variance across time
btwn_chan_kurt_max = max(btwn_chan_kurt);

%output
features.btwn_chan_kurt = btwn_chan_kurt;
features.btwn_chan_kurt_avg = btwn_chan_kurt_avg;
features.btwn_chan_kurt_max = btwn_chan_kurt_max;


%% within channel correlations 

%calculate average correlation (of each channel with all other channels)
wthn_chan_corr = get_wthn_chan_correlation(data);

%calculate average correlation across channels
wthn_chan_corr_avg = mean(wthn_chan_corr);

%calculate max correlation across channels
wthn_chan_corr_max = max(wthn_chan_corr);

%output
features.wthn_chan_corr = wthn_chan_corr;
features.wthn_chan_corr_mean = wthn_chan_corr_avg;
features.wthn_chan_corr_max = wthn_chan_corr_max;

%% between channel correlation (trials with artifacts will have higher between-channel correlation)

%calculate average correlation (of each channel with all other channels)
btwn_chan_corr = get_btwn_chan_correlation(data);

%calculate average correlation across channels
btwn_chan_corr_avg = mean(btwn_chan_corr);

%calculate max correlation across channels
btwn_chan_corr_max = max(btwn_chan_corr);

%output
features.btwn_chan_corr = btwn_chan_corr;
features.btwn_chan_corr_mean = btwn_chan_corr_avg;
features.btwn_chan_corr_max = btwn_chan_corr_max;


end

