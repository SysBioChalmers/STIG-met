clear all
%this function reproduces figure 4 in the paper. It investigates the effect
%on growth of flux constraints on reactions that require the specified 
%cofactors

load('fbaModel/genericHuman2.mat')
addpath('sourceCode')
addpath('data')
global constants
constants = loadConstants();

fluxConstraint = 1-0.05; % 5 percent flux reduction

referenceData = makeReferenceObject('referenceData/weightBoy.txt', 'referenceData/multiCenterData.txt', 'referenceData/zScoreBoy.txt');
referenceState = makeReferenceObject('referenceData/state/weightInterpolation.txt', 'referenceData/state/fatInterpolation.txt');
fatModel  = makeFatModel('data/fatModel.txt', 1);
activityModel = makeActivityModel('data/activityModel.txt', 14.4);

cofactorFile = {
    'fe'
    'cu'
    'mg'
    'zinc'
    };

startLimitationSimulation = 5;
simulationLength = 180;

foodModel = configureFood(model, 'data/milkModel.txt', 1, 180);

individual{1} = createIndividual('Healthy Boy', true, 0, 3346, 0.1084*3346, 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel);


simSettings = configureSimulation(model, simulationLength, 1, false);
simulationResults{1} = runSimulation(individual{1}, simSettings, foodModel);

for i = 1:length(cofactorFile)
    fileName =  sprintf('data/cofactorModel/%s.txt', cofactorFile{i});
    constrainedFluxes = makeFluxconstrainObject(model, fileName, fluxConstraint);
    individual{1+i} = createIndividual(cofactorFile{i}, true, startLimitationSimulation, simulationResults{1}.weight(startLimitationSimulation), simulationResults{1}.fat(startLimitationSimulation), 5.5, 1.6, 59, 5, activityModel, (1-0.07), fatModel, constrainedFluxes);
end


foodModel = configureFood(model, 'data/milkModel.txt', 1, 200);
%plotSettings = configurePlot();
plotSettings = [];

for i = 2:length(individual)
    simSettings = configureSimulation(model, simulationLength-startLimitationSimulation, 1, false);
    simulationResults{i} = runSimulation(individual{i}, simSettings, foodModel);
end

%plotCommand = 'growth|delta|diference|fatmass|gas|energy|xFluxes|subsystems|intFluxes|foodUtilization|nitrogen|fatfix';
plotCommand = 'growth|zscore|delta';
plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)

%%
figure
hold all
%Reference data
childData = referenceData.weight;
time = childData(:,1)/30.4;
childData = 1000 * childData(:,2:end);
scaledData = childData./childData(:,3);

greyColor = [0.5 0.5 0.5];
%greyColor2 = [0.6 0.6 0.6];

%xvals = [time; flip(time)];
%yvals = [scaledData(:, 1); flip(scaledData(:, 5))];
%fill(xvals, yvals, greyColor, 'edgecolor','none', 'FaceAlpha', 0.3, 'HandleVisibility','off')

yvals = [scaledData(:, 2); flip(scaledData(:, 4))];
fill(xvals, yvals, greyColor, 'edgecolor','none', 'FaceAlpha', 0.3, 'HandleVisibility','off')

orderOfPlot = 1+[4 2 1 3];
referenceWeight = simulationResults{1}.weight(startLimitationSimulation:simulationLength);
plot([0 simulationLength], [1 1], 'k-', 'linewidth', 3)

for i = 1:4
     disp(simulationResults{orderOfPlot(i)}.weight(end))
     timepoints = startLimitationSimulation;
     timepoints = [timepoints simulationResults{orderOfPlot(i)}.timePoints];
     weights = simulationResults{2}.individual.weight;
     weights = [weights; simulationResults{orderOfPlot(i)}.weight];
     plot(timepoints/30.4, weights./referenceWeight, 'linewidth', 3)
end

legendContent = ['Healthy';cofactorFile(orderOfPlot-1)];

legend(legendContent, 'location', 'sw')
xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial')
ylabel('Relative weight', 'FontSize',15,'FontName', 'Arial')
ylim([0.85 1])
xlim([0 6])
set(gca,'FontSize',15,'FontName', 'Arial')   





