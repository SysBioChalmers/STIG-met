days = (1:185)';
dataMilk = load('metaStudy.txt');

realMilk = dataMilk(:,2);
realDeviation = dataMilk(:,3);


milkModel = pchip(dataMilk(:,1), dataMilk(:,2), days);
    
close all
hold all
errorbar(dataMilk(:,1), realMilk, realDeviation, 'ro', 'linewidth', 2);
plot(days, milkModel, 'k--', 'linewidth', 2);
xlabel('Day')
ylabel('Ml Milk')
ylim([0 1000]);
xlim([0 200]);
legend('Data', 'Model', 'location', 'se')

result = [days milkModel];
result




