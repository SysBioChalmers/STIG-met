%The purpose of this function is to establish an empirical relation between
%length and lean mass

close all
%http://ajcn.nutrition.org/content/77/3/726.full
leanMale = load('multiCenterData.txt');
leanFemale = load('multiCenterDataFemale.txt');

leanMassMale = (leanMale(:,2) - leanMale(:,3))/1000;
leanMassFeMale = (leanFemale(:,2) - leanFemale(:,3))/1000;

logXMale= log10(leanMassMale)';
logYMale = log10(leanMale(:,5))';

logXFeMale= log10(leanMassFeMale)';
logYFeMale = log10(leanFemale(:,5))';

fatModelPolly = 1;
fatModelParamMale = polyfit(logXMale, logYMale, fatModelPolly);
fatModelParamFemale = polyfit(logXFeMale, logYFeMale, fatModelPolly);

weightValues = log10(linspace(2, 65, 100))';
model1 = zeros(length(weightValues), 1);
model2 = zeros(length(weightValues), 1); 
for i = 1:(fatModelPolly+1)
    iPoly = (fatModelPolly + 1) - i;
    model1 = model1 + fatModelParamMale(i) * weightValues.^(iPoly);
    model2 = model2 + fatModelParamFemale(i) * weightValues.^(iPoly);
end

clf
hold all
plot(logXMale, logYMale, 'bx', 'linewidth', 3)
plot(logXFeMale, logYFeMale,'rx', 'linewidth', 3)
plot(weightValues, model1, 'b--')
plot(weightValues, model2,'r--')

adultLean = [20.7 43.7];
adultLength = [123.6 164.9];

plot(log10(adultLean), log10(adultLength),'o')


legend('Male', 'Female', 'location', 'nw')
xlabel('log10(lean mass)')
ylabel('log10(height)')

hold off
figure()
clf
hold all
plot(10.^weightValues, 10.^model1,'b-');
plot(10.^weightValues, 10.^model2,'r-');
plot(adultLean, adultLength,'o')

legend('Male', 'Female', 'location', 'nw')
xlabel('Lean mass [kg]')
ylabel('Height [m]')

fatModelParamMale
fatModelParamFemale
averageModel = (fatModelParamMale + fatModelParamFemale)/2
