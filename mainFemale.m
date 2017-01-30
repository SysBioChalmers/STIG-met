%This is the same as the function "main" but with female data.
load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

referenceData = makeReferenceObject('referenceData/weightFemale.txt', 'referenceData/multiCenterDataFemale.txt', 'referenceData/zScoreFemale.txt', 'referenceData/heightFemale.txt', 'referenceData/zScoreFemaleHeight.txt');
fatModel  = makeFatModel('data/fatModelFemale.txt', 1);
%fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

individual{1} = createIndividual('Healthy Female', false, 0, 3232, 0.13 * 3232, 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel);


simSettings = configureSimulation(model, 180, 1, false);
foodModel = configureFood(model, 'data/milkModel.txt', 1, 200);
foodModel.fluxes = 0.93 * foodModel.fluxes;
%plotSettings = configurePlot();
plotSettings = [];

simulationResults =[];
simulationResults{1} = runSimulation(individual{1}, simSettings, foodModel);


%plotCommand = 'growth|delta|diference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix';
plotCommand = 'growth|fatmass|zscore|height|zheight';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)