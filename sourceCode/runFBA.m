function FBASolution = runFBA(model, rxnIndx, metabolitesIn, maintenance, growthRelMaintenance, fatRatio, parsimonious, constrainedFluxes)
% runFBA
%  set up the FBA problem and solve the linear problem. If no solution
%  allow free uptake of the fat tissue reaction and minimize this. If 
%  constrainedFluxes is set run additional simulations constraining the 
%  fluxes specified in this struct
%
%   model                        a model struct
%   rxnIndx                      A list of exchange reaction indexes
%   metabolitesIn                A list of bounds for the exchange rxns
%   maintenance                  Maintainance expenditure in mol ATP/kg dry
%                                weight
%   growthRelMaintenance         Energy expenditure per g newformed tissue
%                                with the composition given by the fat ratio
%   fatRatio                     The dryweight adjusted fat ratio
%   parsimonious                 Boolean, should the problem be solved using
%                                pFBA?
%   constrainedFluxes            An object with fluxes to be constrained
%                                e.g. for cofactor simulations.
%   FBASolution                  a struct with the output
%        .x                      the fluxes
%        .fatGrowth              growth of fat mass (may be negative)
%        .leanGrowth             growth of lean mass (>=0)
%        .biomass                growth in biomass (lean+fat)
%        .catabolism             boolean is fatGrowth negative
%   Avlant Nilsson, 2016-05-17
%    
    if nargin < 8
        constrainedFluxes.level = 1;
    end
    
    catabolism = 0;
    objectiveFunction = 'human_biomass';
    maintainanceFunction = 'human_ATPMaintainance';  
    catbolismFunction = 'human_fatmassExport';
    catabolismSource = 'human_TGPool';
    
    fatIndex = findIndex(model.rxns, 'human_fatmass');
    leanIndex= findIndex(model.rxns, 'human_leanmass');
    
    
    model = configureBiomassEquation(model, objectiveFunction, fatRatio, growthRelMaintenance);
    approxValue = 1000;
    
    %set up model
    model = setParam(model, 'lb', model.exchangeRxns, 0);
    model = setParam(model, 'ub', model.exchangeRxns, approxValue);
    model = setParam(model, 'lb', rxnIndx, -metabolitesIn);
    model = setParam(model, 'ub', rxnIndx, approxValue);

    model = setParam(model, 'obj', objectiveFunction, 1);
    
    model = setParam(model, 'lb', objectiveFunction, 0);
    model = setParam(model, 'ub', objectiveFunction, 1000);
    
    model = setParam(model, 'lb', maintainanceFunction, maintenance);
    model = setParam(model, 'ub', maintainanceFunction, 1000);    
    
    solution = solveWrapper(model, false, parsimonious);
    
    
    if length(solution.x) > 1
        FBASolution = formateResult(solution, catabolism, fatIndex, leanIndex);   
    else
        %Try burning fat instead
        model = setupCatabolism(model, catbolismFunction, catabolismSource);
        solution = solveWrapper(model, false, parsimonious);
        catabolism = 1;
        FBASolution = formateResult(solution, catabolism, fatIndex, leanIndex);       
    end
    
    if constrainedFluxes.level<1
        model = setupBottleneck(model, solution, constrainedFluxes);
        solution = solveWrapper(model, false, parsimonious);
        if length(solution.x) <= 1
            model = setupCatabolism(model, catbolismFunction, catabolismSource);
            solution = solveWrapper(model, false, parsimonious);
            catabolism = 1;
        end
        
        FBASolution = formateResult(solution, catabolism, fatIndex, leanIndex);
    end
end


function model = setupCatabolism(model, catbolismFunction, catabolismSource)
    model = setParam(model, 'obj', catbolismFunction, 1);
    model = setParam(model, 'lb', catbolismFunction, -1000);
    model = setParam(model, 'ub', catbolismFunction, 0); 
    model = setParam(model, 'lb', catabolismSource, -1000);
end
    

function model = setupBottleneck(model, solution, constrainedFluxes)
    %guarantee same objective solution
    cofactorReactions = constrainedFluxes.rxns;
    
    %this assumes that there is only one flux in the objective function
    objectiveFunctionVal = solution.x(model.c~=0) * model.c(model.c~=0);
    tmpModel = model;
    tmpModel = setParam(tmpModel, 'lb', tmpModel.c ~= 0, objectiveFunctionVal);
    tmpModel = setParam(tmpModel, 'ub', tmpModel.c ~= 0, objectiveFunctionVal); 
    minimalSolution = minimizeFluxThroughReactions(tmpModel, cofactorReactions);
    
    level = constrainedFluxes.level;
    normFluxes = level .* minimalSolution(cofactorReactions);
    lowerBound = normFluxes .* (normFluxes<0);
    upperBound = normFluxes .* (normFluxes>0);
    
    model = setParam(model, 'lb', cofactorReactions, lowerBound);
    model = setParam(model, 'ub', cofactorReactions, upperBound); 
end
    
    


function FBASolution = formateResult(solution, catabolism, fatIndex, leanIndex)
    solution
    if length(solution.x)>1
        FBASolution.x = solution.x;
        FBASolution.fatGrowth =  solution.x(fatIndex);
        FBASolution.leanGrowth =  solution.x(leanIndex);
        %FBASolution.biomass = -solution.f;
        FBASolution.biomass = solution.x(fatIndex) + solution.x(leanIndex);
        FBASolution.catabolism = catabolism;
        
    else
        fprintf('\nWarning! No solution found, returing 0\n');
        FBASolution.x = 0;
        FBASolution.fatGrowth =  0;
        FBASolution.leanGrowth =  0;
        FBASolution.biomass = 0;
        FBASolution.catabolism = catabolism;        
    end
end