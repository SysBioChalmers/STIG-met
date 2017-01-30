%The purpose of this simulation is to plot the specific growth rate of
%lean, fat and biomass

addpath('../sourceCode')
addpath('../data')
referenceState = makeReferenceObject('../referenceData/state/weightInterpolation.txt', '../referenceData/state/fatInterpolation.txt');
leanMass = referenceState.weight(:,2)-referenceState.fat(:,2);
fatMass = referenceState.fat(:,2);
mass = referenceState.weight(:,2);

timePoints = 1:length(diff(leanMass));
spMass = diff(mass)./mass(timePoints);
spLean = diff(leanMass)./leanMass(timePoints);
spFat = diff(fatMass)./fatMass(timePoints);

diff(leanMass)

close all
clf
hold all
plot(timePoints, spMass, 'linewidth', 3);
plot(timePoints,spLean, 'linewidth', 3);
plot(timePoints, spFat, 'linewidth', 3);
legend('Mass', 'Lean', 'Fat')
ylim([0, 0.04]);
xlim([1, 180]);
xlabel('day', 'FontSize',15,'FontName', 'Arial')
ylabel('kg/kg/day', 'FontSize',15,'FontName', 'Arial')
set(gca,'FontSize',15,'FontName', 'Arial')   
figure
hold all
plot(timePoints, spMass/max(spMass), 'linewidth', 3);
plot(timePoints, spLean/max(spLean), 'linewidth', 3);
plot(timePoints, spFat/max(spFat), 'linewidth', 3);
xlabel('day', 'FontSize',15,'FontName', 'Arial')
ylabel('ratio', 'FontSize',15,'FontName', 'Arial')
legend('Mass', 'Lean', 'Fat')
ylim([0, 1]);
xlim([1, 180]);
set(gca,'FontSize',15,'FontName', 'Arial')   