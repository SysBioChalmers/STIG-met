%This functions reproduces supplementary figure X in the paper. The purpose is to
%investiate the effect on growth from perturbations to the system.


load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();
parsimonious = false;

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt', 'referenceData/zScoreBoy.txt', 'referenceData/heightBoy.txt', 'referenceData/zScoreBoyHeight.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

%constrainedFluxes = makeFluxconstrainObject(model, 'data/cofactorModel/none.txt', 1);

individual{1} = createIndividual('Healthy Boy', true, 1, 3346, 0.1084*3346, 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel);

simSettings = configureSimulation(model, 364, 1, parsimonious);
foodModel = configureFood(model, 'data/milkModel.txt', 1, 365);
%plotSettings = configurePlot();
plotSettings = [];

simulationResults =[];
simulationResults{1} = runSimulation(individual{1}, simSettings, foodModel);


%plotCommand = 'growth|delta|zscore|difference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix|height|zheight';
plotCommand = 'growth|fatmass|zscore|height|zheight';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)

