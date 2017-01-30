function simpleModel()
%simpleModel
%The purpose of this simulation is to show that growth decreases with time
%due to mass (and thereby maintainance expenditure) increasing faster than 
%the milk intake and thereby less and less energy becomes available for 
%growth.

addpath('data')
childData = load('../referenceData/weightBoy.txt');
milkModel = makeMilkModel('../data/milkModel.txt', 1);

timeSteps = 1:200; %days

%energyExpenditureFatFree = 100; %maintainance kcal/kg
%energyExpenditureFat = 4.5; %maintainance kcal/kg
%fatContent = [0.25 0 0.5]; %arbitary estimates
%energyExpenditure = (1-fatContent) * energyExpenditureFatFree  + fatContent * energyExpenditureFat; 
energyExpenditure =53;
intakeFactor = [1 0.85 1.2];

results = zeros(length(timeSteps),1);
yield = 0.56;
massConversionFactor = 1/7.5; 
dryweightToWetWeightFactor = 1/(1-0.62);

results(1, 1) = childData(1, 4)*1000;
results(1, 2) = childData(1, 2)*1000;
results(1, 3) = childData(1, 6)*1000;

resultsData = zeros(length(timeSteps),3);
for i = 2:length(timeSteps)
    calorieContentMilk = getApproximateCalorieContent(timeSteps(i));
    milkIntake = milkModel(timeSteps(i))/1000;
    inputPerDay = intakeFactor * (1-0.077) * milkIntake * calorieContentMilk; %assuming 7% loss in uptake
    
    currentWeight = results(i-1, :);
    energyExp = currentWeight./1000 .* energyExpenditure;
    netEnergy = inputPerDay - energyExp;
    energyForMass = netEnergy * yield;
    weightGainDW = energyForMass .* massConversionFactor;
    weightGain = weightGainDW * dryweightToWetWeightFactor;
    
    results(i, :) = currentWeight + weightGain;    
end

for i = 1:length(timeSteps)
    resultsData(i, 1) = childData(timeSteps(i)+1, 4) * 1000;
    resultsData(i, 2) = childData(timeSteps(i)+1, 2) * 1000;
    resultsData(i, 3) = childData(timeSteps(i)+1, 6) * 1000;
end

clf
hold all
plot(timeSteps, results, '--', 'linewidth', 2)
plot(timeSteps, resultsData, 'linewidth', 2)

ylim([0 11000])
legend('Model 50 percentile', 'Model 5 percentile', 'Model 95 percentile', 'Data 50 percentile', 'Data 5 percentile', 'Data 95 percentile', 'location', 'southeast')
xlabel('Day')
ylabel('Weight [g]')
hold off


%Simple model implyes the following ATP maintainance:
toMass = yield;
toEnergy = 1-yield;
totalMass = toMass * massConversionFactor * 0.001; %kg
totalATP = toEnergy/28.1250;
(totalATP/totalMass)

1/totalMass
end


function result = getApproximateCalorieContent(day)
calorie = [
  596.7074
  620.1945
  675.0089
  702.5231
  699.1511
  695.7811
  692.4323
  689.0803
  685.1653
  681.6217
  677.5542
  673.5446
  669.5324
  664.8481
  660.8301
  656.7922
  652.7351
  647.9994
  643.9383
  639.8753
  635.7347
  631.5568
  628.2679
  627.8933
  627.5186
  627.0369
  626.5338
  625.9471
  625.4443
  624.9417];
  
timePoints = [
     0
     6
    12
    19
    25
    31
    37
    43
    50
    56
    62
    68
    74
    81
    87
    93
    99
   106
   112
   118
   124
   130
   137
   143
   149
   155
   161
   168
   174
   180];

if max(timePoints) < day
    result = calorie(end);
else
    result= interp1q(timePoints, calorie, day);
end
end


function result = getCumulativeEnergyIntake(startingDay, endingDay)
timeInterval = startingDay:endingDay;
result = 0;
for i=1:length(timeInterval)
    day = timeInterval(i);
    calorieContentMilk = getApproximateCalorieContent(day);
    milkIntake = getMilkIntake(day)/1000;
    result = result +  milkIntake * calorieContentMilk;   
end

end


