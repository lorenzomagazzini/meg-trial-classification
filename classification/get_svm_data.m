function [ data ] = get_svm_data (features, feature_set )
%Prepares the feature vector for classification
%Inputs:
%features: struct containing extracted features (output from feature
%extraction scripts)
% feature_set: combination of features selected. 
%       --max: maximal summary value
%       -- within: channel-specific features
%       --between: across-channel features (which are time-resolved)
%       --within-between: combine the two
%       --single-value: all summary features (1 value per trial)

switch feature_set
    
    case 'max'
        data = [features.wthn_chan_var_max' features.wthn_chan_kurt_max' features.wthn_chan_corr_max' features.btwn_chan_corr_max' features.btwn_chan_var_max' features.btwn_chan_kurt_max'];
    case 'within'
        data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr'];
    case 'between'
        data = [features.btwn_chan_var' features.btwn_chan_kurt'];
    case 'within-between'
        data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr' features.btwn_chan_var' features.btwn_chan_kurt'];
    case 'single-value'
        data = [features.wthn_chan_var_max' features.wthn_chan_var_avg' features.btwn_chan_var_avg' features.btwn_chan_var_max' features.btwn_chan_kurt_avg',...
            features.btwn_chan_kurt_max' features.wthn_chan_corr_avg' features.wthn_chan_corr_max' features.btwn_chan_corr_avg' features.btwn_chan_corr_max'];
end;


end

