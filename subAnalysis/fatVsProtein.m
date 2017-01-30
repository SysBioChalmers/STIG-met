%Optimization of fat and lean tissue. The purpose is to determine if
%protein or fat are limiting growth or if it is energy
load('../fbaModel/genericHuman2.mat')
addpath('../sourcecode')
addpath('../data')
global constants
constants = loadConstants;

referenceData = makeReferenceObject('../referenceData/weightBoy.txt', '../referenceData/multiCenterData.txt');
constrainedFluxes = makeFluxconstrainObject(model, '../data/cofactorModel/none.txt', 1);

approxMilk = 0.7;
maintainanceFlux = 0;
    
timePoints = 30 * linspace(0, 6, 30);



result = zeros(length(timePoints), 3);
reference = zeros(length(timePoints),3);
residualValues = zeros(length(timePoints), 3);


%Configure Food
foodModel = configureFood(model, '../data/milkModel.txt', 1, 200);
influxValues = foodModel.fluxes;
reactionNumbers = foodModel.rxnIndx;


for i = 1:length(timePoints)
    day = timePoints(i);
    currentInflux = influxValues(round(day+1),:)';
    solution = normalizeAndRunFBA(model, reactionNumbers, currentInflux, maintainanceFlux, 1, 1, 1000, 1000, true, constrainedFluxes);        
    result(i, 1) = solution.fatGain;
    residuals = currentInflux - (-solution.x(reactionNumbers));    
    residualValues(i, 1) = sum(residuals(7:(end-3)))/sum(influxValues(7:(end-3)));
    
    solution = normalizeAndRunFBA(model, reactionNumbers, currentInflux, maintainanceFlux, 1, 1, 1000, 1000, true, constrainedFluxes);        
    result(i, 2) = solution.leanGain;
    residuals = currentInflux - (-solution.x(reactionNumbers));  
    residualValues(i, 2) = sum(residuals(7:(end-3)))/sum(currentInflux(7:(end-3)));
    
    solution = normalizeAndRunFBA(model, reactionNumbers, currentInflux, maintainanceFlux, 1, 1, 1000, 1000, true, constrainedFluxes);        
    result(i, 3) = solution.leanGain + solution.fatGain;
    residuals = currentInflux - (-solution.x(reactionNumbers));  
    residualValues(i, 3) = sum(residuals(7:(end-3)))/sum(currentInflux(7:(end-3)));    
end

%GenerateReferenceData
for i = 1:length(timePoints)
    day = timePoints(i);
    reference(i, 1) = sum(breastMilkFA(approxMilk, day));
    reference(i, 2) = sum(breastMilkAA(approxMilk, day));
    reference(i, 3) = sum(breastMilkAA(approxMilk, day))+sum(breastMilkAA(approxMilk, day));
end

timeWeights = zeros(length(timePoints),1);
for i = 1:length(timePoints)
    day = round(timePoints(i) + 1);
    timeWeights(i) = referenceData.weight(day + 11 , 4) - referenceData.weight(day, 4);
    timeWeights(i) = timeWeights(i)/10;
end
timeWeights = timeWeights./max(timeWeights);

close all
clf
hold all
%result = result./max(max(result));
referenceNormalized = reference./sum(influxValues(day, 7:(end-3)));

plot(timePoints, result(:,1)./max(result(:,1)), 'b-', 'linewidth', 3)
plot(timePoints, referenceNormalized(:,1), 'r--', 'linewidth', 3)
plot(timePoints, residualValues(:,1), 'gv', 'linewidth', 2)
ylim([0 1.1])
legend('Growth Fat', 'Mol Fatty acid in milk', 'Residuals', 'location', 'ne')
xlabel('Days', 'FontSize',15,'FontName', 'Arial')
ylabel('Growth', 'FontSize',15,'FontName', 'Arial')
set(gca,'FontSize',15,'FontName', 'Arial')
figure()
clf
hold all
plot(timePoints, result(:,2)./max(result(:,2)), 'b-', 'linewidth', 3)
plot(timePoints, referenceNormalized(:,2), 'r--', 'linewidth', 3)
plot(timePoints, residualValues(:,2), 'gv', 'linewidth', 2)
ylim([0 1.1])
legend('Growth Lean', 'Mol amino acid in milk', 'Residuals', 'location', 'ne')
xlabel('Days', 'FontSize',15,'FontName', 'Arial')
ylabel('Growth', 'FontSize',15,'FontName', 'Arial')
set(gca,'FontSize',15,'FontName', 'Arial')
figure()
clf
hold all
plot(timePoints, result(:,3)./max(result(:,3)), 'b-', 'linewidth', 3)
plot(timePoints, timeWeights, 'kx--', 'linewidth', 1)
plot(timePoints, referenceNormalized(:,3), 'r--', 'linewidth', 3)
plot(timePoints, residualValues(:,3), 'gv', 'linewidth', 2)
ylim([0 1.1])
legend('Growth Biomass', 'Experimental', 'Mol amino and fatty acid in milk', 'Residuals', 'location', 'ne')
set(gca,'FontSize',15,'FontName', 'Arial')
xlabel('Days', 'FontSize',15,'FontName', 'Arial')
ylabel('Growth', 'FontSize',15,'FontName', 'Arial')
hold off

