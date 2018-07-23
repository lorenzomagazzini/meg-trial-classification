
% Written by Lorenzo Magazzini (magazzinil@gmail.com)


%% power (frequency)

%FFT analysis
cfg = [];
cfg.method      = 'mtmfft';
cfg.output      = 'pow';
cfg.keeptrials  = 'yes';
cfg.foilim      = [0 data.fsample/2];
cfg.taper       = 'hanning';
fftdata = ft_freqanalysis(cfg, data);


%average over channels
cfg = [];
cfg.avgoverchan = 'yes';
fftdata_chanavg = ft_selectdata(cfg, fftdata);

%sum power over all frequencies
fft_chanavg_powsum = sum(squeeze(fftdata_chanavg.powspctrm)');

%select band-limited power
cfg = [];
cfg.avgoverchan = 'yes';
cfg.frequency = [1 5];
fftdata_bandlim_chanavg = ft_selectdata(cfg, fftdata);

%sum power over all frequencies
fft_bandlim_powsum = sum(squeeze(fftdata_bandlim_chanavg.powspctrm)');


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
    plot(fftdata_chanavg.freq, squeeze(fftdata_chanavg.powspctrm(t,:,:)), 'color',color_plot(t,:))
%     plot(fftdata_chanavg.freq, log(squeeze(fftdata_chanavg.powspctrm(t,:,:))), 'color',color_plot(t,:))
    xlim([0 30])
    xlabel('frequency')
    ylabel('power')
end
title('chan-avg spectra')
subplot(1,3,2)
scatter(1:ntrl, fft_chanavg_powsum, 10, color_plot, 'filled')
xlim([1 ntrl])
xlabel('trials')
title('chan-avg power sum')
subplot(1,3,3)
scatter(1:ntrl, fft_bandlim_powsum, 10, color_plot, 'filled')
xlim([1 ntrl])
xlabel('trials')
title('band-lim power sum')


%% power (time-frequency)

%multitaper time-frequency analysis
cfg = [];
cfg.output      = 'pow';
cfg.keeptrials	= 'yes';
cfg.method      = 'mtmconvol';
cfg.taper       = 'dpss';
cfg.foi         = 1:1:data.fsample/2;
cfg.tapsmofrq   = 4 * ones(1,length(cfg.foi));
cfg.t_ftimwin   = 0.4 * ones(1,length(cfg.foi));
cfg.toi         = -1.5:0.05:1.5;

%check tapers
% disp('The following is 1) frequency, 2) smoothing (in +/- Hz), 3) number of tapers:')
K = 2.*cfg.t_ftimwin.*cfg.tapsmofrq-1;
% [cfg.foi; cfg.tapsmofrq; K]
if any(K<=0), error('check selected number of tapers'); end

%do multitaper analysis
tfdata = ft_freqanalysis(cfg, data);


%average over channels
cfg = [];
cfg.avgoverchan = 'yes';
tfdata_chanavg = ft_selectdata(cfg, tfdata);

%sum power over all frequencies
tf_chanavg_powsum = squeeze(sum(squeeze(tfdata_chanavg.powspctrm),2))';

%max across time
tf_chanavg_powsum_timemax = max(tf_chanavg_powsum);

%max across time
tf_chanavg_powsum_timestd = std(tf_chanavg_powsum);


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
% for t = 1:ntrl
for t = [1:5 7:27 29:ntrl]
    if trls_keep(t)
        color_plot(t,:) = color_keep;
    else
        color_plot(t,:) = color_rjct;
    end
    hold on
    plot(tfdata_chanavg.time, tf_chanavg_powsum(:,t), 'color',color_plot(t,:))
    xlabel('time')
    ylabel('freq-sum power')
end
title('freq-sum power timecourse')
subplot(1,3,2)
scatter(1:ntrl, tf_chanavg_powsum_timemax, 10, color_plot, 'filled')
xlim([1 ntrl])
xlabel('trials')
title('max across time')
subplot(1,3,3)
scatter(1:ntrl, tf_chanavg_powsum_timestd, 10, color_plot, 'filled')
xlim([1 ntrl])
xlabel('trials')
title('SD across time')

