%This function investigates the sensitivity of various parameters used by
%the model
clear

load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

simSettings = configureSimulation(model, 180, 30, false);
foodModel = configureFood(model, 'data/milkModel.txt', 1, 200);



initWeigth = 3346;
initFat = initWeigth * 0.1084;
growthLean = 5.5;
growthFat = 1.6;
maintainLean = 59;
maintainFat = 5;
uptakeFactor = 1-0.07;

perturbFactorUp = 1.001;
perturbFactorDown = 1/perturbFactorUp;

%healthy
i = 1;
individual{1} = createIndividual('Healthy Boy', true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
simulationResults{1} = runSimulation(individual{i}, simSettings, foodModel, referenceState);

testLabels = {
       'Fat Model'
       'Food Model'
       'Activity Model'
       'Lean synthesis'
       'Fat synthesis'
       'Lean maintenance'
       'Fat maintenance'
       'Kcal to ATP convertion'
       'Water Content'
       };

%Input Models

    %Fat Model
        i = 2;
        perturbFactor(i) = perturbFactorUp;
        fatModel2 = perturbFactor(i) * fatModel;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel2);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        
        i = 3;
        perturbFactor(i) = perturbFactorDown;
        fatModel2 = perturbFactor(i) * fatModel;        
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel2);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);


    %Food Model
        i=4;
        perturbFactor(i) = perturbFactorUp;
        foodModel2 = foodModel;
        foodModel2.fluxes = perturbFactor(i) * foodModel.fluxes;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel2, referenceState);

        i=5;
        perturbFactor(i) = perturbFactorDown;
        foodModel2 = foodModel;
        foodModel2.fluxes = perturbFactor(i) * foodModel.fluxes;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel2, referenceState);
        
    %Activity Model
        i=6;
        perturbFactor(i) = perturbFactorUp;
        activityModel2 = perturbFactor(i) * activityModel;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel2, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);

        i=7;
        perturbFactor(i) = perturbFactorDown;
        activityModel2 = perturbFactor(i) * activityModel;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel2, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        
%Individual variation
    %Growth related maintianance Protein
        i=8;
        perturbFactor(i) = perturbFactorUp;
        GRMP = perturbFactor(i) * growthLean;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, GRMP, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        
        i=9;
        perturbFactor(i) = perturbFactorDown;
        GRMP = perturbFactor(i) * growthLean;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, GRMP, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);

    %Growth related maintianance Fat        
        i=10;
        perturbFactor(i) = perturbFactorUp;
        GRMF = perturbFactor(i) * growthFat;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, GRMF, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        
        i=11;
        perturbFactor(i) = perturbFactorDown;
        GRMF = perturbFactor(i) * growthFat;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, GRMF, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);        
    %Lean mass REE
        i=12;
        perturbFactor(i) = perturbFactorUp;
        FFMREE = perturbFactor(i) * maintainLean;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, FFMREE, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        
        i=13;
        perturbFactor(i) = perturbFactorDown;
        FFMREE = perturbFactor(i) * maintainLean;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, FFMREE, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);            
    
    %Fat part of REE
        i=14;
        perturbFactor(i) = perturbFactorUp;
        FMREE = perturbFactor(i) * maintainFat;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, FMREE, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        
        i=15;
        perturbFactor(i) = perturbFactorDown;
        FMREE = perturbFactor(i) * maintainFat;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, FMREE, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);         
    
%Constants
    %ATP conversion factor
        i=16;
        perturbFactor(i) = perturbFactorUp;
        constants = loadConstants();
        constants.ATPConvertionConstant = perturbFactor(i) * constants.ATPConvertionConstant;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
            
        i=17;
        perturbFactor(i) = perturbFactorDown;
        constants = loadConstants();
        constants.ATPConvertionConstant = perturbFactor(i) * constants.ATPConvertionConstant;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
    
    %Protein lean factor
        i=18;
        perturbFactor(i) = perturbFactorUp;
        constants = loadConstants();
        constants.proteinLeanFactor = perturbFactor(i) * constants.proteinLeanFactor;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
            
        i=19;
        perturbFactor(i) = perturbFactorDown;
        constants = loadConstants();
        constants.proteinLeanFactor = perturbFactor(i) * constants.proteinLeanFactor;
        individual{i} = createIndividual(int2str(i), true, 0, initWeigth, initFat, growthLean, growthFat, maintainLean, maintainFat, activityModel, uptakeFactor, fatModel);
        simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel, referenceState);
        constants = loadConstants();
                
        
%plotSettings = configurePlot();
plotSettings = [];



%plotCommand = 'growth|delta|diference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix';
plotCommand = 'growth';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)

timePoints = simulationResults{1}.timePoints;
results = zeros(i, length(timePoints));
for i = 1:length(simulationResults)
    biomassGrowth = sum(simulationResults{i}.deltaValues,2);
    results(i, :) = biomassGrowth;   
end


deltaGrowth = zeros(i-1, length(timePoints));
deltaFactor = zeros(i-1, length(timePoints));
MCA = zeros(i-1, length(timePoints));

for i = 2:length(simulationResults)
    deltaGrowth(i-1, :) = results(i,:)./results(1,:);   
    deltaFactor(i-1, :) = ones(length(timePoints),1) .* perturbFactor(i);
end

%MCA = deltaGrowth./deltaFactor;
MCA = (1-deltaGrowth)./(1-deltaFactor);

for i = 1:2:(size(MCA,1)-1)
   for j=1:size(MCA,2)
       fprintf('\t%f', MCA(i+1,j))
   end

   for j=1:size(MCA,2)
       fprintf('\t%f', MCA(i,j))
   end   
   fprintf('\n')   
end
    
