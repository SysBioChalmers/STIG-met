function model = setupModel(model)
% setupModel
% Modifies a model struct to fit human simulation purposes.
% Only allows excreation of Urea (by removing exchange of NH3). Only allows
% excreation of CO2 by removing HCO3. Use concistent reaction directions
% removes duplicate reactions. Adds exchange reactions for free fatty
% acids. 
%   model           A model struct
%   model          	The modifyed model struct
%
%   Avlant Nilsson, 2016-05-16
%

    %turn of NH3 excretion
    model = removeRxns(model, 'HMR_9073', true);
    
    %turn of HCO3 excretion
    model = removeRxns(model, {'HMR_9078', 'HMR_9079'}, true);
    
    compartment = 's';
    
    model = createConsistentReactionDirection(model);
    
    model = removeDuplicateReactions(model);
        
    model = addFatExchange(model, compartment, 'Fat Uptake');
    
    model = removeDuplicateReactions(model);
    
    %exchange rxns
    [exchangeRxns,exchangeRxnsIndexes] = getExchangeRxns(model,'both');
    model.exchangeRxns = exchangeRxnsIndexes;
    
    model = createConsistentReactionDirection(model);    
    
    
    

    
end

