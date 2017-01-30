%The purpose with this function is to estimate the mass of brain in infants
%from the head circumference data using an empirical relation from
%literature. This is later used to estimate energy expenditure in infants

dataMHC = load('maleHead.txt');
dataFHC = load('femaleHead.txt');


%Days	Length	heart	Liver	Kidney	Brain
dataBrain = load('brainData2.txt');
dataBrainF = load('brainData3.txt');

dataBrain(:,2) = dataBrain(:,2)/10; %to l
dataBrainF(:,2) = dataBrainF(:,2)/10; %to l



timePoints = 0:365;
timePoints = timePoints';

headCircumference = interp1q(dataMHC(:,1),dataMHC(:,2),timePoints)/100;
headMass = 1/1000 * 10.^(3.014*log10(100*headCircumference)-2.0458);

headCircumference = interp1q(dataFHC(:,1),dataFHC(:,2),timePoints)/100;
headMassF = 1/1000 * 10.^(3.014*log10(100*headCircumference)-2.0458);

headDensity = 1.08;


close all
clf
hold all
plot(dataBrain(:,1), dataBrain(:,2), 'b-', 'linewidth', 4)
plot(dataBrainF(:,1), dataBrainF(:,2), 'r-', 'linewidth', 4)
plot(timePoints, headMass/headDensity, 'k--', 'linewidth', 2);
plot(timePoints, headMassF/headDensity, 'k--', 'linewidth', 2);

xlabel('Day')
ylabel('volume (liter)')
ylim([0 1])
legend('Reference data M', 'Reference data F', 'model', 'location', 'se')

[timePoints headMass]
