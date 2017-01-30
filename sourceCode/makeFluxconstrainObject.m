function constrainObject = makeFluxconstrainObject(model, fileName, factor)
% makeFluxconstrainObject
% Load a cell array of rxns that should be constrained (e.g. because they
% share a cofactor) the con
%
%   model              a model struct
%   fileName           a file containing the names of the affected
%                      reactions
%   factor             the amount to constrain these reactions with (value
%                      between 0 and 1, where 0.95 means constrain to 95%).
%   Avlant Nilsson, 2016-05-16
%
    reactionString = importdata(fileName);
    cofactorReactions = getIndexFromText(model.rxns, reactionString);
    constrainObject.rxns = cofactorReactions;
    constrainObject.level = factor;  
end

