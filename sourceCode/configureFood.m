function foodModel = configureFood(model, modelFile, startPoint, endPoint)
% configureFood
% Sets upp the dayly bonds to the exchange reactions using literature data
%
%   model             a model structure
%   modelFile         a string with the name to the file containing the
%                     daily intake of milk in kg/day
%   startPoint        age of infant in days at start of simulation
%   endPoint          age of infant in days at end of simulation
%   foodModel         a structure
%   foodModel.rxnIndx The index of the exchange rxns in model
%   foodModel.fluxes  A matrix with the bounds to the exchange fluxes
%                     of each metabolite and day
%   foodModel.labels  The names of the metabolites
%   Avlant Nilsson, 2016-05-16
%
global constants

    timePoints = startPoint:endPoint;
    
    %Get the amount of milk per day
    milkModel = makeMilkModel(modelFile, 1);
    
    %Get the names of the metabolites and the coresponding rxns
    [food, foodLabels] = breastMilkData(1, 1, 's');
    foodRxns = getBounds(model, foodLabels);

    foodModelFlux = zeros(length(timePoints), length(foodRxns));

    %Get the exchange fluxes for each day
    for i = 1:length(timePoints)
        age = timePoints(i);
        estimatedMilkAmount = milkModel(age)/1000; %ml -> l
        %L - > kg
        estimatedMilkAmount = estimatedMilkAmount*constants.milkDensity;
        [food, foodLabels] = breastMilkData(estimatedMilkAmount, age);
        foodModelFlux(i,:) = food;
    end
        
    %Remove metabolites that do not match the exchange rxns in the model
    foodModel.rxnIndx = foodRxns(foodRxns ~= -1);
    foodModel.fluxes = foodModelFlux(:,foodRxns ~= -1);
    foodModel.labels = foodLabels(foodRxns ~= -1);
end

