%The purpose of this simulation is to identify which clusters of reactions
%are important for growth based on subsystem clasification
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

foodModel = configureFood(model, 'data/milkModel.txt', 1, 200, 0);
influxValues = foodModel.fluxes(age,:);
reactionNumbers = foodModel.rxnIndx;

growthRel = 1.6*0.4 +  5.4 * 0.6;
FBASolution = normalizeAndRunFBA(model, reactionNumbers, influxValues, maintenance, growthRel, 0.4, fatMass, weight, true);

referenceGain = FBASolution.leanGain;
threshold = 10^-8;

reactionsWithFlux = find(abs(FBASolution.x)>threshold);
affectedSubsystems = unique(model.subSystems(reactionsWithFlux));


%Calculate shadow prices
shadowPrices = zeros(length(affectedSubsystems)+1, 4);


energyModel = model;
fatRxn = findIndex(model.rxns, 'human_fatmass');
leanRxn = findIndex(model.rxns, 'human_leanmass');
energyModel.S(:,fatRxn) = 0;
energyModel.S(:,leanRxn) = 0;
energyModel = configureSMatrix(energyModel, -1, 'human_fatmass', 'biomassFat[c]');
energyModel = configureSMatrix(energyModel, -1, 'human_leanmass','biomassLean[c]');


factor = 0.99;
for i = 1:(length(affectedSubsystems) + 1);
    if i>length(affectedSubsystems)
        constrainObject.rxns = [];
        constrainObject.level = 1;
    else
        rxnsInSystem = find(ismember(model.subSystems, affectedSubsystems{i}));
        constrainObject.rxns = rxnsInSystem;
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
   fprintf('\t%s', affectedSubsystems{i})
   for j = 1:size(shadowPriceResult,2)
        fprintf('\t%2.4f', shadowPriceResult(i,j))
   end
   fprintf('\n')
end

