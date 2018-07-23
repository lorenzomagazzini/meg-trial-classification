

%% data padding

paddata = data;

padlength   = 2* ceil( abs(data.time{1}(end)-data.time{1}(1)) ) * data.fsample;
prepadlength = padlength/2;
postpadlength = padlength/2;
padtype     = 'mirror';

for i = 1:length(data.trial)
    
    dat = ft_preproc_padding(data.trial{i}, padtype, prepadlength, postpadlength);
    tim = linspace(data.time{i}(1)-(padlength/data.fsample)/2, data.time{i}(end)+(padlength/data.fsample)/2, size(dat,2));
    
    paddata.trial{i} = dat;
    paddata.time{i} = tim;
    
end

% figure, plot(paddata.time{i}, paddata.trial{i}(100,:))
% hold on, plot(data.time{i}, data.trial{i}(100,:))


%% wavelet time-frequency decomposition

foilim = [2 120]
foinum = 20;

%frequency array (log-spaced)
w_freq = logspace(log10(foilim(1)), log10(foilim(2)), foinum)
% w_freq = foilim(1):2:foilim(2)

%wavelet cycles
w_width = 3;

%wavelet bandwidth (freq resolution)
w_smooth = w_freq./w_width*2

%wavelet duration (time resolution)
w_dur = w_width./w_freq/pi

%wavelet analysis
cfg = [];
cfg.method      = 'wavelet';
cfg.width       = w_width;
cfg.foi         = w_freq;
cfg.toi         = data.time{1}(1) : 0.025 : data.time{1}(end);
cfg.output      = 'pow';
cfg.keeptrials  = 'yes';
w_paddata = ft_freqanalysis(cfg, paddata);

%trim data
cfg = [];
cfg.latency = [data.time{1}(1) data.time{1}(end)];
w_data = ft_selectdata(cfg, w_paddata);


% %plot time-freq map
% cfg = [];
% cfg.trials = 1; %select single trial (Chan x Freq x Time matrix)
% cfg.channel = 1; %select single channel (Freq x Time matrix)
% tmp = ft_selectdata(cfg, w_data);
% figure
% cfg = [];
% cfg.ylim = [w_freq(1) w_freq(end)];
% ft_singleplotTFR(cfg, tmp)
% colormap(cmocean('amp'));


%% get NPoints-by-NCoefficients matrix

%FIXME: should probably simply use reshape instead of endless loop

n_rpt = size(w_data.powspctrm,1);
n_chan = size(w_data.powspctrm,2);
n_time = size(w_data.powspctrm,4);
n_coeffs = size(w_data.powspctrm,3);
w_coeffs = nan(n_rpt*n_chan*n_time,n_coeffs);
coeff_class = nan(n_rpt*n_chan*n_time,n_coeffs);
coeff_count = 0;
for rpt = 1:n_rpt %loop over trials
    fprintf('trial %d\n', rpt)
    for chan = 1:n_chan %loop over channels
        for time = 1:n_time %loop over timepoints
            coeff_count = coeff_count + 1;
            coeff_class(coeff_count,1) = ismember(rpt, trls_rjct); %class, 1=reject, 0=keep
            w_coeffs(coeff_count,:) = w_data.powspctrm(rpt,chan,:,time); %wavelet coefficients (i.e. power at each freq)
        end
    end
end

color_keep = [35,139,69]/255;
color_rjct = [215,48,31]/255;

figure
hold on
plot(w_freq, nanmean(w_coeffs(coeff_class==0,:)), 'color',color_keep)
plot(w_freq, nanmean(w_coeffs(coeff_class==1,:)), 'color',color_rjct)


%% cluster (log) coefficients around K means

%FIXME: problem with missing data (NaNs from wavelet estimation)

close all
figure

nk = 16;
hist_all = cell(nk,1);
hist_keep = cell(nk,1);
hist_rjct = cell(nk,1);

kcount = 0;
for k = 2:nk
    
    kcount = kcount + 1;
    
    [idx, C, sumd, D] = kmeans(log(w_coeffs), k);
    hist_all{kcount} = hist(idx, 1:k);
    
    idx_keep = idx(coeff_class==0);
    idx_rjct = idx(coeff_class==1);
    
    hist_keep{kcount} = hist(idx_keep, 1:k);
    hist_rjct{kcount} = hist(idx_rjct, 1:k);
    
    subplot(3, nk, kcount)
    bar(1:k, hist_all{kcount})
    xlim([0 k+1])
    
    subplot(3, nk, kcount+nk)
    bar(1:k, hist_keep{kcount}./sum(hist_keep{kcount}))
    xlim([0 k+1])
    
    subplot(3, nk, kcount+nk*2)
    bar(1:k, hist_rjct{kcount}./sum(hist_rjct{kcount}))
    xlim([0 k+1])
    
    drawnow
    
end


%% find K with largest distance between (normalised) histograms

rmse = nan(nk,1);
for kcount = 1:15
    
    f1 = hist_keep{kcount}'./sum(hist_keep{kcount});
    f2 = hist_rjct{kcount}'./sum(hist_rjct{kcount});
    
    % pdist2(f1, f2)
    rmse(kcount,1) = sqrt(mean((f1-f2).^2));
    
end

figure, plot(1:nk, rmse)


%% testing PCA across channels (for single-trial data) ... deprecated

% X = data.trial{1};
% close all
% figure, hold on
% for c = 1:size(X,1), plot(X(c,:),'k'); end
% COEFF = pca(X);
% plot(COEFF(:,1).*(max(max(abs(X)))),'r')
% COEFF = pca(abs(X));
% plot(COEFF(:,1).*(max(max(abs(X)))),'w')


%% more deprecated code

% % r = 1
% % %select single trial (Chan x Freq x Time matrix)
% % cfg = [];
% % cfg.trials = r;
% % R = ft_selectdata(cfg, w_data);
% % c_coeffs = [];
% % c = 1
% % %select single channel (Freq x Time matrix)
% % cfg = [];
% % cfg.channel = c;
% % C = ft_selectdata(cfg, R);
% % figure
% % cfg = [];
% % cfg.ylim = [w_freq(1) w_freq(end)];
% % ft_singleplotTFR(cfg,C)
% % colormap(cmocean('amp'));
% 
% 
% color_keep = [35,139,69]/255;
% color_rjct = [215,48,31]/255;
% 
% figure
% for r = 1:size(w_data.powspctrm,1)
%     
%     fprintf('trial %d\n', r)
%     
% %     if ismember(r, trls_indx_keep); color_this = color_keep;
% %     elseif ismember(r, trls_indx_rjct); color_this = color_rjct; 
% %     else error;
% %     end
%     
% %     %select single trial (Chan x Freq x Time matrix)
% %     cfg = [];
% %     cfg.trials = r;
% %     R = ft_selectdata(cfg, w_data);
% % %     R = squeeze(w_data.powspctrm(r,:,:,:));
%     
%     c_coeffs = [];
%     for c = 1:size(w_data.powspctrm,2)
%         
% %         %select single channel (Freq x Time matrix)
% %         cfg = [];
% %         cfg.channel = c;
% %         C = ft_selectdata(cfg, R);
% % %         C = squeeze(R(c,:,:));
%         
%         %plot
% %         figure
% %         cfg = [];
% %         cfg.ylim = [w_freq(1) w_freq(end)];
% %         ft_singleplotTFR(cfg,C)
% %         colormap(cmocean('amp'));
%         
%         % %log-power
%         % C.logspctrm = log(C.powspctrm);
%         % cfg = [];
%         % cfg.parameter = 'logspctrm';
%         % figure
%         % ft_singleplotTFR(cfg,C)
%         % colormap(cmocean('amp'));
%         % figure
%         
%         t_coeffs = nan(size(w_data.powspctrm,4),2);
%         for t = 1:size(w_data.powspctrm,4)
%             
% %             %select single timepoint (Freq vector)
% % %             powspctrm = squeeze(squeeze(C.powspctrm(1,1,:,t)));
% %             powspctrm = C(:,t);
% %             
% % %             %plot
% % %             % figure
% % %             hold on;
% % %             plot(C.freq, powspctrm)
% % %             xlim([C.freq(1) C.freq(end)])
% %             
% %             %simple case: 2 values (low-freq and high-freq pow)
% %             t_coeffs(t,1) = nanmean(powspctrm(1:5)); %hardcoded freqs below 6Hz
% %             t_coeffs(t,2) = nanmean(powspctrm(14:20); %hardcoded freqs above 30Hz
% %             t_coeffs(t,:) = [sum(w_data.powspctrm(r,c,1:5,t)) sum(w_data.powspctrm(r,c,14:20,t))];
%             
%         end %t
%         
%         c_coeffs = [c_coeffs; t_coeffs];
%         
%     end %c
%     
%     hold on% figure
%     s = scatter(log(c_coeffs(:,1)), log(c_coeffs(:,2)), 2, 'filled', 'MarkerFaceColor',color_this, 'MarkerEdgeColor','none');% , 'MarkerFaceAlpha',.2
%     drawnow
%     
% end

