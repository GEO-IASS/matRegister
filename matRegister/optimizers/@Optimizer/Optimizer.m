classdef Optimizer < handle
%OPTIMIZER General interface for single-valued function optimizers
%
%   This abstract class is used to define the general contract of
%   optimization algorithms. All implementations of Optimizer abstraction
%   should implement the "startOptimization" method, with two syntaxes:
%   * PARAMS = OPTIM.startOptimization
%   * [PARAMS, VALUE] = OPTIM.startOptimization
%
%   It would be nice to also support following syntax:
%   * PARAMS = OPTIM.startOptimization(PARAMS0)
%
%   The Optimizer class implements a list of listeners. 
%   Example of use:
%     fun = @rosenbrock;
%     t0 = [0 0]; deltas = [.01 .01];
%     optimizer = NelderMeadSimplexOptimizer(fun, [0 0], [.01 .01]);
%     listener = OptimizedValueEvolutionDisplay(gca);
%     addOptimizationListener(optimizer, listener);
%     [xOpt value] = optimizer.startOptimization();
%     
%
%   See also
%   optimizers, NelderMeadSimplexOptimizer, MultiLinearSearchOptimizer, 
%   GaussianLinearSearchOptimizer, GradientDescentOptimizer, 
%   BoundedMultiLinearOptimizer, MatlabSimplexOptimizer, MatlabFminuncWrapper
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2010-10-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

properties
    % the function to minimize
    costFunction;
    
    % the initial set of parameters
    initialParameters = [];
    
    % the current set of parameters
    params;

    % the current value
    value; 
    
    % Some scaling of the parameters for homogeneization
    % (parameters will be divided by corresponding scale)
    parameterScales = [];
    
    % the function that will be called at each iteration
    % (the use of Optimization Events is more convenient)
    outputFunction = [];
    
    % Specifies which information will be displayed at each iteration
    % Can be one of:
    % 'iter'    display information at each iteration
    % 'final'   display only message of convergence
    % 'notify'  display message if convergence failed
    % 'off'     does not display anything
    displayMode = 'notify';
end

%% Events
events
    % notified when the optimization starts
    OptimizationStarted
    
    % notified when the an iteration is run
    OptimizationIterated
    
    % notified when the optimization finishes
    OptimizationTerminated
end

%% Constructor
methods (Access = protected)
    function this = Optimizer(costFun, params0, varargin)
        % Initialize a new Optimizer
        %
        % Usage (in sub-class constructor):
        % this = this@Optimizer();
        % this = this@Optimizer(FUN, PARAMS);
        % FUN is either a function handle, or an instance of CostFunction
        % PARAMS is the initial set of parameters
        %
        % See Also
        % setCostFunction, setInitialParameters
        
        if nargin == 0
            return;
        end
        
        setCostFunction(this, costFun);
        setInitialParameters(this, params0);
        setParameters(this, params0);
        
    end 
        
end % Constructors

%% Abstract methods
methods (Abstract)
    varargout = startOptimization(varargin)
    %STARTOPTIMIZATION Start the optimizer and iterate until an end condition is reached
end

%% General methods
methods
    function params = getInitialParameters(this)
        params = this.initialParameters;
    end
    
    function setInitialParameters(this, params0)
        this.initialParameters = params0;
    end
    
    function params = getParameters(this)
        params = this.params;
    end
    
    function setParameters(this, params)
        this.params = params;
    end
    
    function scales = getParameterScales(this)
        scales = this.parameterScales;
    end
    
    function setParameterScales(this, scales)
        this.parameterScales = scales;
    end
    
    function fun = getCostFunction(this)
        fun = this.costFunction;
    end
    
    function setCostFunction(this, fun)
        % Set up the cost function.
        %
        % Usage
        % OPTIM.setCostFunction(FUN);
        % setCostFunction(OPTIM, FUN);
        % 
        % The input FUN can be either a function handle, or an instance of
        % CostFunction.
        
        if isa(fun, 'function_handle')
            this.costFunction = fun;
        elseif isa(fun, 'CostFunction')
            this.costFunction = @fun.evaluate;
        end
    end
    
    function fun = getOutputFunction(this)
        fun = this.outputFunction;
    end
    
    function setOutputFunction(this, fun)
        this.outputFunction = fun;
    end
    
    function mode = getDisplayMode(this)
        mode = this.displayMode;
    end
    
    function setDisplayMode(this, mode)
        this.displayMode = mode;
    end
    
end % general methods

%% Listeners management
methods
    function addOptimizationListener(this, listener)
        %Adds an OptimizationListener to this optimizer
        %
        % usage: 
        %   addOptimizationListener(OPTIM, LISTENER);
        %   OPTIM is an instance of Optimizer
        %   LISTENER is an instance of OptimizationListener
        %   The listener will listen the events of type:
        %    OptimizationStarted, 
        %    OptimizationIterated,
        %    OptimizationTerminated 
        
        % Check class of input
        if ~isa(listener, 'OptimizationListener')
            error('Input argument should be an instance of OptimizationListener');
        end
        
        % link function handles to events
        this.addlistener('OptimizationStarted', @listener.optimizationStarted);
        this.addlistener('OptimizationIterated', @listener.optimizationIterated);
        this.addlistener('OptimizationTerminated', @listener.optimizationTerminated);
        
    end
end

end % classdef
