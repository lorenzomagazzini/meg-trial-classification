function [  ] = plot_metric_comparison( mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct )
%plot_metric_comparison( mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct )
%   Plot comparison of two metrics (e.g., within-channel variance, max VS sum).
%   Also plot distribution of each metric separately, comparing keep and reject trials.

% Written by Lorenzo Magazzini (magazzinil@gmail.com)


%%

%plotting colors
color_keep = [35,139,69]/255;
color_rjct = [215,48,31]/255;

%separate keep and reject trials
mtrc1_keep = mtrc1(trls_keep);
mtrc1_rjct = mtrc1(trls_rjct);
mtrc2_keep = mtrc2(trls_keep);
mtrc2_rjct = mtrc2(trls_rjct);

%distribution for metric1
mtrc1_mu_keep = mean(log(mtrc1_keep)); 
mtrc1_sd_keep = std(log(mtrc1_keep)); 
mtrc1_ix_keep = linspace(min(mtrc1_keep),max(mtrc1_keep)); 
mtrc1_iy_keep = pdf('lognormal', mtrc1_ix_keep, mtrc1_mu_keep, mtrc1_sd_keep);
mtrc1_mu_rjct = mean(log(mtrc1_rjct)); 
mtrc1_sd_rjct = std(log(mtrc1_rjct)); 
mtrc1_ix_rjct = linspace(min(mtrc1_rjct),max(mtrc1_rjct)); 
mtrc1_iy_rjct = pdf('lognormal', mtrc1_ix_rjct, mtrc1_mu_rjct, mtrc1_sd_rjct);

%distribution for metric2
mtrc2_mu_keep = mean(log(mtrc2_keep)); 
mtrc2_sd_keep = std(log(mtrc2_keep)); 
mtrc2_ix_keep = linspace(min(mtrc2_keep),max(mtrc2_keep)); 
mtrc2_iy_keep = pdf('lognormal', mtrc2_ix_keep, mtrc2_mu_keep, mtrc2_sd_keep);
mtrc2_mu_rjct = mean(log(mtrc2_rjct)); 
mtrc2_sd_rjct = std(log(mtrc2_rjct)); 
mtrc2_ix_rjct = linspace(min(mtrc2_rjct),max(mtrc2_rjct)); 
mtrc2_iy_rjct = pdf('lognormal', mtrc2_ix_rjct, mtrc2_mu_rjct, mtrc2_sd_rjct);

%plot sum vs max
figure
subplot(2,2,1:2)
scatter(log(mtrc1_keep), log(mtrc2_keep), 'MarkerEdgeColor', color_keep)
hold on
scatter(log(mtrc1_rjct), log(mtrc2_rjct), 'MarkerEdgeColor', color_rjct)
xlabel(mtrc1_label)
ylabel(mtrc2_label)
title('log-scale comparison', 'FontWeight','normal')

%plot distributions
subplot(2,2,3)
plot(mtrc1_ix_keep,mtrc1_iy_keep, 'Color',color_keep);
hold on
plot(mtrc1_ix_rjct,mtrc1_iy_rjct, 'Color',color_rjct);
t = title([mtrc1_label ' distrib'], 'FontWeight','normal', 'FontSize',9);
set(gca, 'FontSize',9)
subplot(2,2,4)
plot(mtrc2_ix_keep,mtrc2_iy_keep, 'Color',color_keep);
hold on
plot(mtrc2_ix_rjct,mtrc2_iy_rjct, 'Color',color_rjct);
t = title([mtrc2_label ' distrib'], 'FontWeight','normal', 'FontSize',9);
set(gca, 'FontSize',9)


