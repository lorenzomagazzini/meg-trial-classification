function [ features ] = extract_trialfeatures_sw( data, do_plot )
%[ features ] = extract_trialfeatures( data, do_plot )
%   Extract a number of different trial features from the input data

% Written by Lorenzo Magazzini (magazzinil@gmail.com)


%%

if nargin < 2 || isempty(do_plot)
    do_plot = false;
else
    do_plot = istrue(do_plot);
end


%% initialise output

features = struct;

r = [0.89 0.10 0.11];
o = [0.99 0.55 0.24];


%% metric: within-channel variance ( mean & max across channels )

%define sliding window parameters
sw = struct;
sw.width = 0.1; %100ms
sw.overlap = 0.05; %50ms
sw.metric = 'wthn_chan_var';

%calculate variance over sliding window
[wthn_chan_var, sw_time] = calculate_sliding_window_metric(data, sw);

%plot example
if do_plot
    figure('units','normalized','position',[0 0 1 1],'color','w')
    for iTrial = 1:30
        
        subplot(3,10,iTrial)
        hold on
        
        plot(data.time{1}(1,:), data.trial{iTrial}(:,:) *1e12, 'color','k')
        ylim([-1 1]*5)% ylim([-1 1]*5e-12)
        set(gca,'box','on')
        
        thistrialmetric = max(wthn_chan_var(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e24, 'color',r, 'linewidth',2)
        
        thistrialmetric = mean(wthn_chan_var(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e25, 'color',o, 'linewidth',2)
        
    end
    suptitle(sprintf('%s (orange = channels mean, red = channels max)',strrep(sw.metric,'_',' ')))
end


%variance in 2D, by averaging over channels (within each sliding window)
wthn_chan_var_2d = squeeze(mean(wthn_chan_var));

%take max across sliding windows
wthn_chan_var_avg = max(wthn_chan_var_2d);
clear wthn_chan_var_2d

%variance in 2D, by taking max across channels (within each sliding window)
wthn_chan_var_2d = squeeze(max(wthn_chan_var));

%take max across sliding windows
wthn_chan_var_max = max(wthn_chan_var_2d);
clear wthn_chan_var_2d

%output
features.wthn_chan_var = wthn_chan_var;
features.wthn_chan_var_avg = wthn_chan_var_avg;
features.wthn_chan_var_max = wthn_chan_var_max;


%% metric: between-channel variance ( mean & max over time )

%define sliding window parameters
sw = struct;
sw.width = 0.1; %100ms
sw.overlap = 0.05; %50ms
sw.metric = 'btwn_chan_var';

%calculate variance over sliding window
[btwn_chan_var, sw_time] = calculate_sliding_window_metric(data, sw);

%plot example
if do_plot
    figure('units','normalized','position',[0 0 1 1],'color','w')
    for iTrial = 1:30
        
        subplot(3,10,iTrial)
        hold on
        
        plot(data.time{1}(1,:), data.trial{iTrial}(:,:) *1e12, 'color','k')
        ylim([-1 1]*5)% ylim([-1 1]*5e-12)
        set(gca,'box','on')
        
        thistrialmetric = max(btwn_chan_var(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e24, 'color',r, 'linewidth',2)
        
        thistrialmetric = mean(btwn_chan_var(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e25, 'color',o, 'linewidth',2)
        
    end
    suptitle(sprintf('%s (orange = samples mean, red = samples max)',strrep(sw.metric,'_',' ')))
end


%variance in 2D, by averaging over samples (within each sliding window)
btwn_chan_var_2d = squeeze(mean(btwn_chan_var));

%take max across sliding windows
btwn_chan_var_avg = max(btwn_chan_var_2d);
clear btwn_chan_var_2d

%variance in 2D, by taking max across samples (within each sliding window)
btwn_chan_var_2d = squeeze(max(btwn_chan_var));

%max variance across samples
btwn_chan_var_max = max(btwn_chan_var_2d);
clear btwn_chan_var_2d

%output
features.btwn_chan_var = btwn_chan_var;
features.btwn_chan_var_avg = btwn_chan_var_avg;
features.btwn_chan_var_max = btwn_chan_var_max;


%% metric: within-channel kurtosis ( mean & max across channels )

%define sliding window parameters
sw = struct;
sw.width = 0.1; %100ms
sw.overlap = 0.05; %50ms
sw.metric = 'wthn_chan_kurt';

%calculate kurtosis over sliding window
[wthn_chan_kurt, sw_time] = calculate_sliding_window_metric(data, sw);

%plot example
if do_plot
    figure('units','normalized','position',[0 0 1 1],'color','w')
    for iTrial = 1:30
        
        subplot(3,10,iTrial)
        hold on
        
        plot(data.time{1}(1,:), data.trial{iTrial}(:,:) *1e12, 'color','k')
        ylim([-1 1]*5)% ylim([-1 1]*5e-12)
        set(gca,'box','on')
        
        thistrialmetric = max(wthn_chan_kurt(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e-1, 'color',r, 'linewidth',2)
        
        thistrialmetric = mean(wthn_chan_kurt(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric)), 'color',o, 'linewidth',2)
        
    end
    suptitle(sprintf('%s (orange = channels mean, red = channels max)',strrep(sw.metric,'_',' ')))
end


%kurtosis in 2D, by averaging over channels (within each sliding window)
wthn_chan_kurt_2d = squeeze(mean(wthn_chan_kurt));

%take max across sliding windows
wthn_chan_kurt_avg = max(wthn_chan_kurt_2d);
clear wthn_chan_kurt_2d

%kurtosis in 2D, by taking max across samples (within each sliding window)
wthn_chan_kurt_2d = squeeze(max(wthn_chan_kurt));

%take max across sliding windows
wthn_chan_kurt_max = max(wthn_chan_kurt_2d);
clear wthn_chan_kurt_2d

%output
features.wthn_chan_kurt = wthn_chan_kurt;
features.wthn_chan_kurt_avg = wthn_chan_kurt_avg;
features.wthn_chan_kurt_max = wthn_chan_kurt_max;


%% metric: between-channel kurtosis ( mean & max over time )

%define sliding window parameters
sw = struct;
sw.width = 0.1; %100ms
sw.overlap = 0.05; %50ms
sw.metric = 'btwn_chan_kurt';

%calculate kurtosis over sliding window
[btwn_chan_kurt, sw_time] = calculate_sliding_window_metric(data, sw);

%plot example
if do_plot
    figure('units','normalized','position',[0 0 1 1],'color','w')
    for iTrial = 1:30
        
        subplot(3,10,iTrial)
        hold on
        
        plot(data.time{1}(1,:), data.trial{iTrial}(:,:) *1e12, 'color','k')
        ylim([-1 1]*5)% ylim([-1 1]*5e-12)
        set(gca,'box','on')
        
        thistrialmetric = max(btwn_chan_kurt(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e-1, 'color',r, 'linewidth',2)
        
        thistrialmetric = mean(btwn_chan_kurt(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric))*1e-1, 'color',o, 'linewidth',2)
        
    end
    suptitle(sprintf('%s (orange = samples mean, red = samples max)',strrep(sw.metric,'_',' ')))
end


%kurtosis in 2D, by averaging over channels (within each sliding window)
btwn_chan_kurt_2d = squeeze(mean(btwn_chan_kurt));

%take max across sliding windows
btwn_chan_kurt_avg = max(btwn_chan_kurt_2d);
clear btwn_chan_kurt_2d

%kurtosis in 2D, by taking max across samples (within each sliding window)
btwn_chan_kurt_2d = squeeze(max(btwn_chan_kurt));

%take max across sliding windows
btwn_chan_kurt_max = max(btwn_chan_kurt_2d);
clear btwn_chan_kurt_2d

%output
features.btwn_chan_kurt = btwn_chan_kurt;
features.btwn_chan_kurt_avg = btwn_chan_kurt_avg;
features.btwn_chan_kurt_max = btwn_chan_kurt_max;


%% metric: within-channel correlation ( mean & max across channels )

%define sliding window parameters
sw = struct;
sw.width = 0.1; %100ms
sw.overlap = 0.05; %50ms
sw.metric = 'wthn_chan_corr';

%calculate kurtosis over sliding window
[wthn_chan_corr, sw_time] = calculate_sliding_window_metric(data, sw);

%plot example
if do_plot
    figure('units','normalized','position',[0 0 1 1],'color','w')
    for iTrial = 1:30
        
        subplot(3,10,iTrial)
        hold on
        
        plot(data.time{1}(1,:), data.trial{iTrial}(:,:) *1e12, 'color','k')
        ylim([-1 1]*5)% ylim([-1 1]*5e-12)
        set(gca,'box','on')
        
        thistrialmetric = max(wthn_chan_corr(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric)), 'color',r, 'linewidth',2)
        
        thistrialmetric = mean(wthn_chan_corr(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric)), 'color',o, 'linewidth',1, 'linestyle','--')
        
    end
    suptitle(sprintf('%s (orange = channels mean, red = channels max)',strrep(sw.metric,'_',' ')))
end


%correlaton in 2D, by averaging over channels (within each sliding window)
wthn_chan_corr_2d = squeeze(mean(wthn_chan_corr));

%take max across sliding windows
wthn_chan_corr_avg = max(wthn_chan_corr_2d);
clear wthn_chan_corr_2d

%correlaton in 2D, by taking max across channels (within each sliding window)
wthn_chan_corr_2d = squeeze(max(wthn_chan_corr));

%max correlation across channels
wthn_chan_corr_max = max(wthn_chan_corr_2d);
clear wthn_chan_corr_2d

%output
features.wthn_chan_corr = wthn_chan_corr;
features.wthn_chan_corr_avg = wthn_chan_corr_avg;
features.wthn_chan_corr_max = wthn_chan_corr_max;


%% metric: between-channel correlation ( mean & max over time )

%define sliding window parameters
sw = struct;
sw.width = 0.1; %100ms
sw.overlap = 0.05; %50ms
sw.metric = 'btwn_chan_corr';

%calculate kurtosis over sliding window
[btwn_chan_corr, sw_time] = calculate_sliding_window_metric(data, sw);

%plot example
if do_plot
    figure('units','normalized','position',[0 0 1 1],'color','w')
    for iTrial = 1:30
        
        subplot(3,10,iTrial)
        hold on
        
        plot(data.time{1}(1,:), data.trial{iTrial}(:,:) *1e12, 'color','k')
        ylim([-1 1]*5)% ylim([-1 1]*5e-12)
        set(gca,'box','on')
        
        thistrialmetric = max(btwn_chan_corr(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric)), 'color',r, 'linewidth',2)
        
        thistrialmetric = mean(btwn_chan_corr(:,:,iTrial));
        plot(sw_time, (thistrialmetric-mean(thistrialmetric)), 'color',o, 'linewidth',1, 'linestyle','--')
        
    end
    suptitle(sprintf('%s (orange = samples mean, red = samples max)',strrep(sw.metric,'_',' ')))
end


%correlaton in 2D, by averaging over channels (within each sliding window)
btwn_chan_corr_2d = squeeze(mean(btwn_chan_corr));

%take max across sliding windows
btwn_chan_corr_avg = max(btwn_chan_corr_2d);
clear btwn_chan_corr_2d

%correlaton in 2D, by taking max across channels (within each sliding window)
btwn_chan_corr_2d = squeeze(max(btwn_chan_corr));

%max correlation across channels
btwn_chan_corr_max = max(btwn_chan_corr_2d);
clear btwn_chan_corr_2d

%output
features.btwn_chan_corr = btwn_chan_corr;
features.btwn_chan_corr_avg = btwn_chan_corr_avg;
features.btwn_chan_corr_max = btwn_chan_corr_max;

