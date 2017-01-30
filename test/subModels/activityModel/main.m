%The purpose of this function is to make a model of activity that gives a
%low value for newborn and a higher value for older infants. Here we use
%the degree of awakeness as a proxy.

close all
sleepModelPolly = 2;

data = load('data.txt');
data(:,2) = 1- data(:,2)/24;

timePoints = 0:180;
timePoints = timePoints';


sleepModelParam = polyfit(data(:,1)*30.2, data(:,2), sleepModelPolly);

sleepModel = zeros(length(timePoints), 1); %;interp1q(weight, realFat, dataMW(:,2));

for i = 1:length(sleepModelParam)
    iPoly = length(sleepModelParam) - i;
    sleepModel = sleepModel + sleepModelParam(i) .* timePoints.^(iPoly);
end
%sleepModel = pchip(chineseData(:,1)*30.2, chineseData(:,2), timePoints)

hold all
plot(data(:,1)*30.2, data(:,2), 'ro', 'linewidth', 2);

plot(timePoints, sleepModel,  'k--', 'linewidth', 2);
sleepModel2 = (sleepModel-min(sleepModel))/(max(sleepModel-min(sleepModel)));
plot(timePoints, sleepModel2,  'linewidth', 2);

legend('Data', 'Model', 'Factor', 'location', 'nw')
ylim([0 1]);
ylabel('Time awake (% of day)')
xlabel('Day')



[timePoints sleepModel2]