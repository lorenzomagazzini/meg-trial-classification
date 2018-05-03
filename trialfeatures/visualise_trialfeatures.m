
%Visualise a number of different trial features extracted using function 
%extract_trialfeatures and saved to file feature_file


%% load features

load(feature_file)


%% metric: within-channel variance ( sum & max across channels )

%plot (channels x trials matrix)
close all
figure
imagesc(log(wthn_chan_var'))
colorbar
title('log within-channel variance')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%plot comparison of compare variance sum VS variance max
mtrc1 = wthn_chan_var_sum;
mtrc2 = wthn_chan_var_max;
mtrc1_label = 'var sum';
mtrc2_label = 'var max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel variance ( average & max over time )

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


%% compare within-channel (sum) and between-channel (avg) variance

%plot_metric_comparison
mtrc1 = wthn_chan_var_sum;
mtrc2 = btwn_chan_var_avg;
mtrc1_label = 'within-chan var sum';
mtrc2_label = 'between-chan var avg';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% close all

figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1500 300];

mtrc = wthn_chan_var_sum;
mtrc_label = 'within-channel variance sum';
subplot(1,4,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_var_max;
mtrc_label = 'within-channel variance max';
subplot(1,4,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_var_avg;
mtrc_label = 'between-channel variance avg';
subplot(1,4,3)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_var_max;
mtrc_label = 'between-channel variance max';
subplot(1,4,4)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% metric: within-channel kurtosis ( mean & max across channels )

%plot (channels x trials matrix)
% close all
figure
imagesc(log(wthn_chan_kurt'))
colorbar
title('log within-channel kurtosis')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end

%plot comparison of compare variance sum VS variance max
mtrc1 = wthn_chan_kurt_mean;
mtrc2 = wthn_chan_kurt_max;
mtrc1_label = 'kurt mean';
mtrc2_label = 'kurt max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% metric: between-channel kurtosis ( average & max over time )

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
mtrc1 = btwn_chan_kurt_mean;
mtrc2 = btwn_chan_kurt_max;
mtrc1_label = 'kurt mean';
mtrc2_label = 'kurt max';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% close all

figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 1500 300];

mtrc = wthn_chan_kurt_mean;
mtrc_label = 'within-channel kurtosis mean';
subplot(1,4,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = wthn_chan_kurt_max;
mtrc_label = 'within-channel kurtosis max';
subplot(1,4,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_kurt_mean;
mtrc_label = 'between-channel kurtosis mean';
subplot(1,4,3)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = btwn_chan_kurt_max;
mtrc_label = 'between-channel kurtosis max';
subplot(1,4,4)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% compare variance with kurtosis!

%plot_metric_comparison
mtrc1 = btwn_chan_var_max; %between-channel variance, max across time
mtrc2 = wthn_chan_kurt_max; %within-channel kurtosis, max across channels
mtrc1_label = 'btwn-chan var';
mtrc2_label = 'wthn-chan kurt';
plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% channel correlations (trials with artifacts will have higher between-channel correlation)

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
    if trls_keep(t)
        color_plot(t,:) = color_keep;
    else
        color_plot(t,:) = color_rjct;
    end
    hold on
    plot(chan_corr(:,t), 'color',color_plot(t,:))
    xlim([1 size(chan_corr,1)])
    ylim([0 1])
    xlabel('channels')
    ylabel('avg corr')
end
title('avg chan corr')
subplot(1,3,2)
scatter(1:ntrl, chan_corr_mean, 10, color_plot, 'filled')
xlim([1 ntrl])
ylim([0 1])
xlabel('trials')
title('mean avg chan corr')
subplot(1,3,3)
scatter(1:ntrl, chan_corr_max, 10, color_plot, 'filled')
xlim([1 ntrl])
ylim([0 1])
xlabel('trials')
title('max avg chan corr')


%plot (channels x trials matrix)
% close all
figure
imagesc(chan_corr')
colorbar
title('channel correlation')
xlabel('channels')
ylabel('trials')
try colormap(cmocean('amp')); catch, colormap('hot'); end


%plot histogram bars separately for keep and reject trials
figure('color','w')
hF = gcf;
hF.Units = 'pixels';
hF.Position = [0 500 900 300];

mtrc = chan_corr_mean;
mtrc_label = 'mean channel correlation';
subplot(1,2,1)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

mtrc = chan_corr_max;
mtrc_label = 'max channel correlation';
subplot(1,2,2)
plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )

