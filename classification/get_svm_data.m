function [ data, labels ] = get_svm_data( datafile, labelfile )
%datafile: file containing feature struct
%labelfile: file containing trial labels

load(datafile);
data = [features.wthn_chan_var_max' features.wthn_chan_kurt_max' features.chan_corr_max' features.btwn_chan_var_max' features.btwn_chan_kurt_max'];

load(labelfile);
labels = rejTrials_visual;

end

