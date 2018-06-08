function [ ] = plot_classification_results( results )
% Function to plot decoding results (confusion matrix & weights, for now)
% Results are stored in structures & can be stored in cell arrays to
% visualize together in one figure

if iscell(results) %case cell array, just store them in a structure
    for i = 1:length(results)
        res(i) = results{i};
    end
results = res;    
end


count = 0;
for i = 1:length(results) %case structure
    
    count = count+1;
    if iscell(results(i).Confusion), results(i).Confusion = results(i).Confusion{1}; end %if confusion matrix is a cell, convert it
    subplot(length(results),2,count); imagesc((results(i).Confusion./sum(results(i).Confusion(:)))*100); title(sprintf('Accuracy = %f', results(i).Accuracy),'FontWeight','normal'); 
    c = colorbar; c.Label.String = 'Proportion trials (%)';
    if i==1, ylabel('Observed'); xlabel('Predicted'); end
    set(gca,'XTick',[1 2]); set(gca,'XTickLabel',results(i).Label); set(gca,'YTick',[1 2]); set(gca,'YTickLabel',results(i).Label); %plots confusion matrix
    set(gca,'TickLength',[0.001 0.001]); 
    
    count = count+1;
    subplot(length(results),2,count); line([1 length(results(i).Weights)], [0 0], 'LineStyle','--','color','k'); hold on; 
    plot(1:length(results(i).Weights),results(i).Weights, 'k'); xlim([1 length(results(i).Weights)]); %plots the weights
    set(gca,'XTick',1:length(results(i).Weights)); box off; grid on; xlabel('Feature number'); ylabel('Weight'); 
    if i==1, title('Feature weights','FontWeight','normal'); end
    
end


end

