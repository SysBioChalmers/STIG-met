function solution = normalizeAndRunFBA(model, rxnIndx, food, maintenance, growthRelatedMaintenance, fatRatio, curFat, curWeight, parsimonious, constrainedFluxes)
% normalizeAndRunFBA
% Sets up the problem for FBA to solve. Normalizes the problem to per kg 
% dryweight. Runs "runFBA" and then transforms the solution back. Also does
% the conversions from kcal/kg to ATP/kg. 
%   model                       A model struct
%   rxnIndx                     A list of exchange reaction indexes
%   food                        A list of bounds for the exchange rxns
%   maintenance                 Maintainance expenditure in kcal 
%   growthRelatedMaintenance    Energy expenditure per g newformed tissue
%                               with the composition given by the fat ratio
%   fatRatio                    The dryweight adjusted fat ratio
%   curFat                      Current weight of fat (in gram)
%   curWeight                   Current weight (in gram)
%   parsimonious                Boolean, should the problem be solved using
%                               pFBA?
%   constrainedFluxes           An object with fluxes to be constrained
%                               e.g. for cofactor simulations.
%   solution                    Struct containing
%            .x                 FBA fluxes
%            .leanGain          Increase in fatfree mass
%            .fatGain           Increase in fat mass
%            .dryWeight         The dryweight normalization value used
%   Avlant Nilsson, 2016-05-16
%
global constants
    if nargin < 10
        constrainedFluxes.level = 1;
    end

    maintenance = maintenance/constants.ATPConvertionConstant; %From kcal to mol ATP
    growthRelatedMaintenance = 1000 * growthRelatedMaintenance/constants.ATPConvertionConstant; %From kcal/g To molATP/kg
        
    %normalize by dry weight
    dryWeight = curFat + (curWeight - curFat)/constants.proteinLeanFactor;
    dryWeight = dryWeight/1000;
    food = food/dryWeight;
    maintenance = maintenance/dryWeight; %from mol ATP to ATP/kgdw.
    FBASolution = runFBA(model, rxnIndx, food, maintenance, growthRelatedMaintenance, fatRatio, parsimonious, constrainedFluxes);
        
    fatGain = dryWeight * FBASolution.fatGrowth * 1000;
    leanGain = dryWeight * FBASolution.leanGrowth * constants.proteinLeanFactor * 1000;
    solution.x = FBASolution.x;
    solution.leanGain = leanGain;
    solution.fatGain = fatGain;
    solution.dryWeight = dryWeight;
end

