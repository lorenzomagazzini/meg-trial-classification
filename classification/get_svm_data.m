function [ data, labels ] = get_svm_data( datafile, labelfile, feature_set )
%datafile: file containing feature struct
%labelfile: file containing trial labels

load(datafile);

switch feature_set
    
    case 'max'
        data = [features.wthn_chan_var_max' features.wthn_chan_kurt_max' features.chan_corr_max' features.btwn_chan_var_max' features.btwn_chan_kurt_max'];
    case 'within'
        data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr'];
    case 'between'
        data = [features.btwn_chan_var' features.btwn_chan_kurt'];
    case 'within-between'
        data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr' features.btwn_chan_var' features.btwn_chan_kurt'];
end;

load(labelfile);
labels = rejTrials_visual;

end

