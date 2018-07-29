function [ ] = plot_mds_features( features, trl_idx, outfile)
% Multi-dimensional scaling plots 
% Inputs: --features - structure as output by the feature extraction scripts
%         --trl_idx - labels of good vs bad trials (1:bad, 0:good)
%         --outfile - figure filename. For non-scalar structure arrays, the
%                     number of figures saved = the size of the structure array.

% Written by Diana Dima (diana.c.dima@gmail.com)


%%

for i = 1:length(features)
    
    filename = sprintf([outfile '%d.fig'],i);
    fields = fieldnames(features(i));
    %exclude_features = {'chan_corr','wthn_chan_var','btwn_chan_var','wthn_chan_kurt','btwn_chan_kurt'}; fields(ismember(fields,exclude_features)) = []; %don't need this now
    
    subplot_n = ceil(length(fields)/3);
    figure;
    
    for f = 1:length(fields)
        
        feature = getfield(features(i), fields{f})';
        Y = mdscale(squareform(pdist(feature)),2, 'criterion', 'strain', 'start', 'random'); %non-classical MDS with a criterion similar to that used in classical MDS, with random locations
        
        subplot(3,subplot_n,f);
        plot(Y(trl_idx==1,1), Y(trl_idx==1,2), 'or', 'markerfacecolor', 'r','markersize', 3); hold on; %bad trl in red
        plot(Y(trl_idx==0,1), Y(trl_idx==0,2), 'sb', 'markerfacecolor', 'b','markersize', 3); hold on;
        title(strrep(fields{f},'_',' '));
    end
    
    %maximise
    set(gcf, 'Units','normalized', 'Position',[0 0 1 1])
    
    savefig(filename);
    % close; %uncomment to close figure after plotting
    
end

