clc
%Test growth on milk
global constants
constants = loadConstants();

load('../fbaModel/genericHuman2.mat')
addpath('..')
addpath('../sourcecode')
addpath('../data')

age = 50;
maintenance = 1;
growthRelMaintenance = 150;
fatRatio = 0.8;
parsimonious = true;

objectiveFunction = 'human_biomass';
maintainanceFunction = 'human_ATPMaintainance'; 

%constructEquations(model, 'human_biomass') %biomass reaction
%remove elements
%model = configureSMatrix(model, 0, 'human_biomass', 'cholesterol[c]');
%model = configureSMatrix(model, 0, 'human_biomass', 'glycogen[c]');
%model = configureSMatrix(model, 0, 'human_biomass', 'human_protein_pool[c]');
%model = configureSMatrix(model, 0, 'human_biomass', 'human_DNAPool[c]');
%model = configureSMatrix(model, 0, 'human_biomass', 'human_RNAPool[c]');
%model = configureSMatrix(model, 0, 'human_biomass', 'human_TGPool[c]');
%model = configureSMatrix(model, 0, 'human_biomass', 'cholesterol[c]');

model = configureBiomassEquation(model, objectiveFunction, fatRatio, growthRelMaintenance);
   

foodModel = configureFood(model, '../data/milkModel.txt', 1, 180);
foodRxns = foodModel.rxnIndx;
food = foodModel.fluxes(age,:);

approxValue = 1000;

%set up model
model = setParam(model, 'lb', model.exchangeRxns, 0);
model = setParam(model, 'ub', model.exchangeRxns, approxValue);
model = setParam(model, 'lb', foodRxns, -food);
model = setParam(model, 'ub', foodRxns, approxValue);

model = setParam(model, 'obj', objectiveFunction, 1);

model = setParam(model, 'lb', objectiveFunction, 0);
model = setParam(model, 'ub', objectiveFunction, 1000);

model = setParam(model, 'lb', maintainanceFunction, maintenance);
model = setParam(model, 'ub', maintainanceFunction, 1000);    

%solution = solveWrapper(model, false, parsimonious);
%solution

FBASolution = runFBA(model, foodRxns, food, maintenance, growthRelMaintenance, fatRatio, parsimonious)
