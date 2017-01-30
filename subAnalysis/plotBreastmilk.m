%The purpose is to plot the modeled content of breastmilk over time

timePoints = 1:180;
[AAContent labels] = breastMilkAA(1, 1);
AAContent = zeros(length(timePoints), length(AAContent));
for i = 1:length(timePoints)
    AAContent(i,:) = breastMilkAA(1, timePoints(i));
end

plot(timePoints, 1000*AAContent, 'linewidth', 2)
xlabel('days', 'FontSize',15,'FontName', 'Arial')
ylabel('mMol/l', 'FontSize',15,'FontName', 'Arial')
legend(labels)

set(gca,'FontSize',15,'FontName', 'Arial')

%%

timePoints = 1:180;
AAContent = breastMilkAA(1, 1);
FAContent = breastMilkFA(1, 1);
CAContent = breastMilkCarbs(1, 1);

AAContent = zeros(length(timePoints), length(AAContent));
FAContent = zeros(length(timePoints), length(FAContent));
CAContent = zeros(length(timePoints), length(CAContent));

for i = 1:length(timePoints)
    AAContent(i,:) = breastMilkAA(1, timePoints(i));
    FAContent(i,:) = breastMilkFA(1, timePoints(i));
    CAContent(i,:) = breastMilkCarbs(1, timePoints(i));
end
totalAA = sum(AAContent,2);
%totalAA = totalAA/max(totalAA);
totalFA = sum(FAContent,2);
%totalFA = totalFA/max(totalFA);
totalCA = sum(CAContent,2);
%totalCA = totalCA/max(totalCA);
clf
hold all
plot(timePoints, totalAA, 'linewidth', 3)
plot(timePoints, totalFA, 'linewidth', 3)
plot(timePoints, totalCA, 'linewidth', 3)

xlabel('days', 'FontSize',15,'FontName', 'Arial')
ylabel('mMol/l', 'FontSize',15,'FontName', 'Arial')
legend('Protein', 'Fat', 'Carbs')

set(gca,'FontSize',15,'FontName', 'Arial')