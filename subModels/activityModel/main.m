close all
sleepModelPolly = 2;

timePoints = 0:182;
timePoints = timePoints';

alternativeTime = [6*7 12*7 6*30.2 9*30.2 12*30.2];
alternativeValue = [0.1 0.29 0.5 0.58 0.53];

alternativeTime = alternativeTime(1:3);
alternativeValue = alternativeValue(1:3)/alternativeValue(3);



sleepModelParam = polyfit(alternativeTime, alternativeValue, sleepModelPolly);

sleepModel = zeros(length(timePoints), 1); %;interp1q(weight, realFat, dataMW(:,2));

for i = 1:length(sleepModelParam)
    iPoly = length(sleepModelParam) - i;
    sleepModel = sleepModel + sleepModelParam(i) .* timePoints.^(iPoly);
end
sleepModel(1:(6*7)) = sleepModel(6*7 + 1);
%sleepModel = pchip(chineseData(:,1)*30.2, chineseData(:,2), timePoints)

hold all
plot(alternativeTime, alternativeValue, 'x', 'linewidth', 2);

plot(timePoints, sleepModel,  'k--', 'linewidth', 2);

set(gca,'FontSize',15,'FontName', 'Arial')   

legend('Data', 'Model', 'location', 'nw')
ylim([0 1]);
ylabel('Activity level', 'FontSize',15,'FontName', 'Arial')
xlabel('Day', 'FontSize',15,'FontName', 'Arial')
result = [timePoints sleepModel];


%extrapolation
additionalTimePoints = (183:365)';
result = [result; additionalTimePoints, ones(length(additionalTimePoints),1)];
result