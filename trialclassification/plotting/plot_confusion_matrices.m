function [ ] = plot_confusion_matrices( filenames, titles)
%Function to plot confusion matrices from different files.
%Inputs:
%      filenames are the files to load, each containing a scalar results structure
%      titles is a cell array with the titles to assign each subplot
%
% Dima DC 2018 (diana.c.dima@gmail.com)

sub_n = ceil(length(filenames)/2); %subplots will be organized in 2 rows
figure('color','w');

for i = 1:length(filenames) %loop through requested files
    
    load(filenames{i});
    subplot(2,sub_n,i);

    if iscell(results.Confusion), results.Confusion = results.Confusion{1}; end %if confusion matrix is a cell, convert it to a matrix
    imagesc((results.Confusion./sum(results.Confusion(1,:)))*100); %plot the confusion matrix as percentages
    title({titles{i}; sprintf('Accuracy = %0.2f%%', results.Accuracy)},'FontWeight','normal','FontSize',14); %title contains accuracy
    if results.Label(1)==0, ticklabels = {'Good','Bad'}; else ticklabels = {'Bad','Good'}; end; %bad trials are indexed as 1; account for possible changes in label order 
    c = colorbar; c.Label.String = 'Proportion trials (%)'; caxis([0 100]); colormap('parula'); 
    ylabel('Observed'); xlabel('Predicted');
    set(gca,'XTick',[1 2]); set(gca,'XTickLabel',ticklabels); set(gca,'YTick',[1 2]); set(gca,'YTickLabel',ticklabels);
    set(gca,'TickLength',[0.001 0.001]);
    set(gca,'FontSize',14);


end

