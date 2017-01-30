%This function generates the results in figure 1 in the paper it
%establishes the norm by which to compare other simulations. 

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

individual{1} = createIndividual('Healthy Boy', true, 0, 3346, 0.1084*3346, 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel);

simSettings = configureSimulation(model, 180, 1, parsimonious);

%

milkAge = 30;
    timePoints = 1:180;
    
    %Get the amount of milk per day
    milkModel = makeMilkModel('data/milkModel.txt', 1);
    
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
        [food, foodLabels] = breastMilkData(estimatedMilkAmount, milkAge);
        foodModelFlux(i,:) = food;
    end
        
    %Remove metabolites that do not match the exchange rxns in the model
    foodModel.rxnIndx = foodRxns(foodRxns ~= -1);
    foodModel.fluxes = foodModelFlux(:,foodRxns ~= -1);
    foodModel.labels = foodLabels(foodRxns ~= -1);


%plotSettings = configurePlot();
plotSettings = [];

simulationResults =[];
simulationResults{1} = runSimulation(individual{1}, simSettings, foodModel);


%plotCommand = 'growth|delta|zscore|difference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix|height|zheight';
plotCommand = 'growth|fatmass|zscore|height|zheight';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)

