function [ data ] = get_svm_data (features, feature_set )
%Prepares the feature vector for classification. Different features/feature combination can be extracted for classification.
%Inputs:
%features: struct containing extracted features (output from feature extraction scripts)
% feature_set: combination of features selected.
%       --max: maximal summary value
%       --within: channel-specific features
%       --between: across-channel features (which are time-resolved)
%       --within-between: combine the two
%       --single-value: all summary features (1 value per trial)
%
% DC Dima 2018 (diana.dima@gmail.com)

switch feature_set %based on input, features from a specific set are concatenated into a feature vector
    
    case 'max'
        data = [features.wthn_chan_var_max' features.wthn_chan_kurt_max' features.wthn_chan_corr_max' features.btwn_chan_corr_max' features.btwn_chan_var_max' features.btwn_chan_kurt_max'];
    case 'within'
        if ~ismatrix(features.wthn_chan_var)
            data = [squeeze(max(features.wthn_chan_var,[],2))' squeeze(max(features.wthn_chan_kurt,[],2))' squeeze(max(features.wthn_chan_corr,[],2))']; %take max across slides
        else
            data = [features.wthn_chan_var' features.wthn_chan_kurt' features.wthn_chan_corr'];
        end
    case 'between'
        if ~ismatrix(features.btwn_chan_var)
            data = [squeeze(max(features.btwn_chan_var,[],2))' squeeze(max(features.btwn_chan_kurt,[],2))' squeeze(max(features.btwn_chan_corr,[],2))'];
        else
            data = [features.btwn_chan_var' features.btwn_chan_kurt' features.btwn_chan_corr'];
        end
    case 'within-between'
        if ~ismatrix(features.btwn_chan_var)
            data = [squeeze(max(features.wthn_chan_var,[],2))' squeeze(max(features.wthn_chan_kurt,[],2))' squeeze(max(features.wthn_chan_corr,[],2))',...
                squeeze(max(features.btwn_chan_var,[],2))' squeeze(max(features.btwn_chan_kurt,[],2))' squeeze(max(features.btwn_chan_corr,[],2))'];
        else
            data = [features.wthn_chan_var' features.wthn_chan_kurt' features.chan_corr' features.btwn_chan_var' features.btwn_chan_kurt'];
        end
    case 'single-value'
        data = [features.wthn_chan_var_max' features.wthn_chan_var_avg' features.btwn_chan_var_avg' features.btwn_chan_var_max' features.btwn_chan_kurt_avg',...
            features.btwn_chan_kurt_max' features.wthn_chan_corr_avg' features.wthn_chan_corr_max' features.btwn_chan_corr_avg' features.btwn_chan_corr_max'];
end;


end

