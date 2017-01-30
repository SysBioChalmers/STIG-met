%This function reproduces figure 2A from the paper. The purpose is to
%investigate if protein, fat or energy is limiting growth. This is done by
%assuming that energy is not limiting (so setting the energy expenditure to
%0) and comparing the predicted growth of fat and lean mass to the observed. 

load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = 0 * makeActivityModel('data/activityModel.txt', 14.4);

%constrainedFluxes = makeFluxconstrainObject(model, 'data/cofactorModel/none.txt', 1);

simSettings = configureSimulation(model, 180, 1, false);
foodModel = configureFood(model, 'data/milkModel.txt', 1, 200);
%plotSettings = configurePlot();
plotSettings = [];


%Pure Protein
fatModel = zeros(200,1);
individual{1} = createIndividual('Protein', true, 0, 3346, 0.1084*3346, 5.5, 1.62, 0, 0, activityModel, (1-0.07), fatModel);

%Pure fat no maintainance
fatModel = ones(200,1);
activityModel = zeros(200,1);
individual{2} = createIndividual('Fat No maintenance', true, 0, 3346, 0.1084*3346, 5.5, 1.62, 0, 0, activityModel, (1-0.07), fatModel);

for i = 1:2
    simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel);
end



time = referenceState.weight(:,1)/30.4;
time(end) = [];

deltaWeight = 1000 * diff(referenceState.weight(:,2));
deltaFat = 1000 * diff(referenceState.fat(:,2));
deltaLean = deltaWeight-deltaFat;

timePoints = simulationResults{1}.timePoints;

resultWeight = zeros(length(timePoints),5 );
resultFat = zeros(length(timePoints),5);
resultLean = zeros(length(timePoints),5);

for i = 1:length(simulationResults)
    modelDeltaComponents = simulationResults{i}.deltaValues;
    resultWeight(:,i) = sum(modelDeltaComponents,2)';
    resultFat(:,i) = modelDeltaComponents(:,1);
    resultLean(:,i) = modelDeltaComponents(:,2);
end

percentDiffLean = resultLean(:,1)./deltaLean(timePoints);
mean(percentDiffLean)
percentDiffFat = resultFat(:,2)./deltaFat(timePoints);
mean(percentDiffFat)

clf
hold all
plot(time, deltaLean, 'b', 'linewidth', 3)
plot(timePoints/30.4, resultLean(:,1),'b--', 'linewidth', 3)

plot(time, deltaFat, 'k', 'linewidth', 3)
plot(timePoints/30.4, resultFat(:,2),'k--', 'linewidth', 3)

ylim([0 70])
xlim([0 6]);
xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
ylabel('Growth [g/day]', 'FontSize',15,'FontName', 'Arial');
legend('Lean reference', 'Lean optimum', 'Fat reference', 'Fat optimum', 'location', 'ne');
set(gca,'FontSize',15,'FontName', 'Arial') 
hold off


