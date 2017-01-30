function [rank, improvment, absoluteValue, listOfAA] = importanceRank(model, day)

maintainanceFunction = 'human_ATPMaintainance';  


foodModel = configureFood(model, 'data/milkModel.txt', 1, 200, 0);

maintainanceFlux = 0;

%Configure Model
influxValues = foodModel.fluxes(day,:);
reactionNumbers = foodModel.rxnIndx;
foodLabels = foodModel.labels;

vMax = 100;

model = setParam(model, 'obj', 'human_biomass', 1);
model = setParam(model, 'lb', 'human_biomass', 0);
model = setParam(model, 'ub', 'human_biomass', vMax);
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, vMax);
model = setParam(model, 'lb', reactionNumbers, -influxValues);
model = setParam(model, 'ub', reactionNumbers, vMax);
model = setParam(model, 'lb', maintainanceFunction, maintainanceFlux);


model = configureSMatrix(model, 150, 'human_biomass', 'human_growthMaintainance[c]');
model = configureSMatrix(model, 0, 'human_biomass', 'human_TGPool[c]');
model = configureSMatrix(model, 0, 'human_biomass', 'cholesterol[c]');

listOfAA = {
    'phenylalanine[s]'
    'valine[s]'
    'tryptophan[s]'
    'threonine[s]'
    'isoleucine[s]'
    'methionine[s]'
    'histidine[s]'
    'leucine[s]'
    'lysine[s]'
%psuedoEssensialAA
    'arginine[s]'
    'cystine[s]'
    'proline[s]'
    'serine[s]'
    'tyrosine[s]'
%nonEssensialAA
    'alanine[s]'
    'asparagine[s]'
    'aspartate[s]'
    'glutamate[s]'
    'glycine[s]'   
};

testSpace = [];

for i = 1:length(listOfAA)
    testSpace = [testSpace ismember(foodLabels, listOfAA{i})];
end


rank = zeros(size(testSpace,2), 1);
improvment = zeros(size(testSpace,2), 1);
absoluteValue = zeros(size(testSpace,2), 1);

solution = solveLinMin(model, 1);

baseLine = -solution.f

increaseFactor = 10;

tests = 1:size(testSpace,2);
i = 1;
while isempty(tests) == false
    results = zeros(length(tests), 1);
    for j = 1:length(tests)
        tmpModel{j} = model;        
        curTest = tests(j);
        affectedReactions = reactionNumbers(testSpace(:,curTest) == 1);
        bonds = tmpModel{j}.lb(affectedReactions) * increaseFactor;
        tmpModel{j} = setParam(tmpModel{j}, 'lb', affectedReactions, bonds);
        solution = solveLin(tmpModel{j}, 1);
        results(j) = -solution.f;
    end
    results/baseLine
    [maxValue bestIndx] = max(results);
    model = tmpModel{bestIndx};

    limitingIndx = tests(bestIndx);
    
    rank(limitingIndx) = i;
    improvment(limitingIndx) = maxValue/baseLine;
    absoluteValue(limitingIndx) = maxValue;
    tests(tests == limitingIndx) = [];
    i = i + 1;
    baseLine = maxValue;
end
end

