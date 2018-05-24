function [ data ] = get_svm_data (features, feature_set )
%datafile: file containing feature struct
%labelfile: file containing trial labels

switch feature_set
    
    case 'max'
        data = [features.wthn_chan_var_max' features.wthn_chan_kurt_max' features.chan_corr_max' features.btwn_chan_var_max' features.btwn_chan_kurt_max'];
    case 'within'
        data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr'];
    case 'between'
        data = [features.btwn_chan_var' features.btwn_chan_kurt'];
    case 'within-between'
        data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr' features.btwn_chan_var' features.btwn_chan_kurt'];
    case 'single-value'
        data = [features.wthn_chan_var_max' features.wthn_chan_var_sum' features.btwn_chan_var_avg' features.btwn_chan_var_max' features.btwn_chan_kurt_mean' features.btwn_chan_kurt_max' features.chan_corr_mean' features.chan_corr_max'];
end;


end

