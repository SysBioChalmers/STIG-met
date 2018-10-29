function solution = solveLin(model, silent)
%solveLin
%   This function sets up the FBA problem to feed to the MOSEK solver. It
%   is more or less a rip of from RAVEN solveLP, but with less
%   functionality for speed.
%
%   model           a model struct
%   silent          boolean, if true then no displayed output 
%   solution        struct with solution
%          .x       fluxes, length(x) = 1 if infeasible solution 
%          .f       value of objective function
%
%   Avlant Nilsson, 2016-05-16
%

    if nargin < 2
        silent = false;
    end

    % Setup the problem to feed to MOSEK.
    prob=[];
    prob.c = model.c*-1;
    prob.a = model.S;
    prob.blc = model.b(:,1);
    %If model.b has two column, then they are for lower/upper bound on the RHS
    prob.buc = model.b(:,min(size(model.b,2),2));
    prob.blx = model.lb;
    prob.bux = model.ub;

    params.MSK_IPAR_OPTIMIZER='MSK_OPTIMIZER_FREE_SIMPLEX';
    %[crap,res] = mosekopt('minimize echo(0)',prob,getMILPParams(params));
    [crap,res] = mosekopt('minimize echo(0)',prob, params);    

    if not(silent)
        disp(res.sol.bas)
    end

    
    if (strcmp(res.sol.bas.prosta, 'PRIMAL_AND_DUAL_FEASIBLE'))
    %Construct the output structure
        if isfield(res.sol,'bas')
            solution.x = res.sol.bas.xx;
            solution.f = res.sol.bas.pobjval;
        else
            disp('MOSEK error')
        end
    else
        solution.x = 0;
        solution.f = 0;
    end
end