%The purpose of this function is to calculate the maintainance energy from
%the specific maintainance expenditure of the major organs and the lean and
%fat mass. We find that for the first 6 months this value is a constant if
%expressed in Energy/lean mass. 

close all
%Kidney liver heart brain FFM FM
metabolicRate = [440 200 440 240 13 5];

dataMW = load('maleWeight.txt'); 
dataLiver = load('liver50.txt');
dataKidney = load('kidney50.txt');
dataHeart = load('heart50.txt');
dataBrain = load('headModel.txt');
dataFat = load('fatRatio.txt');

timepoints = 1:340;
timepoints = timepoints';

weight = interp1q(dataMW(:,1), dataMW(:,2), timepoints);
liver = interp1q(dataLiver(:,1), dataLiver(:,2), timepoints)/1000;
kidney = interp1q(dataKidney(:,1), dataKidney(:,2), timepoints)/1000;
heart = interp1q(dataHeart(:,1), dataHeart(:,2), timepoints)/1000;
brain = interp1q(dataBrain(:,1), dataBrain(:,2), timepoints);
residualFM =  interp1q(dataFat(:,1), dataFat(:,2), timepoints);
%Approximate fatmass beond 6 months
residualFM(isnan(residualFM))= weight(isnan(residualFM))*0.26;

dataValues = [kidney liver heart brain];


residuals = weight - sum(dataValues,2);
totalFFM = weight - residualFM;
residualFFM = totalFFM - sum(dataValues,2);

dataValues = [dataValues residualFFM residualFM];


energyExpenditure = repmat(metabolicRate, length(timepoints), 1) .* dataValues;

hold all
plot(timepoints, sum(energyExpenditure,2), '-', 'linewidth', 3)

plot(timepoints, energyExpenditure, '-', 'linewidth', 3)

xlabel('Day', 'FontSize',15,'FontName', 'Arial');
ylabel('Kcal', 'FontSize',15,'FontName', 'Arial')
legend('Total', 'Heart', 'Liver', 'Kidney', 'Brain', 'FFM', 'FM', 'location','nw');


figure()
result = sum(energyExpenditure,2)./weight;
plot(timepoints, result, '-', 'linewidth', 3)
%plot(timepoints, median(result)*ones(length(timepoints),1), '--', 'linewidth', 3)

xlabel('Day', 'FontSize',15,'FontName', 'Arial');
ylabel('Kcal/kg', 'FontSize',15,'FontName', 'Arial')

%plot(time, result./(median(result).*ones(length(time),1)), '--')

hold all
for i = 1:size(energyExpenditure, 2)
    plot(timepoints, energyExpenditure(:,i)./weight, 'linewidth', 2);
end
legend('Total', 'Heart', 'Liver', 'Kidney', 'Brain', 'FFM', 'FM', 'location','se');

figure()
hold all
result =  sum(energyExpenditure,2)./totalFFM;
meanResult = mean(result)
plot(timepoints, result, '-', 'linewidth', 3)
plot(timepoints, meanResult*ones(length(timepoints),1), 'k--', 'linewidth', 3)

for i = 1:size(energyExpenditure, 2)
    plot(timepoints, energyExpenditure(:,i)./totalFFM, 'linewidth', 2);
end
legend('total', 'mean', 'heart','Liver', 'Kidney', 'Brain', 'FFM', 'FM', 'location','se');
xlabel('Day', 'FontSize',15,'FontName', 'Arial');
ylabel('Kcal/kg', 'FontSize',15,'FontName', 'Arial')

figure()
hold all
result =  (sum(energyExpenditure,2) - energyExpenditure(:,end))./totalFFM;
meanResult = mean(result)

plot(timepoints, result, '-', 'linewidth', 3)
plot(timepoints, meanResult*ones(length(timepoints),1), 'k--', 'linewidth', 3)
plot(timepoints, energyExpenditure(:,end)./totalFFM, '-', 'linewidth', 3)

ylim([0 70])

legend('Total - FM', 'mean', 'FM', 'location','se');
xlabel('Day', 'FontSize',15,'FontName', 'Arial');
ylabel('Kcal/kg lean mass', 'FontSize',15,'FontName', 'Arial')

figure()
hold all
errorVal = 100*(result/meanResult - 1);
plot(timepoints, errorVal, '-', 'linewidth', 3)


xlabel('Day', 'FontSize',15,'FontName', 'Arial');
ylabel('Error %', 'FontSize',15,'FontName', 'Arial')

