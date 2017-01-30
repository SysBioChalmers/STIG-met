function individual = createIndividual(indName, male, age, weight, fatMass, leanMassCost, fatMassCost, leanMassMaintenance, fatMassMaintenance, activityModel, foodUptakeFactor, fatModel, constrainedFluxes)
% createIndividual
% Adds a value to the S matrix using rxn and metabolite names as reference
%
%   indName                 name of simulation e.g. 'healty boy'
%   male                    bolean, if male (true), if female (false)
%   age                     the age of the infant in days
%   weight                  the weight of the infant in gram
%   fatMass                 the weight of the infants fat in gram
%   leanMassCost            the energy cost of producing lean mass in kcal/g
%   fatMassCost             the energy cost of producing fat mass in kcal/g
%   leanMassMaintenance     the maintainance energy for lean in kcal/kg/day
%   fatMassMaintenance      the maintainance energy for fat in kcal/kg/day
%   activityModel           a model of the energy expenditure for activity
%                           in kcal/kg/day with values for each day
%   foodUptakeFactor        value between 0 and 1 with the uptake of the
%                           nutrients, e.g. 0.93-> 93% are absorbed.
%   fatModel                for each day gives a value between 0 and 1
%                           corresponding to the fat content in g fat/ g
%                           infant
%   constrainedFluxes       a list of fluxes with constraints
%   individual              an updated model structure
%
%   Avlant Nilsson, 2016-05-16
%
    individual.name = indName;
    individual.male = male;  %gender (boolean)
    individual.weight = weight; %g
    individual.fatMass = fatMass; %g
    individual.age = age; %days
    individual.leanMassCost = leanMassCost; %kcal/g
    individual.fatMassCost = fatMassCost;%kcal/g
    individual.activityModel = activityModel;
    individual.leanMassMaintenance = leanMassMaintenance; %kcal/kg
    individual.fatMassMaintenance = fatMassMaintenance; %kcal/kg
    individual.foodUptakeFactor = foodUptakeFactor; %Uptake ratio
    individual.fatModel = fatModel; % day {tab} delta fat ratio

    if nargin < 13
        individual.constrainedFluxes.level = 1;
    else
        individual.constrainedFluxes = constrainedFluxes;        
    end    
end

