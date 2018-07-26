
%Visualise a number of different trial features.
%The features first need to be extracted using function extract_trialfeatures 
%and are here loaded into memory from file (feature_file).

% Written by Lorenzo Magazzini (magazzinil@gmail.com)


%%

clear

%define paths
base_path = strrep(mfilename('fullpath'),'trialfeatures/run_extract_trialfeatures','');
feature_path = fullfile(base_path, 'data', 'trainfeatures');

%define subject to plot
s = 1;

%load features from file
feature_file = fullfile(feature_path, [num2str(s,'%02d') 'features.mat']);
load(feature_file, 'features')

%create variables from structure fields
feature_fields = fieldnames(features);
for f = 1:length(feature_fields)
    ff = features.(feature_fields{f});
    eval([feature_fields{f} '=ff;']);
end
clear f
clear ff
clear feature_fields

%load lables
load(feature_file, 'trl_idx')
trls_keep = find(~trl_idx); %trials to keep
trls_rjct = find(trl_idx); %trials to reject
ntrl = length(trl_idx);


%% metric: within-channel variance ( avg & max across channels )

%plot (channels x trials matrix)
% close all
figure
imagesc(log(wthn_chan_var'))
colorbar
title('log within-channel variance')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%plot comparison of compare variance avg VS variance max
mtrc1 = wthn_chan_var_avg;
mtrc2 = wthn_chan_var_max;
mtrc1_label = 'var avg';
mtrc2_label = 'var max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel variance ( avg & max over time )

%plot (channels x trials matrix)
% close all
figure
imagesc(log(btwn_chan_var'))
colorbar
title('log between-channel variance')
xlabel('time')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%plot_metric_comparison
mtrc1 = btwn_chan_var_avg;
mtrc2 = btwn_chan_var_max;
mtrc1_label = 'var avg';
mtrc2_label = 'var max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% compare within-channel (avg) and between-channel (avg) variance

%plot_metric_comparison
mtrc1 = wthn_chan_var_avg;
mtrc2 = btwn_chan_var_avg;
mtrc1_label = 'var avg (wthn)';
mtrc2_label = 'var avg (btwn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% close all

figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1500 300];

mtrc = wthn_chan_var_avg;
mtrc_label = 'var avg (wthn)';
subplot(1,4,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_var_max;
mtrc_label = 'var max (wthn)';
subplot(1,4,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_var_avg;
mtrc_label = 'var avg (btwn)';
subplot(1,4,3)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_var_max;
mtrc_label = 'var max (btwn)';
subplot(1,4,4)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% metric: within-channel kurtosis ( avg & max across channels )

%plot (channels x trials matrix)
% close all
figure
imagesc(log(wthn_chan_kurt'))
colorbar
title('log within-channel kurtosis')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%plot comparison of compare variance avg VS variance max
mtrc1 = wthn_chan_kurt_avg;
mtrc2 = wthn_chan_kurt_max;
mtrc1_label = 'kurt avg';
mtrc2_label = 'kurt max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel kurtosis ( avg & max over time )

%plot (channels x trials matrix)
% close all
figure
imagesc(log(btwn_chan_kurt'))
colorbar
title('log between-channel kurtosis')
xlabel('time')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%plot_metric_comparison
mtrc1 = btwn_chan_kurt_avg;
mtrc2 = btwn_chan_kurt_max;
mtrc1_label = 'kurt avg';
mtrc2_label = 'kurt max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% close all

figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1500 300];

mtrc = wthn_chan_kurt_avg;
mtrc_label = 'kurt avg (wthn)';
subplot(1,4,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_kurt_max;
mtrc_label = 'kurt max (wthn)';
subplot(1,4,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_kurt_avg;
mtrc_label = 'kurt avg (btwn)';
subplot(1,4,3)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_kurt_max;
mtrc_label = 'kurt max (btwn)';
subplot(1,4,4)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% compare variance with kurtosis!

%plot_metric_comparison
mtrc1 = btwn_chan_var_max; %between-channel variance, max across time
mtrc2 = wthn_chan_kurt_max; %within-channel kurtosis, max across channels
mtrc1_label = 'var (btwn)';
mtrc2_label = 'kurt (wthn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% between-channel correlations
%(trials with artifacts could have higher between-channel correlation)

%plot
% close all
figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1200 300];
subplot(1,3,1)
color_keep = [35,139,69]/255;
color_rjct = [215,48,31]/255;
color_plot = nan(ntrl,3);
for t = 1:ntrl
    if ismember(t,trls_keep)
        color_plot(t,:) = color_keep;
    else
        color_plot(t,:) = color_rjct;
    end
    hold on
    plot(btwn_chan_corr(:,t), 'color',color_plot(t,:))
    xlim([0 size(btwn_chan_corr,1)])
    ylim([0 1])
    xlabel('samples')
    ylabel('avg corr')
end
title('btwn-chan corr')
subplot(1,3,2)
scatter(1:ntrl, btwn_chan_corr_avg, 10, color_plot, 'filled')
xlim([1 ntrl])
ylim([0 1])
xlabel('trials')
title('avg btwn-chan corr')
subplot(1,3,3)
scatter(1:ntrl, btwn_chan_corr_max, 10, color_plot, 'filled')
xlim([1 ntrl])
ylim([0 1])
xlabel('trials')
title('max btwn-chan corr')


%plot (channels x trials matrix)
% close all
figure
imagesc(btwn_chan_corr')
colorbar
title('between-channel correlation')
xlabel('samples')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end


%plot histogram bars separately for keep and reject trials
figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 900 300];

mtrc = btwn_chan_corr_avg;
mtrc_label = 'avg btwn-chan corr';
subplot(1,2,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_corr_max;
mtrc_label = 'max btwn-chan corr';
subplot(1,2,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% within-channel correlations
%(trials with artifacts could have higher within-channel correlation)

%plot
% close all
figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1200 300];
subplot(1,3,1)
color_keep = [35,139,69]/255;
color_rjct = [215,48,31]/255;
color_plot = nan(ntrl,3);
for t = 1:ntrl
    if ismember(t,trls_keep)
        color_plot(t,:) = color_keep;
    else
        color_plot(t,:) = color_rjct;
    end
    hold on
    plot(wthn_chan_corr(:,t), 'color',color_plot(t,:))
    xlim([1 size(wthn_chan_corr,1)])
    ylim([0 1])
    xlabel('channels')
    ylabel('avg corr')
end
title('wthn-chan corr')
subplot(1,3,2)
scatter(1:ntrl, wthn_chan_corr_avg, 10, color_plot, 'filled')
xlim([1 ntrl])
ylim([0 1])
xlabel('trials')
title('avg wthn-chan corr')
subplot(1,3,3)
scatter(1:ntrl, wthn_chan_corr_max, 10, color_plot, 'filled')
xlim([1 ntrl])
ylim([0 1])
xlabel('trials')
title('max wthn-chan corr')


%plot (channels x trials matrix)
% close all
figure
imagesc(wthn_chan_corr')
colorbar
title('within-channel correlation')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end


%plot histogram bars separately for keep and reject trials
figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 900 300];

mtrc = wthn_chan_corr_avg;
mtrc_label = 'avg wthn-chan corr';
subplot(1,2,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_corr_max;
mtrc_label = 'max wthn-chan corr';
subplot(1,2,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% MDS plots

%define output filename here (will be saved as .fig)
outfile = 'test'

close all
plot_mds_features(features, trl_idx, outfile)

