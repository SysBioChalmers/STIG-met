%The purpose of this function is to estimate the kcal/ATP ratio
%Using kcal/g of glucose (4)

load('../fbaModel/genericHuman2.mat')
addpath('..')
addpath('../sourcecode')

labels = {
'glucose[s]'    
'O2[s]'
};

model.foodRxns = getBounds(model, labels);
food = [1000/(180*4) 100];

approxValue = 10;

influxValues = food(model.foodRxns ~= -1);
reactionNumbers = model.foodRxns(model.foodRxns ~= -1);

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
%values(values<-0.00000001)
%model.rxns(model.exchangeRxns(values<-0.000001))


answer = solution.f * -1;

1000/answer 

printFluxesAvlant(model, solution.x)

%%
%The purpose of this function is to estimate the kcal/ATP ratio
%Using kcal/g of fat (9)
labels = {
'palmitate[s]'    
'O2[s]'
};

model.foodRxns = getBounds(model, labels);
food = [1000/(256.4 * 8.8), 10];

approxValue = 1000;

influxValues = food(model.foodRxns ~= -1);
reactionNumbers = model.foodRxns(model.foodRxns ~= -1);

objectiveFunction = 'human_ATPMaintainance';
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', reactionNumbers, -influxValues);
model = setParam(model, 'ub', reactionNumbers, approxValue);

model = setParam(model, 'obj', objectiveFunction, 1);

model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 1000);    

PO = -solution.f/(2*solution.x(reactionNumbers(2)));

solution = solveLP(model, 1);
solution
%    solution = solveLin(model);
values = solution.x(model.exchangeRxns);
%values(values<-0.00000001)
%model.rxns(model.exchangeRxns(values<-0.000001))

answer = solution.f * -1;

1000/answer

printFluxesAvlant(model, solution.x)

%CO2 conversion factor to glucose
%1,34