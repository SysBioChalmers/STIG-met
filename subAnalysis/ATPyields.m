clc
%Test the anaerobic ATP yield on glucose

load('../fbaModel/genericHuman2.mat')
addpath('..')
addpath('../sourcecode')
    
labels = {
'glucose[Extracellular]'    
};

approxValue = 1000;
influxValues = 1;
reactionNumbers = getBounds(model, labels);

objectiveFunction = 'human_ATPMaintainance';
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', reactionNumbers, -influxValues);
model = setParam(model, 'ub', reactionNumbers, approxValue);

model = setParam(model, 'obj', objectiveFunction, 1);

model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 1000);    

solution = solveLP(model, 1);
solution
%    solution = solveLin(model);
values = solution.x(model.exchangeRxns);

printFluxesAvlant(model, solution.x, true)
