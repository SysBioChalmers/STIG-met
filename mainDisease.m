%This functions reproduces figure 3 in the paper. The purpose is to
%investiate the effect on growth from perturbations to the system.

load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt', 'referenceData/zScoreBoy.txt', 'referenceData/heightBoy.txt', 'referenceData/zScoreBoyHeight.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

simSettings = configureSimulation(model, 180, 1, false);
foodModel = configureFood(model, 'data/milkModel.txt', 1, 200);


initWeigth = 3346;
initFat = initWeigth * 0.1084;
growthLean = 5.5;
growthFat = 1.6;
maintainLean = 59;
maintainFat = 5;
uptakeFactor = 1-0.07;

%healthy
individual{1} = createIndividual('Healthy', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{1} = runSimulation(individual{1}, simSettings, foodModel);

%Extreme energy spender e.g. underweight 
individual{2} = createIndividual('Energy spender', true, 0, initWeigth, initFat, growthLean, growthFat, 1.3 * maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{2} = runSimulation(individual{2}, simSettings, foodModel);

%Starvation period
foodModel2 = foodModel;
foodModel2.fluxes(40:80,:) = 0.5 * foodModel2.fluxes(40:80,:);
individual{3} = createIndividual('Starvation', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{3} = runSimulation(individual{3}, simSettings, foodModel2);

%Over fed
foodModel3 = foodModel;
foodModel3.fluxes = 1.1 * foodModel3.fluxes;
individual{4} = createIndividual('Over fed', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{4} = runSimulation(individual{4}, simSettings, foodModel3);

%Under fed
foodModel4 = foodModel;
foodModel4.fluxes = 0.9 * foodModel4.fluxes;
individual{5} = createIndividual('Under fed', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{5} = runSimulation(individual{5}, simSettings, foodModel4);

%Over Active
individual{6} = createIndividual('Over active', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, 2 * activityModel, uptakeFactor, fatModel);
simulationResults{6} = runSimulation(individual{6}, simSettings, foodModel);


%plotSettings = configurePlot();
plotSettings = [];



%plotCommand = 'growth|delta|zscore|diference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix|height';
plotCommand = 'growth|zscore|fatmass|height|zheight';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)

allLegends =[];
leanGrowth = zeros(length(simulationResults), length(simulationResults{1}.timePoints));
for i = 1:length(simulationResults)
    leanGrowth(i,:) = simulationResults{i}.weight - simulationResults{i}.fat;
    allLegends{i} = simulationResults{i}.individual.name;
end
figure()
plot(simulationResults{1}.timePoints, leanGrowth)
legend(allLegends)
