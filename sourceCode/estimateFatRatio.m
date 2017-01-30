function result = estimateFatRatio(age, individual)
% estimateFatRatio
% Converts the lean/fat ratio from wetweight to dry weight assuming fat has
% 0 water content and lean has ~80% given by constants.proteinLeanFactor
%
%   age             the age of the infant
%   individual      an individual structure
%   result          the dryweight adjusted fat ratio
%
%   Avlant Nilsson, 2016-05-16
%
global constants
    fatRatio = individual.fatModel(age);
    leanRatio = 1 - fatRatio;
    proteinRatio = leanRatio/constants.proteinLeanFactor;
    result = fatRatio/(fatRatio + proteinRatio);
end

