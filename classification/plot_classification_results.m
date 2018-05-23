function [ ] = plot_classification_results( results )
% Function to plot decoding results (confusion matrix & weights, for now)
% Results are stored in structures & can be stored in cell arrays to
% visualize together in one figure

count = 0;
for i = 1:length(results)
    
    count = count+1;
    if iscell(results{i}.Confusion), results{i}.Confusion = results{i}.Confusion{1}; end;
    subplot(length(results),2,count); imagesc(results{i}.Confusion./sum(results{i}.Confusion(:))); title(sprintf('Accuracy = %f', results{i}.Accuracy),'FontWeight','normal'); 
    ylabel('Observed'); xlabel('Predicted'); set(gca,'XTick',[1 2]); set(gca,'XTickLabel',results{1}.Label); set(gca,'YTick',[1 2]); set(gca,'YTickLabel',results{1}.Label);
    
    count = count+1;
    subplot(length(results),2,count); plot(1:length(results{i}.Weights),results{i}.Weights); title('Weights','FontWeight','normal');
    
end


end

