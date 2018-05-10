function [  ] = plot_featurepairs( features, ntrl, trls_keep, trls_rjct )
%[  ] = plot_featurepairs( features, ntrl, trls_keep, trls_rjct )
%   
%   Input:
%       features        struct (only fields of size 1 x ntrl are kept)
%       ...


featurepairs = get_featurepairs(features, ntrl);
nf = length(unique(featurepairs(:,2)));
np = size(featurepairs,1);


figure
set(gcf, 'units','normalized', 'outerposition',[0 0 1 1])
set(gcf, 'color','white')

for p = 1:np
    
    subplot(nf+1,nf+1,p)
    
    %metrics to plot
    mtrc1 = featurepairs{p,1}(1,:);
    mtrc2 = featurepairs{p,1}(2,:);
    mtrc1_label = strrep(featurepairs{p,2},'_',' ');
    mtrc2_label = strrep(featurepairs{p,3},'_',' ');
    
    %plotting colors
    color_keep = [35,139,69]/255;
    color_rjct = [215,48,31]/255;
    
    %separate keep and reject trials
    mtrc1_keep = mtrc1(trls_keep);
    mtrc1_rjct = mtrc1(trls_rjct);
    mtrc2_keep = mtrc2(trls_keep);
    mtrc2_rjct = mtrc2(trls_rjct);
    
    %plot sum vs max
    scatter(log(mtrc1_keep), log(mtrc2_keep), 2, 'MarkerEdgeColor', color_keep, 'MarkerFaceColor', 'none')
    hold on
    scatter(log(mtrc1_rjct), log(mtrc2_rjct), 2, 'MarkerEdgeColor', color_rjct, 'MarkerFaceColor', 'none')
    hA = gca;
    hA.Box = 'on';
    hA.XTickLabel = '';
    hA.YTickLabel = '';
    hA.XLim = [min(log(mtrc1)) max(log(mtrc1))];
    hA.YLim = [min(log(mtrc2)) max(log(mtrc2))];
    
    drawnow
    
    if ismember(p,1:nf+1:np)
        ylabel({mtrc1_label(1:round(length(mtrc1_label)/2)) mtrc1_label(round(length(mtrc1_label)/2)+1:end)});% ylabel(mtrc1_label);
    end
    if ismember(p,np-nf:np)
        xlabel({mtrc2_label(1:round(length(mtrc2_label)/2)) mtrc2_label(round(length(mtrc2_label)/2)+1:end)});% xlabel(mtrc2_label)
    end
    
end

