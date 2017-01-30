function model = removeDuplicateReactions(model)
% removeDuplicateReactions
% Removes duplicates of exchange reactions.
%   model               a model struct
%   model               the modifyed model struct
%
%   Avlant Nilsson, 2016-05-17
%    
    [exchangeReactionNames, exchangeRxnsIndexes] = getExchangeRxns(model,'both');
    
    tempS = sign(abs(model.S(:, exchangeRxnsIndexes)));
    control = sum(tempS,2);
    affectedMetabolites = find(control>1);
    removeList = zeros(length(affectedMetabolites), 1);
    
    for i = 1:length(affectedMetabolites)
        allReactions = find(tempS(affectedMetabolites(i), :));
        removeList(i) = allReactions(1);
        
    end
    
    
    listOfReactions = exchangeRxnsIndexes(removeList);
    
    model = removeRxns(model, listOfReactions);
    
end

