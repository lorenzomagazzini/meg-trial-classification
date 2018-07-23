%Class definition file for classification arguments.
%Defines an object svm_args including classifier and cross-validation options:
%          solver (classifier type) and kernel
%          box constraint
%          number of folds and number of cross-validation iterations
%          feature standardization and weights
%
% DC Dima 2018 (diana.dima@gmail.com)

classdef svm_args
    
    properties (Access = public)
        
        %here are the defaults
        solver = 1; %as implemented in LibLinear: 1: L2 dual-problem; 2: L2 primal; 3:L2RL1L...
        boxconstraint = 1; %specify C parameter
        kfold = 5; %number of folds
        cv_indices = []; %this allows cross-validation indices to be pre-specified, rather than create random partitions. Not currently used.
        iterate_cv = 1; %number of cross-validation iterations (default:1)
        standardize = true; %standardize features (based on training set)
        weights = false; %get SVM weights (by retraining classifier over whole dataset)
        kernel = 0; %this is only used in libSVM: 0: linear; 1: polynomial; 2:radial basis function; 3:sigmoid. Not currently used.
       
    end
    
    methods
        
        function obj = svm_args(varargin)
            
            if ~isempty(varargin)
                obj.solver = varargin{1};
                obj.boxconstraint = varargin{2};
                obj.kfold = varargin{3};
                obj.cv_indices = varargin{4};
                obj.iterate_cv = varargin{5};
                obj.standardize = varargin{6};
                obj.weights = varargin{7};
                obj.kernel = varargin{8};
            end
        end
                
    end
    
end