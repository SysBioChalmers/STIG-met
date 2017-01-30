fatModelPolly = 3;

dataMW = load('maleWeight.txt');
dataMW = dataMW(1:185,:);
dataFat = load('multiCenterData.txt');
dataTime = dataFat(:,1);
dataFat = dataFat(:,2:end);
dataFat = dataFat/1000;

allWeight = dataMW(:,2);


weight = dataFat(:,1);
realFat = dataFat(:,2);
realDeviation = dataFat(:,3);
fatPercent = realFat./weight;
fatPercentDiv = realDeviation./weight;

fatModelParam = polyfit(weight, realFat, fatModelPolly);

fatModel = zeros(length(dataMW(:,2)), 1); %;interp1q(weight, realFat, dataMW(:,2));

for i = 1:length(fatModelParam)
    iPoly = length(fatModelParam) - i;
    fatModel = fatModel + fatModelParam(i) * dataMW(:,2).^(iPoly);
end
    
close all
figure()
hold all
errorbar(weight, realFat, realDeviation, 'ro', 'linewidth', 2);
plot(dataMW(:,2), fatModel, 'k--', 'linewidth', 2);

legend('Data', 'Model', 'location', 'se')

xlabel('Weight (kg)')
ylabel('Fat (kg)')

figure()
hold all
plot(dataTime*30.2, fatPercent, 'ro', 'linewidth', 2);
plot(dataTime*30.2, [fatPercent + fatPercentDiv, fatPercent - fatPercentDiv], 'rx', 'linewidth', 2);
plot(dataMW(:,1), fatModel./dataMW(:,2),  'linewidth', 2);
ylim([0 0.4])
deltaFat = diff(fatModel);
deltaWeight = diff(allWeight);

figure()
plot(deltaFat)

figure()
deltaFM = deltaFat./deltaWeight;
deltaLM = 1- deltaFM;
deltaW = deltaLM * 0.8;
deltaP = 1 - deltaFM - deltaW;
plot(dataMW(2:end,1), [deltaW+deltaP, deltaFM], 'linewidth', 3)
legend('leanmass', 'fat', 'location', 'se');
weightPercentModel = deltaFat./deltaWeight;
ylim([0 1])
xlabel('Day')
ylabel('Ratio in tissue formed')

result = [dataMW(2:end,1) weightPercentModel];

%Extrapolation:
extraDays = (185:365)';
result = [result; extraDays, weightPercentModel(end) * ones(length(extraDays), 1)];
result

%[dataMW(:,1) dataMW(:,2)]  
%[dataMW(:,1) fatModel]  
%[dataMW(:,1) fatModel]  




