function simulationResults = runSimulation(individual, simSettings, foodModel, referenceState)
% runSimulation
% Simulates growth of an infant by solving FBA problems for each day. This
% function sets up the FBA problem with the right parameters and
% iteratively calculates maitainance energy for the next timestep from
% results from the previous (using the fat and lean mass ratio).
%   individual                 A struct containing variables describing the
%                              infant, see "createIndividual"
%   simSettings                A struct with the model and the settings,
%                              see "configureSimulation".
%   foodModel                  The uptake fluxes for each day.
%   referenceState (optional)  A reference state to reload all parameters
%                              from after each time step. For debugging and
%                              to find differences between predictions and
%                              experimental data.
%
%   simulationResults          A struct containing results of the
%                              simulation
%       .timePoints            A list of days (that were simulated).
%       .weight                A list of weights for these days (in gram).
%       .fat                    "---" fat weight.
%       .fluxes                The simulated fluxes (normalized by
%                              dryweight)
%       .dryWeight             The estimated dryweight (in grams)
%       .individual            Pass on the individual struct
%       .energyExpenditure     The calcuated energy expenditure 
%       .foodBonds             Pass the bonds from food model
%       .foodIndex             Pass rxns from food model
%       .deltaValues           The increments of fat and lean mass for each
%                              simulation step
%   Avlant Nilsson, 2016-05-16
%

    %Starting points
    curWeight = individual.weight;
    curFat = individual.fatMass;
    
    %Time steps
    simPoints = getSimPoints(individual, simSettings);
    
    %Allocate memory
    weights = zeros(length(simPoints), 1);
    fat = zeros(length(simPoints),1);
    fluxes = zeros(length(simPoints), length(simSettings.model.rxns));
    dryWeights  = zeros(length(simPoints), 1);
    energyExpenditure = zeros(length(simPoints), 3);
    foodBonds = zeros(length(simPoints), size(foodModel.fluxes, 2));
    deltaValues = zeros(length(simPoints), 2);

    for i = 1:length(simPoints)
        age = simPoints(i);    
        
        if nargin == 4 %If recalibrate against the referenceState
           curFat = 1000 * referenceState.fat(age+1 - simSettings.timeStep, 2);
           curWeight = 1000 * referenceState.weight(age+1 - simSettings.timeStep, 2);
        end
        
        food = foodModel.fluxes(age, :) * individual.foodUptakeFactor; 
        activityExpenditure = individual.activityModel(age);
        maintenance  = estimateMaintenance(curWeight, curFat, individual, activityExpenditure);
        fatRatio = estimateFatRatio(age, individual);
        growthRelMaintenance = estimateGrowthMaintenance(fatRatio, individual);
        
        solution = normalizeAndRunFBA(simSettings.model, foodModel.rxnIndx, food, sum(maintenance), growthRelMaintenance, fatRatio, curFat, curWeight, simSettings.parsimonious, individual.constrainedFluxes);

        
        curFat = curFat + simSettings.timeStep * solution.fatGain;
        curWeight = curWeight + simSettings.timeStep * (solution.fatGain + solution.leanGain);
            
        fat(i) = curFat;
        weights(i) = curWeight;
        fluxes(i,:) = solution.x;
        dryWeights(i) = solution.dryWeight;
        deltaValues(i,:) = [solution.fatGain, solution.leanGain];
        energyExpenditure(i,:) = maintenance;
        foodBonds(i,:) = food;
    end
    
    simulationResults = storeResults(simPoints, weights, fat, fluxes, dryWeights, individual, energyExpenditure, foodBonds, foodModel, deltaValues);
end



function simPoints = getSimPoints(individual, simSettings)
    startPoint = individual.age + simSettings.timeStep;
    endPoint = individual.age + simSettings.length;
    stepSize = simSettings.timeStep;
    simPoints = startPoint:stepSize:endPoint;
end


function simulationResults = storeResults(simPoints, weights, fat, fluxes, dryWeights, individual, energyExpenditure, foodBonds, foodModel, deltaValues)
    simulationResults.timePoints = simPoints;   
    simulationResults.weight = weights;
    simulationResults.fat =  fat;
    simulationResults.fluxes = fluxes;
    simulationResults.dryWeight = dryWeights;
    simulationResults.individual = individual;
    simulationResults.energyExpenditure = energyExpenditure;
    simulationResults.foodBonds = foodBonds;
    simulationResults.foodIndex = foodModel.rxnIndx;
    simulationResults.deltaValues = deltaValues;
end
