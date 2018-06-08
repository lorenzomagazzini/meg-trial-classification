function [ ] = plot_confusion_matrices( filenames, titles)
%plot confusion matrices from different files
%filenames are the files to load, containing a scalar results structure
%titles is a cell array with the titles to assign each subplot

sub_n = ceil(length(filenames)/2);

figure;

for i = 1:length(filenames)
    
    load(filenames{i});
    subplot(2,sub_n,i);

    if iscell(results.Confusion), results.Confusion = results.Confusion{1}; end %if confusion matrix is a cell, convert it
    imagesc((results.Confusion./sum(results(1).Confusion(1,:)))*100); title({titles{i};sprintf('Accuracy = %0.2f%%', results(1).Accuracy)},'FontWeight','normal','FontSize',14);
    if results.Label(1)==0, ticklabels = {'Good','Bad'}; else ticklabels = {'Bad','Good'};end;
    c = colorbar; c.Label.String = 'Proportion trials (%)'; caxis([0 100]); colormap('parula');
    ylabel('Observed'); xlabel('Predicted');
    set(gca,'XTick',[1 2]); set(gca,'XTickLabel',ticklabels); set(gca,'YTick',[1 2]); set(gca,'YTickLabel',ticklabels); %plots confusion matrix
    set(gca,'TickLength',[0.001 0.001]);
    set(gca,'FontSize',14);


end

