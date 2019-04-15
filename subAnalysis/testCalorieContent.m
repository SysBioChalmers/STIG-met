load('../fbaModel/genericHuman2.mat')
addpath('..')
addpath('../data')
addpath('../sourcecode')


weight = 3600/1000;

timePoints = round(linspace(0, 180, 30));

results = zeros(length(timePoints),1);
for i = 1:length(timePoints)
    approxMilk = 1;
    [food foodLabels]= breastMilkData(approxMilk, timePoints(i));
    foodRxns = getBounds(model, foodLabels);
    approxValue = 100;

    influxValues = food(foodRxns ~= -1);
    reactionNumbers = foodRxns(foodRxns ~= -1);

    objectiveFunction = 'human_ATPMaintainance';
    model = setParam(model, 'lb', model.exchangeRxns, 0);
    model = setParam(model, 'ub', model.exchangeRxns, approxValue);
    model = setParam(model, 'lb', reactionNumbers, -influxValues);
    model = setParam(model, 'ub', reactionNumbers, approxValue);

    model = setParam(model, 'obj', objectiveFunction, 1);

    model = setParam(model, 'lb', objectiveFunction, 0);
    model = setParam(model, 'ub', objectiveFunction, 1000);    

    %solution = solveLP(model, 1);
    solution = solveLP(model);
    values = solution.x(model.exchangeRxns);
    
    
    results(i) = solution.f * -1;
end
clf
hold all

plot(timePoints, results(:,1) * 26.72, 'o--')

hold off

