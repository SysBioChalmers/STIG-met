function result = displayMetabolitesByReactions(model, affectedReactions)
% displayMetabolitesByReactions
% Gives a list of metabolites used by the reactions in the input
%
%   model             a model structure
%   affectedReactions a list of rxn numbers
%   result            the list of metabolite names
%
%   Avlant Nilsson, 2016-05-16
%

   result = [];
    for i = 1:length(affectedReactions)
       currentMet = full(model.S(:, affectedReactions(i)))==1;
       result = [result; model.metNames(currentMet)];
    end
end

