function  plotResults(simulationResults, plotCommand, simSettings, plotSettings, referenceData)
% plotResults
% Plots the content of simulationResults as specified by the string in
% plotCommand
%
%   simulationResults   Cell array with outputs from "runSimulation".
%   plotCommand         a string with commands separated by | e.g.
%                       'growth|height' Full list:
%                        growth - growth curves against reference data
%                        delta  - growth increment in gram per day
%                        zscore - zscore of growth curves using WHO data
%                        fatmass - fat ratio in gram fatt/gram infant
%                        gas -  exchange fluxes of O2 and CO2 and also RQ.
%                        energy - The calculated energy expenditure.
%                        xFluxes - The exchangefluxes from the FBA
%                        subsystems - the sum of abs(flux) in each subsys.
%                        intFluxes  - print fluxes from FBA to file
%                                    'output/fluxes_[simulation name].txt'
%                        foodUtilization - print exchange fluxes compared
%                                          with the ubound of the fluxes.
%                                    'output/foodUtilization_[simname].txt'
%                        nitrogen  - The N retention and urea excretion
%                        fatfix    - The useage of the alternative fat
%                                    biomass equation (expected to be 0)
%                        difference - compare delta growth to reference
%                        height  - The height estimated from leanmass
%                        zheight - The zscore for the height estimated from
%                                  leanmass
%   simSettings          the settings that were used when generating the
%                        results        
%   plotSettings         currently not used, intended for parameters to
%                        tweak the plotting.
%   referenceData        a struct containging reference data for comparison
%
%   Avlant Nilsson, 2016-05-17
%

close all
clf

C = strsplit(plotCommand, '|');

for i = 1:length(C)
    if strcmp(C{i}, 'growth')
        plotGrowthCurve(simulationResults, referenceData, simSettings)
    elseif strcmp(C{i}, 'delta')
        plotDeltaGrowth(simulationResults, referenceData, simSettings)
    elseif strcmp(C{i}, 'zscore')
        plotZscore(simulationResults, referenceData, simSettings)		
    elseif strcmp(C{i}, 'fatmass')
        plotFatPercent(simulationResults, referenceData)        
    elseif strcmp(C{i}, 'gas')
        plotGas(simulationResults, simSettings, referenceData)    
    elseif strcmp(C{i}, 'energy')
        plotEnergy(simulationResults)
    elseif strcmp(C{i}, 'xFluxes')
        plotExchangeFluxes(simulationResults, simSettings) 
    elseif strcmp(C{i}, 'subsystems')
        heatmapSubsystems(simulationResults, simSettings) 
    elseif strcmp(C{i}, 'intFluxes')    
        printInternalFluxes(simulationResults, simSettings) 
    elseif strcmp(C{i}, 'foodUtilization')    
        printFoodUtil(simulationResults, simSettings) 
    elseif strcmp(C{i}, 'nitrogen')     
        plotNitrogen(simulationResults, simSettings) 
    elseif strcmp(C{i}, 'fatfix')     
        plotFatFix(simulationResults, simSettings)
    elseif strcmp(C{i}, 'difference')
        plotGrowthDifference(simulationResults, referenceData, simSettings);
    elseif strcmp(C{i}, 'height')
        plotHeightEstimate(simulationResults, referenceData, simSettings);        
    elseif strcmp(C{i}, 'zheight')
        plotHeightZscore(simulationResults, referenceData, simSettings);          
    end
    
    
    
    if i~=length(C)
    figure()
    end
end


    
end


function plotGrowthCurve(simulationResults, referenceData, simSettings)
hold all
%Reference data
childData = referenceData.weight;
time = childData(:,1)/30.4;
childData(:,2:end) = 1000 * childData(:,2:end);

grayColor = [0.5 0.5 0.5];
%greyColor2 = [0.6 0.6 0.6];

xvals = [time; flip(time)];
yvals = [childData(:, 2); flip(childData(:, 6))];
fill(xvals, yvals, grayColor, 'edgecolor','none', 'FaceAlpha', 0.3)

yvals = [childData(:, 3); flip(childData(:, 5))];
fill(xvals, yvals, grayColor, 'edgecolor','none', 'FaceAlpha', 0.3, 'HandleVisibility','off')
plot(time, childData(:, 4), 'Color', grayColor, 'linewidth', 2, 'HandleVisibility','off')

%Plot data
legendValues{1} = 'Reference';

for i = 1:length(simulationResults)
    timePoints = simulationResults{i}.timePoints;
    weights = simulationResults{i}.weight;
    timePoints = [simulationResults{i}.individual.age timePoints];   
    weights = [simulationResults{i}.individual.weight; weights];
    legendValues{i+1} = simulationResults{i}.individual.name;
    plot(timePoints/30.4, weights, 'linewidth', 3);
end

xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
ylabel('Weight [g]', 'FontSize',15,'FontName', 'Arial')
ylim([0 11000])
xlim([timePoints(1) timePoints(end)+5]/30.4)
legend(legendValues, 'location', 'nw');
legend boxoff

set(gca,'FontSize',15,'FontName', 'Arial')   
hold off
end

function plotZscore(simulationResults, referenceData, simSettings)
hold all
legendValues=[];


childData = referenceData.zscore;


for i = 1:length(simulationResults)
    timePoints = simulationResults{i}.timePoints;
    timePoints = [simulationResults{i}.individual.age timePoints];  
    
    weights = simulationResults{i}.weight;     
    weights = [simulationResults{i}.individual.weight; weights];
    weights = weights/1000;
   
    zScore = getZscores(timePoints, weights, childData);
    legendValues{i} = simulationResults{i}.individual.name;
    plot(timePoints/30.4, zScore, '-', 'linewidth', 3)
end
%Reference



highLowTime = [min(timePoints) max(timePoints)]/30.4;
greyColor = [0.5 0.5 0.5];
plot(highLowTime, [0 0], 'Color', greyColor)
plot(highLowTime, [1 1], 'Color', greyColor)
plot(highLowTime, [2 2], 'Color', greyColor)
plot(highLowTime, [-1 -1], 'Color', greyColor)
plot(highLowTime, [-2 -2], 'Color', greyColor)

xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
ylabel('z-score', 'FontSize',15,'FontName', 'Arial')

xlim([timePoints(1) timePoints(end)+5]/30.4)
legend(legendValues, 'location', 'nw');


set(gca,'FontSize',15,'FontName', 'Arial')   
hold off
end

function plotGrowthDifference(simulationResults, referenceData, simSettings)
hold all
childData = referenceData.weight;
childData(200:end,:) = [];
time = childData(:,1)/30.4;
childData(:,2:end) = 1000 * childData(:,2:end);
deltaReference = diff(childData(:, 4));

for i = 1:length(simulationResults)
    timePoints = simulationResults{i}.timePoints;
    weights = simulationResults{i}.weight;
    timePoints = [simulationResults{i}.individual.age timePoints];   
    weights = [simulationResults{i}.individual.weight; weights];
    deltaWeight = sum(simulationResults{i}.deltaValues,2);
    trueWeights = childData(timePoints+1, 4);
    trueDelta = deltaReference(timePoints(2:end)+1);
    subplot(1,2,1)
    plot(timePoints/30.4, weights./trueWeights, 'gx-', 'linewidth', 3)
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('% from true value', 'FontSize',15,'FontName', 'Arial')
    xlim([timePoints(1) timePoints(end)]/30.4)

    set(gca,'FontSize',15,'FontName', 'Arial')       
    subplot(1,2,2)
    plot(timePoints(2:end)/30.4, deltaWeight./trueDelta)
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('% from true value', 'FontSize',15,'FontName', 'Arial')
    xlim([timePoints(1) timePoints(end)]/30.4)

    set(gca,'FontSize',15,'FontName', 'Arial')       
end

%Reference

hold off
end

function plotDeltaGrowth(simulationResults, referenceData, simSettings)
hold all

for i = 1:length(simulationResults)
    timePoints = simulationResults{i}.timePoints;
    deltaWeight = sum(simulationResults{i}.deltaValues,2);
    legendValues{i} = simulationResults{i}.individual.name;
    plot(timePoints/30.4, deltaWeight, 'linewidth', 2)    
end

legendValues{i+1} = 'Reference Data';
%Reference

childData = referenceData.weight;
childData(200:end,:) = [];
time = childData(2:end,1)/30.4;
childData(:,2:end) = 1000 * childData(:,2:end);

greyColor = [0.5 0.5 0.5];
plot(time, diff(childData(:, 2)), 'Color', greyColor)
plot(time, diff(childData(:, 3)), 'Color', greyColor)
plot(time, diff(childData(:, 4)), 'Color', greyColor)
plot(time, diff(childData(:, 5)), 'Color', greyColor)
plot(time, diff(childData(:, 6)), 'Color', greyColor)


xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
ylabel('Weight gain [g/day]', 'FontSize',15,'FontName', 'Arial')
ylim([0 60])
xlim([timePoints(1) timePoints(end)]/30.4)
legend(legendValues, 'location', 'nw');


set(gca,'FontSize',15,'FontName', 'Arial')   
hold off
end

function plotFatPercent(simulationResults, referenceData)
hold all

for i = 1:length(simulationResults)
    timePoints = simulationResults{i}.timePoints;
    weights = simulationResults{i}.weight;
    fat = simulationResults{i}.fat;
    timePoints = [simulationResults{i}.individual.age timePoints];   
    weights = [simulationResults{i}.individual.weight; weights];
    fat = [simulationResults{i}.individual.fatMass; fat];
    legendValues{i} = simulationResults{i}.individual.name;
    plot(timePoints/30.4, fat./weights, 'linewidth', 3)
end

legendValues{i+1} = 'Reference Data';

%Reference

childData = referenceData.fat;
fatPercentNorm = childData(:,3)./childData(:,2);
fatPercentSTDU = (childData(:,3) + childData(:,4))./childData(:,2);
fatPercentSTDL = (childData(:,3) - childData(:,4))./childData(:,2);


greyColor = [0.5 0.5 0.5];
plot(childData(:,1), fatPercentNorm, 'x--', 'Color', greyColor)
plot(childData(:,1), fatPercentSTDU, 'x--', 'Color', greyColor)
plot(childData(:,1), fatPercentSTDL, 'x--', 'Color', greyColor)


xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
ylabel('Fat Ratio [g/g]', 'FontSize',15,'FontName', 'Arial')
ylim([0 0.4])
legend(legendValues, 'location', 'nw');

set(gca,'FontSize',15,'FontName', 'Arial')   
hold off
end

function plotGas(simulationResults, simSettings, referenceData)
hold all
literToMol = 24;

CO2ExchangeRxn = getBounds(simSettings.model, {'CO2[s]'});

O2ExchangeRxn = getBounds(simSettings.model, {'O2[s]'});


greyColor = [0.5 0.5 0.5];
refTime = 0:200;
refWeight = referenceData.weight((1+refTime),4)/1000;
oxygenModel = @(x)(x .* refWeight .* 60 .* 24)/literToMol;

for i = 1:length(simulationResults)
    subplot(1,2,1)
    hold on
    timePoints = simulationResults{i}.timePoints;
    CO2 = simulationResults{i}.fluxes(:,CO2ExchangeRxn);
    O2 = -simulationResults{i}.fluxes(:,O2ExchangeRxn);
    CO2 = CO2.* simulationResults{i}.dryWeight;
    O2 = O2 .* simulationResults{i}.dryWeight;
    RQ = CO2./O2;
    plot(timePoints/30.4, CO2, 'rx-', 'linewidth', 3)
    plot(timePoints/30.4, O2, 'bx-', 'linewidth', 3)

    plot(refTime/30.4, oxygenModel(9.5), 'color', greyColor);
    plot(refTime/30.4, oxygenModel(9.5-2), 'color', greyColor);
    plot(refTime/30.4, oxygenModel(9.5+2), 'color', greyColor);    
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('mol/day', 'FontSize',15,'FontName', 'Arial')
    ylim([0 5])
    legend('CO2', 'O2', 'Reference Model', 'location', 'se');
    
    set(gca,'FontSize',15,'FontName', 'Arial')   
    hold off
    subplot(1,2,2)
    plot(timePoints/30.4, RQ, 'gx-', 'linewidth', 3)
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('RQ', 'FontSize',15,'FontName', 'Arial')
 
    if i<length(simulationResults)
        figure()
    end
end



end

function plotEnergy(simulationResults)
hold all
global constants;

for i = 1:length(simulationResults)
    timePoints = simulationResults{i}.timePoints;
    EE = simulationResults{i}.energyExpenditure;
    synthesingEnergy = simulationResults{1}.deltaValues;
    synthesingEnergy(synthesingEnergy(:,1)<0,1) = 0;
    synthesingEnergy(:,1) = synthesingEnergy(:,1) * simulationResults{1}.individual.fatMassCost;
    synthesingEnergy(:,2) = synthesingEnergy(:,2) * simulationResults{1}.individual.leanMassCost;
    synthesingEnergy(:,2) = synthesingEnergy(:,2)/constants.proteinLeanFactor;
    
    EE = [EE synthesingEnergy(:,2) synthesingEnergy(:,1)];
    totalEnergy = sum(EE,2);
    normalizedEE = EE./repmat(totalEnergy,1,size(EE,2));
    
    
    subplot(2,2,1)
    plot(timePoints/30.4, [totalEnergy EE] , '-', 'linewidth', 3)
    pal = 1 + EE(:,3)./(EE(:,1) + EE(:,2));
    
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('kcal', 'FontSize',15,'FontName', 'Arial')
    legend('Total', 'Maintain Lean', 'Maintain Fat', 'Activity', 'Synthesize lean', 'Synthesize Fat', 'location', 'ne');

    set(gca,'FontSize',15,'FontName', 'Arial')   
    hold off
    subplot(2,2,2)
    hold on
    plot(timePoints/30.4, normalizedEE, '-', 'linewidth', 3)
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('ratio', 'FontSize',15,'FontName', 'Arial')
    legend('Maintain Lean', 'Maintain Fat', 'Activity', 'Synthesize lean', 'Synthesize Fat', 'location', 'ne');
    set(gca,'FontSize',15,'FontName', 'Arial') 
    ylim([0 1])    
    subplot(2,2,3)
    hold on
    plot(timePoints/30.4, pal, 'k-', 'linewidth', 3)
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('Pal', 'FontSize',15,'FontName', 'Arial')
    
    if i<length(simulationResults)
        figure()
    end    
end


end

function plotHeightZscore(simulationResults, referenceData, simSettings)
    legendValues = [];
    hold all
    timePoints = simulationResults{1}.timePoints;
    approxHeight = getHeightEstimates(simulationResults);  

    childData = referenceData.zscoreheight;


    for i = 1:length(simulationResults)        
        zScore = getZscores(timePoints, approxHeight{i}, childData);
        legendValues{i} = simulationResults{i}.individual.name;
        plot(timePoints/30.4, zScore, '-', 'linewidth', 3)
    end

    %Reference
    highLowTime = [min(timePoints) max(timePoints)]/30.4;
    greyColor = [0.5 0.5 0.5];
    plot(highLowTime, [0 0], 'Color', greyColor)
    plot(highLowTime, [1 1], 'Color', greyColor)
    plot(highLowTime, [2 2], 'Color', greyColor)
    plot(highLowTime, [-1 -1], 'Color', greyColor)
    plot(highLowTime, [-2 -2], 'Color', greyColor)

    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('z-score [height]', 'FontSize',15,'FontName', 'Arial')

    xlim([timePoints(1) timePoints(end)+5]/30.4)
    legend(legendValues, 'location', 'nw');


    set(gca,'FontSize',15,'FontName', 'Arial')   
    hold off
end


function approxHeight = getHeightEstimates(simulationResults)
    for i = 1:length(simulationResults)
        if simulationResults{i}.individual.male
            parameterSetAir = [0.450    1.486];
            %parameterSetAir = [0.463    1.481];     %Derived from Butte 2000    
        else
            parameterSetAir = [0.450    1.493]; 
        end       
        
        conversionEquation = @(leanMass) 10.^parameterSetAir(2) * leanMass.^parameterSetAir(1);
    
        leanWeight = (simulationResults{i}.weight-simulationResults{i}.fat)/1000;
        approxHeight{i} = conversionEquation(leanWeight);
    end        
end


function plotHeightEstimate(simulationResults, referenceData, simSettings)
    legendValues = [];
         
    hold all

    timePoints = simulationResults{1}.timePoints/30.4;
    approxHeight = getHeightEstimates(simulationResults);
    
    for i = 1:length(simulationResults)
        legendValues{i} = simulationResults{i}.individual.name;
        
        plot(timePoints, approxHeight{i}, 'linewidth', 3)   
    end        

       
    
    %Reference

    childData = referenceData.height;
    time = childData(:,1)/30.4;
    childData(:,2:end) = childData(:,2:end);

    greyColor = [0.5 0.5 0.5];
    plot(time, childData(:, 2), 'Color', greyColor)
    plot(time, childData(:, 3), 'Color', greyColor)
    plot(time, childData(:, 4), 'Color', greyColor)
    plot(time, childData(:, 5), 'Color', greyColor)
    plot(time, childData(:, 6), 'Color', greyColor)
    
    xlim([timePoints(1) timePoints(end)])
    
    legend(legendValues, 'location', 'se')
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('Height [cm]', 'FontSize',15,'FontName', 'Arial')
    set(gca,'FontSize',15,'FontName', 'Arial')   
end



function plotExchangeFluxes(simulationResults, simSettings)
hold all
model = simSettings.model;
threshold = 10^-5;

[crap, exchangeReactions] = getExchangeRxns(model);
referenceEquations = constructEquations(model, model.rxns(exchangeReactions));

for i = 1:length(simulationResults)
    rxnEq = referenceEquations;
    subplot(2,2,1)
    timePoints = simulationResults{i}.timePoints;
    exchangeFluxes = simulationResults{i}.fluxes(:,exchangeReactions);

    zeroFluxes = mean(abs(exchangeFluxes))<threshold;
    exchangeFluxes(:, zeroFluxes) = [];
    rxnEq(zeroFluxes) = [];
    representativeValue = max(abs(exchangeFluxes));
    
    order1Fluxes = representativeValue > 1;
    plot(timePoints, exchangeFluxes(:, order1Fluxes), 'linewidth', 2)  
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('flux [mmol/gdw]', 'FontSize',15,'FontName', 'Arial')
    legend(rxnEq(order1Fluxes), 'location', 'ne');
    subplot(2,2,2)
    order2Fluxes =  and(representativeValue > 0.01, representativeValue < 1);

    plot(timePoints, exchangeFluxes(:, order2Fluxes), 'linewidth', 2)  
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('flux [mmol/gdw]', 'FontSize',15,'FontName', 'Arial')
    legend(rxnEq(order2Fluxes), 'location', 'ne');
    subplot(2,2,3)  
    order3Fluxes =  and(representativeValue < 0.01, sign(mean(exchangeFluxes))>0);
    plot(timePoints, exchangeFluxes(:, order3Fluxes))  
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('flux [mmol/gdw]', 'FontSize',15,'FontName', 'Arial')
    legend(rxnEq(order3Fluxes), 'location', 'ne');    
    subplot(2,2,4)  
    order4Fluxes =  and(representativeValue < 0.01, sign(mean(exchangeFluxes))<0);
    plot(timePoints, exchangeFluxes(:, order4Fluxes))  
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('flux [mmol/gdw]', 'FontSize',15,'FontName', 'Arial')
    %legend(rxnEq(order4Fluxes), 'location', 'ne');  
    
    if i<length(simulationResults)
        figure()
    end    
end

end


function heatmapSubsystems(simulationResults, simSettings)
if simSettings.parsimonious == true
    model = simSettings.model;
    threshold = 10^-7;

    %rxnEq = constructEquations(model, model.rxns(exchangeReactions));

    allSubsystems = unique(model.subSystems);
    subIndex = getReactionSubsystem(model, allSubsystems);
    subCount = zeros(length(allSubsystems),1);

    for i = 1:length(simulationResults)
        leanWeight = (simulationResults{i}.weight-simulationResults{i}.fat)/1000;
        dryWeight = simulationResults{i}.dryWeight;
        timePoints = cellstr(num2str(simulationResults{1}.timePoints'))';
        for j = 1:length(timePoints)
            if mod(j,5) >0
                timePoints{j} = '';
            end
        end

        absFluxes =  abs(simulationResults{i}.fluxes);
        normalizationMatrix = repmat(dryWeight./leanWeight, 1,size(absFluxes,2));
        absFluxes = absFluxes .* normalizationMatrix;

        subsystemFlux = zeros(size(absFluxes,1), length(allSubsystems));


        for j = 1:length(allSubsystems)
           subsystemFlux(:,j) = sum(absFluxes(:, subIndex == j), 2);
           subCount(j) = sum(subIndex == j);
           %subsystemFlux(:,j) =  subsystemFlux(:,j)/subCount(j);
        end



        emptySubsystems = sum(subsystemFlux) <threshold;
        subsystemFlux(:,emptySubsystems) = [];
        subCount(emptySubsystems) = [];
        nonEmptySystems = allSubsystems(not(emptySubsystems));
        normalizationMatrix = repmat(max(subsystemFlux)', 1,length(timePoints));
        CGObject = clustergram(subsystemFlux'./normalizationMatrix, 'RowLabels', nonEmptySystems, 'ColumnLabels', timePoints, 'Colormap', redbluecmap, 'Cluster', 1, 'Symmetric', false);
        plot(CGObject)
        
        %plot(simulationResults{1}.timePoints, subsystemFlux(:,10))
        pieThreshold = 0.02;
        pieValues = mean(subsystemFlux);
        %plotPie(pieValues, pieThreshold, nonEmptySystems)
        %figure()
        %plotPie(pieValues./subCount', pieThreshold, nonEmptySystems)
    end
else
    disp('simulations have to be run with pFBA for this to be meaningful')
end
end


function result=getReactionSubsystem(model, subsystemList)
    result = zeros(length(model.rxns),1);
    for i = 1:length(model.rxns)
        result(i) = find(ismember(subsystemList, model.subSystems(i)));
    end
end


function plotPie(pieValues, pieThreshold, labelValues)
    pieValues = pieValues/sum(pieValues);
    nonEmptyPieValues = pieValues>pieThreshold;
    other = 1 - sum(pieValues(nonEmptyPieValues));
    finalValues = pieValues(nonEmptyPieValues);
    finalLegends = labelValues(nonEmptyPieValues);
    [finalValues, order] = sort(finalValues);
    finalLegends = finalLegends(order);    
    pie([other, finalValues])
    legendValues = ['other'; finalLegends];
    legend(legendValues,'Location','southoutside')
end


function printInternalFluxes(simulationResults, simSettings)
model = simSettings.model;
threshold = 10^-10;

%rxnEq = constructEquations(model);
rxnEq = model.rxns;

for i = 1:length(simulationResults)
    fileName = ['output/fluxes_' simulationResults{i}.individual.name '.txt'];
    fileID = fopen(fileName,'w');
    timePoints = simulationResults{1}.timePoints;
    fluxes = simulationResults{i}.fluxes;
    fprintf(fileID, 'Reaction\tEquation\tSubsystem');
    for j = 1:length(timePoints)
        fprintf(fileID, '\t%i', timePoints(j));
    end
    fprintf(fileID, '\n');
    
    for j = 1:size(fluxes,2)
        fprintf(fileID, '%s\t%s\t%s', rxnEq{j}, model.rxns{j}, model.subSystems{j});
        for k=1:size(fluxes,1)
            if abs(fluxes(k,j))>threshold
                fprintf(fileID, '\t%f', fluxes(k,j));
            else
                fprintf(fileID, '\t');
            end
        end
        fprintf(fileID, '\n');
    end
    fclose(fileID);
end

end



function printFoodUtil(simulationResults, simSettings)
model = simSettings.model;

%rxnEq = constructEquations(model, model.rxns(exchangeReactions));

for i = 1:length(simulationResults)
    fileName = ['output/foodUtilization_' simulationResults{i}.individual.name '.txt']; 
    fileID = fopen(fileName,'w');
    timePoints = simulationResults{1}.timePoints;
    foodIndx = simulationResults{1}.foodIndex;
    
    foodFluxes = simulationResults{i}.fluxes(:,foodIndx);
    foodBondNormalizer = repmat(simulationResults{i}.dryWeight, 1,length(foodIndx)); 
    foodBonds = simulationResults{1}.foodBonds./foodBondNormalizer;
    
    labels = constructEquations(model, foodIndx);
    utilization = -foodFluxes./foodBonds;   

       fprintf(fileID, 'Reaction\t');
        for j = 1:length(timePoints)
            fprintf(fileID, '\t%i', timePoints(j));
        end
        fprintf(fileID, '\n');

        for j = 1:size(utilization,2)
            fprintf(fileID, '%s', labels{j});
            for k=1:size(utilization,1)
                fprintf(fileID, '\t%f', utilization(k,j));
            end
            fprintf(fileID, '\n');
        end
        fclose(fileID);    
    
end

end

function plotNitrogen(simulationResults, simSettings)
model = simSettings.model;

ureaExchangeRxn = getBounds(model, {'urea[s]'});

for i = 1:length(simulationResults)
    timePoints = simulationResults{1}.timePoints/30.4;
    foodIndx = simulationResults{1}.foodIndex;    
    foodFluxes = simulationResults{i}.fluxes(:,foodIndx);
    
    metaboliteNrs = zeros(length(foodIndx), 1);
    for j = 1:length(foodIndx)
        metaboliteNrs(j) = find(model.S(:,foodIndx(j)));
    end
    
    [elementNames, useMat, exitFlag]=parseFormulas(model.metFormulas(metaboliteNrs), true);
    nrOfNitrogen = useMat(:, ismember(elementNames.abbrevs, 'N'));
    
    nrOfNitrogenMatrix = repmat(nrOfNitrogen',length(timePoints),1);

    influxNitrogen = nrOfNitrogenMatrix .* foodFluxes;
    totalNinflux = -sum(influxNitrogen,2);

    influxNitrogen(:, nrOfNitrogen==0) = [];
    
    totalNUrea = 2 * simulationResults{i}.fluxes(:,ureaExchangeRxn);
    
    subplot(1,2,1)
    hold all
    plot(timePoints, totalNinflux, 'linewidth', 3)    
    plot(timePoints, totalNUrea, 'linewidth', 3)
    labelList = {'Total Influx'; 'urea'};
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('mMol N/gdw', 'FontSize',15,'FontName', 'Arial')
    set(gca,'FontSize',15,'FontName', 'Arial')  
    ylim([0 0.13])
    legend(labelList)
    subplot(1,2,2)
    Nretention = 1- totalNUrea./totalNinflux;
    plot(timePoints, Nretention, 'linewidth', 3)
    ylim([0 1])
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('N retention', 'FontSize',15,'FontName', 'Arial')
    set(gca,'FontSize',15,'FontName', 'Arial')   
end

end

function plotFatFix(simulationResults, simSettings)
model = simSettings.model;

realTG = find(ismember(model.rxns, 'human_TGPool'));
fixTG = find(ismember( model.rxns, 'human_TGPoolFix'));


for i = 1:length(simulationResults)
    timePoints = simulationResults{1}.timePoints/30.4;   
    tgFlux = simulationResults{i}.fluxes(:,realTG);
    fixFlux = simulationResults{i}.fluxes(:,fixTG);
    cumulutiveFix = zeros(length(timePoints)+1,1);
    cumulutiveNorm = zeros(length(timePoints)+1,1);
    cumulutiveNorm(1) = simulationResults{i}.individual.fatMass/1000;
    cumulutiveNorm(1) = cumulutiveNorm(1);
    for j = 2:length(cumulutiveNorm)
        stepNormalization = simSettings.timeStep/simulationResults{i}.dryWeight(i);
        cumulutiveNorm(j) = cumulutiveNorm(j-1) + tgFlux(j-1) * stepNormalization;
        cumulutiveFix(j) = cumulutiveFix(j-1) + fixFlux(j-1) * stepNormalization;
    end
    cumulutiveNorm
    hold all
    plot(timePoints, fixFlux./(tgFlux + fixFlux), 'linewidth', 3)
    fixRatio = cumulutiveFix./(cumulutiveFix + cumulutiveNorm);
    additionalTimePoint = simulationResults{1}.individual.age/30.4;
    plot([additionalTimePoint timePoints], fixRatio, 'linewidth', 3)
    ylim([0 0.3])
    xlabel('Age [months]', 'FontSize',15,'FontName', 'Arial');
    ylabel('ratio', 'FontSize',15,'FontName', 'Arial')
    legend('Flux Fix/Total','Cumulative Fat Fix/Total')
    set(gca,'FontSize',15,'FontName', 'Arial')   
end


end

