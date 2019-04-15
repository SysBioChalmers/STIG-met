%The purpose of this function is to investigate how different weights on
%the fat and lean tissue will result in different biomass composition if
%the ratio of fat and lean mass is free
load('fbaModel/genericHuman2.mat')
addpath('models')


maintainanceFlux = (65/28.2)*5;

maintainanceFlux = 0;

[food, foodLabels]= breastMilkData(1, 1);
model.foodRxns = getBounds(model, foodLabels);

approxValue = 10;

influxValues = food(model.foodRxns ~= -1);
reactionNumbers = model.foodRxns(model.foodRxns ~= -1);

maintainanceFunction = 'human_ATPMaintainance';  
objectiveFunction = {'human_leanmass' 'human_fatmass'};
objectiveReactions = getIndexFromText(model.rxns, objectiveFunction);


model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', reactionNumbers, -influxValues);
model = setParam(model, 'ub', reactionNumbers, approxValue);
model = setParam(model, 'lb', maintainanceFunction, maintainanceFlux);
model = setParam(model, 'ub', maintainanceFunction, 1000);   
model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 1000);   

fatPriority = -0.3:0.05:0.7;

fatPriority = -3:3;
results = zeros(length(fatPriority), 2);
for i = 1:length(fatPriority)
    priorityFunction = [1 10.^fatPriority(i)];
    model = setParam(model, 'obj', objectiveFunction, priorityFunction);
    solution = solveLP(model, 1);
    %solution = solveLin(model);
    results(i,:) = solution.x(objectiveReactions);
    
end
 
clf
hold all
plot(fatPriority, results, 'x-', 'linewidth', 2)
plot(fatPriority, sum(results,2), '--', 'linewidth', 2)

legend('Protein', 'fat', 'sum dw')
xlabel('log10(priority fat)')
ylabel('g/1 Liter milk')
ylim([0 max(sum(results,2))*1.1]);


