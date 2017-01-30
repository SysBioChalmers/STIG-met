%The purpose of this simulation is to approximate the specific milk uptake
%and compare it to maintainance to realize that growth is simply higher
%specific milk intake.
addpath('../sourceCode')
addpath('../data')
clf

approxKcalMilk = 650; %kcal/l
approxMaintainance = 60 + 15; %kcal
fractionUptake = 0.93;
approxMilkMaintainance = approxMaintainance/approxKcalMilk;

referenceState = makeReferenceObject('../referenceData/state/weightInterpolation.txt', '../referenceData/state/fatInterpolation.txt');
milkModel = makeMilkModel('../data/milkModel.txt', 1)/1000;
leanMass = referenceState.weight(:,2) - referenceState.fat(:,2);
timePoints = 1:180;
specificMilkUptake = fractionUptake*milkModel(timePoints)./leanMass(timePoints);
hold all
plot(timePoints, specificMilkUptake, 'linewidth', 3);
plot([timePoints(1) timePoints(end)], [approxMilkMaintainance approxMilkMaintainance], 'k--', 'linewidth', 3);

xlabel('day', 'FontSize',15,'FontName', 'Arial')
ylabel('l/kg leanmass', 'FontSize',15,'FontName', 'Arial')
legend('Milk uptake', 'Maintainance')
set(gca,'FontSize',15,'FontName', 'Arial')   
xlim([timePoints(1) timePoints(end)])