function [ ] = plot_mds_features( features, trl_idx, outfile)
% Multi-dimensional scaling plots 

for i = 1:length(features)
    
    filename = sprintf([outfile '%d.fig'],i);
    fields = fieldnames(features(i));
    %exclude_features = {'chan_corr','wthn_chan_var','btwn_chan_var','wthn_chan_kurt','btwn_chan_kurt'}; fields(ismember(fields,exclude_features)) = []; 
    
    subplot_n = ceil(length(fields)/3);
    figure;
      
    for f = 1:length(fields)

        
        feature = getfield(features(i), fields{f})';
        Y = mdscale(squareform(pdist(feature)),2, 'criterion', 'strain', 'start', 'random'); %non-classical MDS with a criterion similar to that used in classical MDS, with random locations
    
        subplot(3,subplot_n,f); 
        plot(Y(trl_idx==1,1), Y(trl_idx==1,2), 'or', 'markerfacecolor', 'r','markersize', 3); hold on; %bad trl in red
        plot(Y(trl_idx==0,1), Y(trl_idx==0,2), 'sb', 'markerfacecolor', 'b','markersize', 3); hold on;
        title(fields{f});
    end
    
    savefig(filename);
    close;
    
end
    



end