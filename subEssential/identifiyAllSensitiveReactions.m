%The purpose of this simulation is to identify which reactions are
%important for growth

load('../fbaModel/genericHuman2.mat')
addpath('../sourcecode')
addpath('../data')

global constants
constants = loadConstants();



age = 30;

referenceData = makeReferenceObject('../referenceData/weightBoy.txt');


weight = 1000*referenceData.weight(age+1,2);
fatMass = 0.2*weight;
maintenance = (weight - fatMass)*60/1000;

foodModel = configureFood(model, '../data/milkModel.txt', 1, 200);
influxValues = foodModel.fluxes(age,:);
reactionNumbers = foodModel.rxnIndx;

growthRel = 1.6*0.4 +  5.4 * 0.6;
FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, maintenance, growthRel, 0.4, fatMass, weight, true);

referenceGain = FBASolution.leanGain;
threshold = 10^-8;

reactionsWithFlux = find(abs(FBASolution.x)>threshold);
length(reactionsWithFlux)

results = zeros(length(reactionsWithFlux), 1);
for i = 1:length(reactionsWithFlux)
    currentReaction = reactionsWithFlux(i);
    tmpModel = model;
    tmpModel.ub(currentReaction) = 0;
    tmpModel.lb(currentReaction) = 0;    
    FBASolution = normalizeAndRunFBA(tmpModel, reactionNumbers, influxValues, maintenance, growthRel, 0.4, fatMass, weight, false);
    results(i) = FBASolution.leanGain;
end
essentialReactions = reactionsWithFlux(results<10^-6);
reactionsWithGrowthEffect = (results./referenceGain)<1-threshold;
reactionsWithGrowthEffect = reactionsWithFlux(reactionsWithGrowthEffect);
length(reactionsWithGrowthEffect)


%Calculate shadow prices
shadowPrices = zeros(length(reactionsWithGrowthEffect)+1, 4);


energyModel = model;
fatRxn = findIndex(model.rxns, 'human_fatmass');
leanRxn = findIndex(model.rxns, 'human_leanmass');
energyModel.S(:,fatRxn) = 0;
energyModel.S(:,leanRxn) = 0;
energyModel = configureSMatrix(energyModel, -1, 'human_fatmass', 'biomassFat[c]');
energyModel = configureSMatrix(energyModel, -1, 'human_leanmass','biomassLean[c]');


factor = 0.99;
for i = 1:(length(reactionsWithGrowthEffect) + 1);
    if i>length(reactionsWithGrowthEffect)
        constrainObject.rxns = [];
        constrainObject.level = 1;
    else
        constrainObject.rxns = reactionsWithGrowthEffect(i);
        constrainObject.level = factor;       
    end
    
    %biomass
    growthRel = 1.6*0.4 +  5.4 * 0.6;
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, maintenance, growthRel, 0.4, fatMass, weight, false, constrainObject);
    shadowPrices(i, 1) = FBASolution.fatGain;

    %Fat mass
    growthRel = 1.62;
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, 0          , growthRel, 1,   fatMass, weight, false, constrainObject);
    shadowPrices(i, 2) = FBASolution.fatGain;

    %Lean mass
    growthRel = 5.4;
    FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, 0          , growthRel, 0, fatMass, weight, false, constrainObject);
    shadowPrices(i, 3) = FBASolution.leanGain;        

    %Energy
    growthRel = 1;
    FBASolution = normalizeAndRunFBA(energyModel, reactionNumbers, influxValues, 0          , growthRel, 0, fatMass, weight, false, constrainObject);
    shadowPrices(i, 4) = FBASolution.x(findIndex(model.rxns, 'human_biomass'));       
    
end    
    
shadowPriceResult = shadowPrices(1:(end-1),:);
shadowPriceResult = shadowPriceResult./repmat(shadowPrices(end,:), size(shadowPrices,1)-1,1);
shadowPriceResult = (1-shadowPriceResult)/(1-factor);

%%

for i = 1:size(shadowPriceResult,1)
   currentReaction = model.rxns{reactionsWithGrowthEffect(i)};
   fprintf('%s', currentReaction)
   fprintf('\t%s', model.subSystems{reactionsWithGrowthEffect(i)})
   fprintf('\t%s', model.eccodes{reactionsWithGrowthEffect(i)})
   equation = constructEquations(model, reactionsWithGrowthEffect(i));
   fprintf('\t%s', equation{1});
   fprintf('\t%s',  model.grRules{reactionsWithGrowthEffect(i)});   
   cofactorString = '';
   if ismember(reactionsWithGrowthEffect(i), essentialReactions)
       fprintf('\tYes')
   else
       fprintf('\tNo')       
   end

   for j = 1:size(shadowPriceResult,2)
        fprintf('\t%2.4f', shadowPriceResult(i,j))
   end
   fprintf('\n')
end

