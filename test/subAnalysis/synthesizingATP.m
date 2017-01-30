%The purpose of this simulation is to analyze how the calorie content of
%breast milk changes over time.

load('../fbaModel/genericHuman2.mat')
addpath('../sourcecode')
addpath('../data')

day = 70;
fat = 0;

%free ATP
maintainanceFunction = 'human_ATPMaintainance';  
model = setParam(model, 'lb', maintainanceFunction, -1000);
model = setParam(model, 'ub', maintainanceFunction, 1000);   

%Remove fat fix reaction
%model = setParam(model, 'ub', 'human_TGPoolFix', 0);
model = setParam(model, 'ub', 'human_TGPool', 0);



%maintainanceFlux = 0;
    
%Configure Food
foodModel = configureFood(model, '../data/milkModel.txt', 1, 200);
influxValues = foodModel.fluxes(day,:)';
reactionNumbers = foodModel.rxnIndx;

objectiveFunction = 'human_biomass';
fatIndex = findIndex(model.rxns, 'human_fatmassTransp');
leanIndex= findIndex(model.rxns, 'human_leanmassTransp');
freeATP = findIndex(model.rxns, maintainanceFunction);

model = configureBiomassEquation(model, objectiveFunction, fat, 0);
approxValue = 1000;

%set up model
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', reactionNumbers, -influxValues);
model = setParam(model, 'ub', reactionNumbers, approxValue);

model = setParam(model, 'obj', objectiveFunction, 1);

model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 1000); 

solution = solveWrapper(model, false, true);

biomass = solution.f
freeATP = solution.x(freeATP)


freeATP/biomass


