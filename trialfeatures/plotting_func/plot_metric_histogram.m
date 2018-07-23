function [  ] = plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
%plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
%   Plot histogram bars of a metric, comparing keep and reject trials.

% Written by Lorenzo Magazzini (magazzinil@gmail.com)


%%

ntrl_keep = sum(trls_keep);
ntrl_rjct = sum(trls_rjct);

n_bins = 20;
hist_bins = linspace(min(mtrc), max(mtrc), n_bins);
hist_step = hist_bins(2)-hist_bins(1);

mtrc_keep = mtrc(trls_keep);
[hist_freq_keep, hist_bins_keep] = hist(mtrc_keep, hist_bins);

mtrc_rjct = mtrc(trls_rjct);
[hist_freq_rjct, hist_bins_rjct] = hist(mtrc_rjct, hist_bins);

gca
hold on
h_kepbar = bar(hist_bins_keep-(hist_step/10), hist_freq_keep, 'facecolor',[.4 .4 .4]);
h_rejbar = bar(hist_bins_rjct+(hist_step/10), hist_freq_rjct, 'facecolor',[1 .4 .4]);

xlabel(mtrc_label)
ylabel('n trials')
h_leg = legend([h_kepbar, h_rejbar], [num2str(ntrl_keep) ' keep trials'], [num2str(ntrl_rjct) ' reject trials']);
h_leg.Box = 'off';

