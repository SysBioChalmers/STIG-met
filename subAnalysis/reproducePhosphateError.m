load('../fbaModel/genericHuman2.mat')
addpath('..')
addpath('../data')
addpath('../sourcecode')

timePoints = round(linspace(0, 180, 30));

%model.ub(ismember(model.subSystems, 'Pool reactions')) = 0;
%model.lb(ismember(model.subSystems, 'Pool reactions')) = 0;

model.ub(findIndex(model.rxns, 'HMR_0686')) = 0;
model.lb(findIndex(model.rxns, 'HMR_0686')) = 0;



approxMilk = 1;
[food foodLabels]= breastMilkData(approxMilk, 60);
foodRxns = getBounds(model, {'Pi[s]', 'O2[s]'});
approxValue = 1000;
influxValues = 1000;

objectiveFunction = 'human_ATPMaintainance';
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', foodRxns, -influxValues);
model = setParam(model, 'ub', foodRxns, approxValue);

model = setParam(model, 'obj', objectiveFunction, 1);

model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 10);    

solution = solveLinMin(model, 1);
%solution = solveLin(model);
values = solution.x(model.exchangeRxns);
    
    
