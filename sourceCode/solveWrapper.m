function solution = solveWrapper(model, verbose, parsimonious)
% solveWrapper
% Removes duplicates of exchange reactions.
%
%   model                       a model struct
%   verbose                     Print messages from solver
%   parsimonious                Boolean use pFBA?
%   solution                    Result from FBA simulation
%           .f                  The value of the objective function
%           .x                  The fluxes if length of .x is 1 then no
%                               solution was found
%
%   Avlant Nilsson, 2016-05-17
%    
    if parsimonious
        solution = solveLinMin(model, verbose);
    else
        solution = solveLin(model, verbose);
    end   
end