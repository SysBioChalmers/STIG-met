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


result = [days milkModel];
result




%%
extendDays = (1:365)';
param = polyfit(dataMilk(7:end,1), dataMilk(7:end,2), 1);
milkModelExtention = param(2) + extendDays*param(1);
plot(extendDays, milkModelExtention, 'b--');
xlim([0 365]);

result = [days milkModel];
result = [result; extendDays(186:end), milkModelExtention(186:end)];
 
for i = 1:length(result)
   fprintf('%i\t%2.2f\n', result(i,1), result(i,2));
end
%%
legend('Data', 'Model', 'Extrapolation', 'location', 'se')