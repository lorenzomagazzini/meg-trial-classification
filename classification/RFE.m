function [ data, idx ] = RFE(data, labels, num_features, varargin )
%Runs SVM recursive feature elimination.
%Uses whole dataset for training and pre-specified number of features to keep.
%To get number of features in data-driven way, run associated RFE_CV code.
%Outputs 'pruned' dataset and index containing number of feature eliminated at each round.
%Note - LibLinear has to be on path.

if abs(nargin)<2 
    error('Data and labels are needed as inputs.')
end;

%use SVM object to initialize parameters
svm_par = svm_args;
list = fieldnames(svm_par);
p = inputParser;
for ii = 1:length(properties(svm_args))
    addParameter(p, list{ii}, svm_par.(list{ii}));
end;
parse(p, varargin{:});
svm_par = p.Results;
clear p;

num_elim = size(data,2) - num_features; %get number of features to eliminate
idx = nan(num_elim,1); %initialize index of eliminated features
idx_feat = 1:size(data,2); %feature counter

for f = 1:num_elim %in each loop iteration, the weakest weighted feature is removed
    
    %scale values using range and minimum
    if svm_par.standardize
        kdata = data;
        data = (kdata - repmat(min(kdata, [], 1), size(kdata, 1), 1)) ./ repmat(max(kdata, [], 1) - min(kdata, [], 1), size(kdata, 1), 1);
    end;     
    svm_model = train(labels, sparse(data), sprintf('-s %d -c %d -q 1', svm_par.solver, svm_par.boxconstraint)); %dual-problem L2 solver with C=1
    abs_w = abs(svm_model.w);
    elim_idx = find(abs_w==min(abs_w),1); %%find the minimal absolute weight
    data(:,elim_idx) = []; %remove feature from data
    idx(f) = idx_feat(elim_idx); %track eliminated features
    idx_feat(elim_idx) = []; %update feature counter
    
end;


end

