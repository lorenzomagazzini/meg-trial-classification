function svm_model = svm_train (train_data, train_labels, varargin)
% Basic classification function using LibLinear implementation, trains a linear SVM and returns trained svm model.
%
% Inputs: training data(trials x features), training labels. 
% Optional: svm parameters and desired optional performance metrics.
%
% Name-value pairs: 
% 'solver', default 1: L2-regularized dual problem solver (LibLinear);
% 'boxconstraint', default 1
% 'standardize', default true (recommended; based on training set)
% 'weights', default false (output vector of activation patterns associated with classifier weights, cf. Haufe et al. 2014)
%
% Outputs svm model.
% Optional (as above): weight-derived patterns. (Raw weights are always output in svm_model.w)
%
% DC Dima 2018 (diana.dima@gmail.com)

%parse inputs
svm_par = svm_args; %define an object containing default parameters
list = fieldnames(svm_par); 
p = inputParser; 
for ii = 1:length(properties(svm_args)) %create a list of parameters to parse, plus their defaults
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
parse(p, varargin{:}); %check the name-value pairs in input and overwrite defaults where needed
svm_par = p.Results;
clear p;

if abs(nargin)<2 %at least 2 arguments needed
    error('Data and labels are needed as inputs.')
end;

%scale values using range and minimum of training set
if svm_par.standardize
    train_data = (train_data - repmat(min(train_data, [], 1), size(train_data, 1), 1)) ./ repmat(max(train_data, [], 1) - min(train_data, [], 1), size(train_data, 1), 1);
    
end;

%train classifier using parameters provided
svm_model = train(train_labels, sparse(train_data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));

%calculate weights and compute activation patterns as per Haufe et al. (2014)
if svm_par.weights
    svm_model.WeightPatterns = abs(cov(train_data)*results.Weights'/cov(train_data*results.Weights'));
    svm_model.WeightPatternsNorm = (results.WeightPatterns-min(results.WeightPatterns))/(max(results.WeightPatterns)-min(results.WeightPatterns)); %normalized weights
end;

end