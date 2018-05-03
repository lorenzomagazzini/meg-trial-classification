function svm_model = svm_train (train_data, train_labels, varargin)
% Inputs: training data(trials x features), training labels. 
% Optional: svm parameters and desired optional performance metrics.
%
% Name-value pairs: 
% 'solver', default 1: L2-regularized dual problem solver (LibLinear);
% 'boxconstraint', default 1
% 'standardize', default true (recommended; across training set)
% 'weights', default false (output vector of activation patterns associated with classifier weights, cf. Haufe 2014)
%
% Outputs svm model.
% Optional (as above): weight-derived patterns. (Raw weights are always output in svm_model.w)
% Basic function using LibLinear implementation, trains a linear SVM and returns trained svm model.

%parse inputs
svm_par = svm_args;
list = fieldnames(svm_par);
p = inputParser;
for ii = 1:length(properties(svm_args))
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
parse(p, varargin{:});
svm_par = p.Results;
clear p;

if abs(nargin)<2
    error('Data and labels are needed as inputs.')
end;

%scale values using range and minimum of training set
if svm_par.standardize
    train_data = (train_data - repmat(min(train_data, [], 1), size(train_data, 1), 1)) ./ repmat(max(train_data, [], 1) - min(train_data, [], 1), size(train_data, 1), 1);
    
end;

svm_model = train(train_labels, sparse(train_data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint));


%calculate weights and compute activation patterns as per Haufe (2014)
if svm_par.weights
    svm_model.WeightPatterns = abs(cov(train_data)*results.Weights'/cov(train_data*results.Weights'));
    svm_model.WeightPatternsNorm = (results.WeightPatterns-min(results.WeightPatterns))/(max(results.WeightPatterns)-min(results.WeightPatterns));
end;

end