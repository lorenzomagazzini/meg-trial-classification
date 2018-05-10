

w_freq = logspace(log10(2),log10(150),25) %frequency array (log-spaced)
% w_freq = 1:2:150 %frequency array

w_width = 5; %cycles
w_dur = w_width./w_freq/pi %wavelet duration (time resolution)
w_smooth = w_freq./w_width*2

%wavelet analysis
cfg = [];
cfg.method      = 'wavelet';
cfg.width       = w_width;
cfg.foi         = w_freq;
cfg.toi         = data.time{1}(1) : 0.025 : data.time{1}(end);
cfg.output      = 'pow';
cfg.keeptrials  = 'yes';
w_data = ft_freqanalysis(cfg, data);

color_keep = [35,139,69]/255;
color_rjct = [215,48,31]/255;

figure
for r = 1:100;% 1:size(w_data.powspctrm,1)
    
    fprintf('trial %d\n', r)
    
    if ismember(r, trls_indx_keep); color_this = color_keep;
    elseif ismember(r, trls_indx_rjct); color_this = color_rjct; 
    else error;
    end
    
%     %select single trial (Chan x Freq x Time matrix)
% %     cfg = [];
% %     cfg.trials = r;
% %     R = ft_selectdata(cfg, w_data);
%     R = squeeze(w_data.powspctrm(r,:,:,:));
    
    c_coeffs = [];
    for c = 1:size(w_data.powspctrm,2)
        
%         %select single channel (Freq x Time matrix)
% %         cfg = [];
% %         cfg.channel = c;
% %         C = ft_selectdata(cfg, R);
%         C = squeeze(R(c,:,:));
%         
%         %plot
% %         cfg = [];
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
        
        t_coeffs = nan(size(w_data.powspctrm,4),2);
        for t = 1:size(w_data.powspctrm,4)
            
%             %select single timepoint (Freq vector)
% %             powspctrm = squeeze(squeeze(C.powspctrm(1,1,:,t)));
%             powspctrm = C(:,t);
%             
% %             %plot
% %             % figure
% %             hold on;
% %             plot(C.freq, powspctrm)
% %             xlim([C.freq(1) C.freq(end)])
%             
%             %simple case: 2 values (low-freq and high-freq pow)
%             t_coeffs(t,1) = nanmean(powspctrm(1:7)); %hardcoded freqs below 7Hz
%             t_coeffs(t,2) = nanmean(powspctrm(16:25)); %hardcoded freqs above 30Hz
            
            t_coeffs(t,:) = [sum(w_data.powspctrm(r,c,1:7,t)) sum(w_data.powspctrm(r,c,16:25,t))];
            
        end %t
        
        c_coeffs = [c_coeffs; t_coeffs];
        
    end %c
    
    hold on% figure
    s = scatter(log(c_coeffs(:,1)), log(c_coeffs(:,2)), 2, 'filled', 'MarkerFaceColor',color_this, 'MarkerEdgeColor','none');% , 'MarkerFaceAlpha',.2
    
    drawnow
    
end

