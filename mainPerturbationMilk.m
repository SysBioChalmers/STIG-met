%The purpose of this simulation is to investigate the sensitivity of growth
%to changes in the uptake fluxes. Corresponding to table S1
clear all
load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

individual{1} = createIndividual('Healthy Boy', true, 0, 3346, 0.1084*3346, 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel);

simSettings = configureSimulation(model, 180, 30, false);
foodModel = configureFood(model, 'data/milkModel.txt', 1, 200);
%plotSettings = configurePlot();
plotSettings = [];

simulationResults =[];

deltaUp = 2;
deltaDown = 1/2;
%deltaUp = 1.001;
%deltaDown = 1/deltaUp;




for i = 1:size(foodModel.fluxes,2);
    tmpModel = foodModel;
    tmpModel.fluxes(:,i) = foodModel.fluxes(:,i) * deltaUp;
    simulationResults{i} = runSimulation(individual{1}, simSettings, tmpModel, referenceState);
end

for i = 1:size(foodModel.fluxes,2);
    tmpModel = foodModel;
    tmpModel.fluxes(:,i) = foodModel.fluxes(:,i) * deltaDown;
    simulationResults{i+length(foodModel.fluxes)} = runSimulation(individual{1}, simSettings, tmpModel, referenceState);
end

%Elasticity
referenceValues = sum(simulationResults{1}.deltaValues,2);
for i = 1:size(foodModel.fluxes,2)
   fprintf('%s', tmpModel.labels{i})    
   relativeGrowthDown = sum(simulationResults{i+length(foodModel.fluxes)}.deltaValues,2)./referenceValues;
   elasticity = (1-relativeGrowthDown)./(1-deltaDown);
   for j=1:length(relativeGrowthDown)
       fprintf('\t%f', elasticity(j))
   end      
    
   relativeGrowthUp = sum(simulationResults{i}.deltaValues,2)./referenceValues;
   elasticity = (1-relativeGrowthUp)./(1-deltaUp);

   for j=1:length(relativeGrowthUp)
       fprintf('\t%f', elasticity(j))
   end
   fprintf('\n')       
end

%Percent
for i = 1:size(foodModel.fluxes,2)
   fprintf('%s', tmpModel.labels{i})    
   relativeGrowthDown = sum(simulationResults{i+length(foodModel.fluxes)}.deltaValues,2)./referenceValues;
   percentChange = 100*(relativeGrowthDown);
   for j=1:length(relativeGrowthDown)
       fprintf('\t%2.2f%%', percentChange(j))
   end      
   relativeGrowthUp = sum(simulationResults{i}.deltaValues,2)./referenceValues;
   percentChange = 100*(relativeGrowthUp);
   for j=1:length(relativeGrowthUp)
       fprintf('\t%2.2f%%', percentChange(j))
   end   
   fprintf('\n')      
end




