
%Visualise a number of different trial features.
%The features first need to be extracted using function extract_trialfeatures 
%and are here loaded into memory from file (feature_file).
%NOTE:
%Parts of this script do NOT support visualisation of featues extracted 
%with the sliding-window approach. To plot these features, the extra matrix
%dimension needs to be reduced to 1 and squeezed out of the matrix, eg: 
% max_idx = max(wthn_chan_var,[],2);
% wthn_chan_var = squeeze(max_idx);
% imagesc(log(wthn_chan_var'))

% Written by Lorenzo Magazzini (magazzinil@gmail.com)


%%

clear

%use features extracted with the sliding window approach (=true) or not (=false)
slidingwindow = false;

%define whether to visualise sliding-window features 
if istrue(slidingwindow)
    sw_suffix = '_slidingwindow';
else
    sw_suffix = '';
end

%define paths
base_path = strrep(mfilename('fullpath'),'trialfeatures/run_extract_trialfeatures','');
feature_path = fullfile(base_path, 'data', ['trainfeatures' sw_suffix]);


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
close all
figure
imagesc(log(wthn_chan_var'))
colorbar
title('log within-channel variance')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

th=get(gca,'title'); tt=get(th,'string');
% saveas(gcf, ['example_' strrep(tt,' ','-') '.png'])


%plot comparison of compare variance avg VS variance max
mtrc1 = wthn_chan_var_avg;
mtrc2 = wthn_chan_var_max;
mtrc1_label = 'var avg (wthn)';
mtrc2_label = 'var max (wthn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)

% saveas(gcf, ['example_' strrep([mtrc1_label '-V-' mtrc2_label],' ','-') '.png'])


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

th=get(gca,'title'); tt=get(th,'string');
% saveas(gcf, ['example_' strrep(tt,' ','-') '.png'])


%plot_metric_comparison
mtrc1 = btwn_chan_var_avg;
mtrc2 = btwn_chan_var_max;
mtrc1_label = 'var avg (btwn)';
mtrc2_label = 'var max (btwn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)

% saveas(gcf, ['example_' strrep([mtrc1_label '-V-' mtrc2_label],' ','-') '.png'])


%% compare within-channel (avg) and between-channel (avg) variance

%plot_metric_comparison
mtrc1 = wthn_chan_var_avg;
mtrc2 = btwn_chan_var_avg;
mtrc1_label = 'var avg (wthn)';
mtrc2_label = 'var avg (btwn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)

% saveas(gcf, ['example_' strrep([mtrc1_label '-V-' mtrc2_label],' ','-') '.png'])


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

tt = 'var';fh = gcf;
fh.Units = 'centimeters'; fh.Position
fh.PaperUnits = 'centimeters'; fh.PaperPosition = [0 0 40 8];
% saveas(gcf, ['example_' tt '-hist' '.png'])


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

th=get(gca,'title'); tt=get(th,'string');
% saveas(gcf, ['example_' strrep(tt,' ','-') '.png'])


%plot comparison of compare variance avg VS variance max
mtrc1 = wthn_chan_kurt_avg;
mtrc2 = wthn_chan_kurt_max;
mtrc1_label = 'kurt avg (wthn)';
mtrc2_label = 'kurt max (wthn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)

% saveas(gcf, ['example_' strrep([mtrc1_label '-V-' mtrc2_label],' ','-') '.png'])


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

th=get(gca,'title'); tt=get(th,'string');
% saveas(gcf, ['example_' strrep(tt,' ','-') '.png'])


%plot_metric_comparison
mtrc1 = btwn_chan_kurt_avg;
mtrc2 = btwn_chan_kurt_max;
mtrc1_label = 'kurt avg (btwn)';
mtrc2_label = 'kurt max (btwn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)

% saveas(gcf, ['example_' strrep([mtrc1_label '-V-' mtrc2_label],' ','-') '.png'])


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

tt = 'kurt';fh = gcf;
fh.Units = 'centimeters'; fh.Position
fh.PaperUnits = 'centimeters'; fh.PaperPosition = [0 0 40 8];
% saveas(gcf, ['example_' tt '-hist' '.png'])


%% compare variance with kurtosis!

%plot_metric_comparison
mtrc1 = btwn_chan_var_max; %between-channel variance, max across time
mtrc2 = wthn_chan_kurt_max; %within-channel kurtosis, max across channels
mtrc1_label = 'var (btwn)';
mtrc2_label = 'kurt (wthn)';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)

% saveas(gcf, ['example_' strrep([mtrc1_label '-V-' mtrc2_label],' ','-') '.png'])


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

tt = 'btwn-chan-corr';fh = gcf;
fh.Units = 'centimeters'; fh.Position
fh.PaperUnits = 'centimeters'; fh.PaperPosition = [0 0 32 8];
% saveas(gcf, ['example_' tt '-hist' '.png'])


%plot (channels x trials matrix)
% close all
figure
imagesc(btwn_chan_corr')
colorbar
title('between-channel correlation')
xlabel('samples')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

th=get(gca,'title'); tt=get(th,'string');
% saveas(gcf, ['example_' strrep(tt,' ','-') '.png'])


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

tt = 'btwn-chan-corr';fh = gcf;
fh.Units = 'centimeters'; fh.Position
fh.PaperUnits = 'centimeters'; fh.PaperPosition = [0 0 24 8];
% saveas(gcf, ['example_' tt '-hist' '.png'])


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

tt = 'wthn-chan-corr';fh = gcf;
fh.Units = 'centimeters'; fh.Position
fh.PaperUnits = 'centimeters'; fh.PaperPosition = [0 0 32 8];
% saveas(gcf, ['example_' tt '-hist' '.png'])


%plot (channels x trials matrix)
% close all
figure
imagesc(wthn_chan_corr')
colorbar
title('within-channel correlation')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

th=get(gca,'title'); tt=get(th,'string');
% saveas(gcf, ['example_' strrep(tt,' ','-') '.png'])


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

tt = 'wthn-chan-corr';fh = gcf;
fh.Units = 'centimeters'; fh.Position
fh.PaperUnits = 'centimeters'; fh.PaperPosition = [0 0 24 8];
% saveas(gcf, ['example_' tt '-hist' '.png'])


%% MDS plots

%define output filename here (will be saved as .fig)
outfile = 'test'

% close all
plot_mds_features(features, trl_idx, outfile)


