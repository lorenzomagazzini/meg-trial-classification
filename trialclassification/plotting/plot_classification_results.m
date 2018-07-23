function [ ] = plot_classification_results( results )
% Function to plot main decoding results (confusion matrix & classifier weights).
% Input: results - either a struct (scalar or vectorial), or a cell array containing structs
%        useful for visualizing several results together.
%
%Dima DC 2018 (diana.dima@gmail.com)

if iscell(results) %if cell array, store them in a structure
    for i = 1:length(results)
        res(i) = results{i}; %#ok<AGROW>
    end
results = res;    
end


count = 0;
for i = 1:length(results) 
    
    count = count+1;
    if iscell(results(i).Confusion), results(i).Confusion = results(i).Confusion{1}; end %if confusion matrix is a cell, get matrix
    subplot(length(results),2,count); 
    imagesc((results(i).Confusion./sum(results(i).Confusion(:)))*100); title(sprintf('Accuracy = %f', results(i).Accuracy),'FontWeight','normal'); %plot confusion matrix
    c = colorbar; c.Label.String = 'Proportion trials (%)';
    if i==1, ylabel('Observed'); xlabel('Predicted'); end
    set(gca,'XTick',[1 2]); set(gca,'XTickLabel',results(i).Label); set(gca,'YTick',[1 2]); set(gca,'YTickLabel',results(i).Label); 
    set(gca,'TickLength',[0.001 0.001]); 
    
    count = count+1;
    subplot(length(results),2,count); line([1 length(results(i).Weights)], [0 0], 'LineStyle','--','color','k'); hold on;
    plot(1:length(results(i).Weights),results(i).Weights, 'k'); xlim([1 length(results(i).Weights)]); %plot the weights
    set(gca,'XTick',1:length(results(i).Weights)); box off; grid on; xlabel('Feature number'); ylabel('Weight'); 
    if i==1, title('Feature weights','FontWeight','normal'); end
    
end


end

