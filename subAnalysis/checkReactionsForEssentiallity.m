%The purpose of this simulation is to identify reactions essential for
%growth

load('../fbaModel/genericHuman2.mat')
addpath('../sourcecode')
addpath('../data')

objectiveFunction = 'human_biomass';
maintainanceFunction = 'human_ATPMaintainance';  

approxMilk = 0.7;
maintainanceFlux = (6 * 58)/26;
foodModel = configureFood(model, 'data/milkModel.txt', 1, 200, 0);
fluxThreshold = 10^-8;

%Configure Model
influxValues = foodModel.fluxes(60,:);
reactionNumbers = foodModel.rxnIndx;
    
approxValue = 100;
model = configureSMatrix(model, 250, objectiveFunction, 'human_growthMaintainance[c]');
model = setParam(model, 'obj', objectiveFunction, 1);
model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 1000);
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', reactionNumbers, -influxValues);
model = setParam(model, 'ub', reactionNumbers, approxValue);  
model = setParam(model, 'lb', maintainanceFunction, maintainanceFlux);
model = setParam(model, 'ub', maintainanceFunction, 1000);
    
solution = solveLP(model, 1);

normFluxes = solution.x;
normGrowth = -solution.f;

possiblyEssensialReactions = 1:size(model.S,2);
possiblyEssensialReactions(abs(solution.x)<fluxThreshold) = [];


valueLevels = [0 0.5];


results = zeros(length(possiblyEssensialReactions), length(valueLevels));

for i = 1:length(possiblyEssensialReactions)
    for j = 1:length(valueLevels)
        currentRxn = possiblyEssensialReactions(i);
        tempModel = model;
        tempModel.ub(currentRxn) = normFluxes(currentRxn) * valueLevels(j);
        tempModel.lb(currentRxn) = normFluxes(currentRxn) * valueLevels(j);

       % solution = solveLP(model, 1);
         solution = solveLin(tempModel);

        if not(isempty(solution.f))
            FBASolution = -solution.f;
        else
            FBASolution = 0;
        end

        results(i, j) = FBASolution/normGrowth;
    end
end


for i = 1:length(possiblyEssensialReactions)
    currentReaction = possiblyEssensialReactions(i);
    fprintf('%s\t%3.4f\t%3.4f\n', model.rxns{currentReaction}, results(i,1), results(i,2))
end
