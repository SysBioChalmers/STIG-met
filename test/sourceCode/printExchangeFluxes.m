function printExchangeFluxes(model, growthRates, fullSolution)
% printExchangeFluxes
% Prints the fluxes for each reaction together with the
% name of the subsystem and the equation of the reaction.
%
%   model               a model struct
%   growthRates         the timepoints to print
%   fullSolution        a matrix with fluxes for each timepoint
%
%   Avlant Nilsson, 2016-05-17
%
for i=1:length(model.rxns)
   if sum(abs(fullSolution(:,i))) > fluxThresh
       eq = constructEquations(model, i);
       fprintf('%s\t%s\t%s', model.rxns{i}, model.subSystems{i}, eq{1})
       for j = 1:length(growthRates)
            fprintf('\t%f', fullSolution(j,i)/growthRates(j));
       end
       fprintf('\n');
   end
end
end

