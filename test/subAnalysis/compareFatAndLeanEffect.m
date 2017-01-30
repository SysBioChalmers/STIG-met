%The purpose of this simulation is to identify the effect of cofactors on 
%lean and fat mass formation 

load('../fbaModel/genericHuman2.mat')
addpath('../sourcecode')
addpath('../data')

global constants
constants = loadConstants();



age = 30;

referenceData = makeReferenceObject('../referenceData/weightBoy.txt');

cofactorFile = {
    'none'
    'mg'
    'zinc'
    'heme'
    'biotin'
    };
factor = 0.90;

weight = 1000*referenceData.weight(age+1,2);
fatMass = 0.2*weight;
maintenance = (weight - fatMass)*60/1000;

results = zeros(length(cofactorFile), 6);



foodModel = configureFood(model, 'data/milkModel.txt', 1, 200, 0);
influxValues = foodModel.fluxes(age,:);
reactionNumbers = foodModel.rxnIndx;




for i = 1:length(cofactorFile)
    cofactorFile{i}
    reactionString = importdata(['../data/cofactorModel/'  cofactorFile{i} '.txt']);
    cofactorReactions = getIndexFromText(model.rxns, reactionString);
    constrainObject.rxns = cofactorReactions;
    constrainObject.level = factor;      

    growthRel = 1.6*0.4 +  5.4 * 0.6;
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, maintenance, growthRel, 0.4, fatMass, weight, true, constrainObject);
    results(i, 1) = FBASolution.fatGain;
    
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, 0          , growthRel, 0.4, fatMass, weight, true, constrainObject);
    results(i, 2) = FBASolution.fatGain;

    growthRel = 1.62;
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, maintenance, growthRel, 1,   fatMass, weight, true, constrainObject);
    results(i, 3) = FBASolution.fatGain;
    
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, 0          , growthRel, 1,   fatMass, weight, true, constrainObject);
    results(i, 4) = FBASolution.fatGain;

    growthRel = 5.4;
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, maintenance, growthRel, 0, fatMass, weight, true, constrainObject);
    results(i, 5) = FBASolution.leanGain;
 
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, 0          , growthRel, 0, fatMass, weight, true, constrainObject);
    results(i, 6) = FBASolution.leanGain;        
end


normalizedResult = results;
for i = 1:6
    normalizedResult(:,i) = normalizedResult(:,i)/max(normalizedResult(:,i));
end

clf
hold all
greyColor = [0.5 0.5 0.5];
xPositions = 1:2:(2*size(normalizedResult, 2));
for i = 1:(length(cofactorFile)-1)
    curX = xPositions + i*0.1;
    curY = normalizedResult(i+1,:);
    plot (curY, 12 - curX, '+', 'linewidth', 3, 'MarkerSize',15)
end


plot([1 1], [0 13], 'k-')
plot([0.9 0.9], [0 13], 'k--')


xlabel('Growth', 'FontSize',15,'FontName', 'Arial')
legend('Mg', 'Zinc', 'Heme', 'Biotin',  'location', 'nw');
set(gca,'FontSize',12,'FontName', 'Arial')
xlim([0.3 1.1]);
ylim([0 13]);
ax = gca;
set(gca,'YTick',[1 3 5 7 9 11])
%set(gca,'YTickLabel', {'Biomass', 'Biomass -M', 'Fat', 'Fat -M', 'Lean', 'Lean-M'})
set(gca,'YTickLabel', {'Lean-M', 'Lean', 'Fat -M', 'Fat', 'Biomass-M','Biomass'})


hold off



