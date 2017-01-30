%The purpose of this study is to investigate the effect on growth of an
%occilating food source. 

load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt', 'referenceData/zScoreBoy.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

%constrainedFluxes = makeFluxconstrainObject(model, 'data/cofactorModel/none.txt', 1);

individual{1} = createIndividual('Healthy Boy', true, 0, 3346, 0.1084*3346, 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel);

simSettings = configureSimulation(model, 180, 1, false);

foodModel = configureFood(model, 'data/milkModel.txt', 1, 180, 0);

amplitude = 0.5;
nrOfOcilations = 5; 
timePoints = linspace(0,2*pi,180);


modulator = 1 - 0.3*sin(nrOfOcilations*timePoints);
foodModel1 = foodModel;
foodModel1.fluxes = foodModel.fluxes .* repmat(modulator', 1, size(foodModel.fluxes, 2));

modulator = 1 - 0.5*sin(nrOfOcilations*timePoints);
foodModel2 = foodModel;
foodModel2.fluxes = foodModel.fluxes .* repmat(modulator', 1, size(foodModel.fluxes, 2));


%plotSettings = configurePlot();
plotSettings = [];

simulationResults =[];
simulationResults{1} = runSimulation(individual{1}, simSettings, foodModel1);
simulationResults{2} = runSimulation(individual{1}, simSettings, foodModel2);


%plotCommand = 'growth|delta|zscore|diference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix';
plotCommand = 'growth|delta|zscore|fatmass';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)