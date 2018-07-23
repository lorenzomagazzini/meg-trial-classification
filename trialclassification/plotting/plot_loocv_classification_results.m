function [ ] = plot_loocv_classification_results( results )
% Function to plot decoding results from leave-one-subject-out cross-validation (accuracy, specificity, sensitivity)
% Input: results - either a struct (scalar or vectorial), or a cell array containing structs
%        useful for visualizing LOO-CV results, where we have results for each left-out participant.
%
%Dima DC 2018 (diana.dima@gmail.com)

if iscell(results) %case cell array, just store them in a structure
    for i = 1:length(results)
        res(i) = results{i}; %#ok<AGROW>
    end
    results = res;
end

figure('color','w');
subplot(1,2,1);

%first plot accuracy & error for each left-out subject
%useful to spot any outliers
for i = 1:length(results)
    
    line([0 length(results)+1], [50 50], 'LineStyle','--','color','k'); hold on;
    errorbar(i,results(i).Accuracy,results(i).AccuracyMSError, 'color','k','LineWidth',2); hold on;
end

box off; xlim([0 length(results)+1]); ylim([min([results(:).Accuracy])-5 max([results(:).Accuracy])+5]);
xlabel('Left out subject','FontSize',14); ylabel('Accuracy','FontSize',14); hold on;
set(gca,'FontSize',14); set(gca,'XTick',1:length(results),'FontSize',9); box off; grid on;

%next plot out sensitivity and specificity of the classifier for each left-out subject. 
%useful to spot class imbalance problems
subplot(1,2,2);
for i = 1:length(results) %case structure
    
    line([0 length(results)+1], [0 0], 'LineStyle','--','color','k'); hold on;  line([0 length(results)+1], [1 1], 'LineStyle','--','color','k'); hold on;
    sens = plot(i,results(i).Sensitivity,'.b','MarkerSize',15); hold on;
    spec = plot(i,results(i).Specificity,'.r','MarkerSize',15); hold on;
    
end
box off; xlim([0 length(results)+1]); ylim([-0.1 1.3]);
xlabel('Left out subject','FontSize',14); ylabel('Sensitivity/Specificity','FontSize',14);
set(gca,'XTick', 1:length(results),'FontSize',9); box off; grid on;
legend([sens,spec],{'Sensitivity','Specificity'}); legend boxoff;


end
