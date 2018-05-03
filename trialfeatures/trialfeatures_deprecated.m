

%% metric: Hurst exponent ( average & range across channels )

% %calculate variance
% hexp = get_hurst_exponent(data);
% 
% %plot (channels x trials matrix)
% % close all
% figure
% imagesc(hexp')
% colorbar
% title('Hurst exponent')
% xlabel('channels')
% ylabel('trials')
% try colormap(cmocean('amp')); catch, colormap('hot'); end
% 
% %average Hurst exp across channels
% hexp_mean = mean(hexp);
% 
% %range of Hurst exp across channels (any deviation whether + or - can indicate noise)
% hexp_range = max(hexp) - min(hexp);
% 
% % plot_metric_comparison
% mtrc1 = hexp_mean;
% mtrc2 = hexp_range;
% mtrc1_label = 'Hurst exp mean';
% mtrc2_label = 'Hurst exp range';
% plot_metric_comparison(mtrc1, mtrc2, mtrc1_label, mtrc2_label, trls_keep, trls_rjct)


%% plot histogram bars separately for keep and reject trials

% % close all
% 
% figure('color','w')
% 
% mtrc = hexp_mean;
% mtrc_label = 'Hurst exponent mean';
% subplot(1,2,1)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )
% 
% mtrc = hexp_range;
% mtrc_label = 'Hurst exponent range';
% subplot(1,2,2)
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% deviation of trial from other trials - tentative...
% if using supervised ML - this has to be applied while maintaining
% train/test independence....

% trl_dev = get_trial_deviation(data);
% sum_trl_dev = sum(abs(trl_dev),1); %sum of deviations across channels
% 
% % plot histogram bars separately for keep and reject trials
% 
% figure('color','w')
% 
% mtrc = sum_trl_dev;
% mtrc_label = 'sum trial deviation';
% plot_metric_histogram( mtrc, mtrc_label, trls_keep, trls_rjct )


%% Do we still need this?
% feature: z-value modelled after ft_artifact_zvalue

% cfg = [];
% cfg.bpfilter = 'yes';
% cfg.bpfreq = [110 140]; %e.g. for muscle artifacts
% cfg.bpfiltord = 8;
% hf = ft_preprocessing(cfg,data);
% trl = cat(3,hf.trial{:});
% 
% sumval = nansum(trl,2); %sum amplitudes across samples
% sumsq = nansum(trl.^2,2); %sum of squares across samples
% datavg = squeeze(sumval./size(trl,2)); %average for all channels
% datstd = squeeze(sqrt(sumsq./size(trl,2) - (sumval./size(trl,2)).^2)); %SD for all channels
% 
% %now create z-score data matrix by looping through trials
% zdata = zeros(size(trl));
% for i = 1:size(trl,3)
%     zdata(:,:,i) = (trl(:,:,i) - datavg(:,i*ones(1,size(trl,2))))./datstd(:,i*ones(1,size(trl,2)));
% end;
% 
% %get summary metrics of z-scores across channles
% zsum = squeeze(nansum(zdata,1))';
% zmax = squeeze(max(zdata,[],1))';
% %zvar = squeeze(var(zdata,[],1))';
% 
% demean = 0; %demean flag - CHANGE ME
% if demean
%     for ii = 1:size(zmax,1)
%         zmax(ii,:) = zmax(ii,:) - mean(zmax(ii,:),2);
%         zsum(ii,:) = zsum(ii,:) - mean(zsum(ii,:),2);
%         %zvar(ii,:) = zvar(ii,:) - mean(zvar(ii,:),2);
%     end;
% end;
% zvar = zsum./sqrt(size(trl,1)); 
% 
% %plot z-value metrics
% figure;
% subplot(3,2,1); plot(1:num_bad, var(zvar(trls_rjct,:),[],2),'.r',num_bad+1:100, var(zvar(trls_keep,:),[],2),'.b'); title('Variance of z-value'); 
% subplot(3,2,2); plot(1:num_bad, var(zmax(trls_rjct,:),[],2),'.r',num_bad+1:100, var(zmax(trls_keep,:),[],2),'.b'); title('Maximal z-value')
% subplot(3,2,3); plot(data.time{1},zvar(trls_rjct,:),'r');title('Var z (per trial - bad)'); ylim([min(zvar(:)) max(zvar(:))])
% subplot(3,2,4); plot(data.time{1},zvar(trls_keep,:),'b');title('Var z (per trial - good)'); ylim([min(zvar(:)) max(zvar(:))])
% subplot(3,2,5); plot(data.time{1},zmax(trls_rjct,:),'r');title('Max z-value (per trial - bad)'); ylim([min(zmax(:)) max(zmax(:))])
% subplot(3,2,6); plot(data.time{1},zmax(trls_keep,:),'b');title('Max z-value (per trial - good)'); ylim([min(zmax(:)) max(zmax(:))])

