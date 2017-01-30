%This functions reproduces supplementary figure X in the paper. The purpose is to
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

%Underweight
initWeigth = 2604;
initFat = initWeigth * 0.1084;

individual{2} = createIndividual('Under weight', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{2} = runSimulation(individual{2}, simSettings, foodModel);

%Overweight
initWeigth = 4215;
initFat = initWeigth * 0.1084;
individual{3} = createIndividual('Over weight', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{3} = runSimulation(individual{3}, simSettings, foodModel);



%plotSettings = configurePlot();
plotSettings = [];



%plotCommand = 'growth|delta|zscore|diference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix|height';
plotCommand = 'growth|fatmass|zscore|height|zheight';
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
