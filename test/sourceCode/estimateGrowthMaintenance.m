function maintenance = estimateGrowthMaintenance(fatLeanRatio, individual)
% estimateGrowthMaintenance
% Estimates the energy required for growth from the dryweight adjusted fat 
% lean ratio. From values specified in the individual struct.
%
%   fatLeanRatio    fat lean ratio in the dry weight.
%   individual      an individual structure
%   maintenance     the maintainance in kcal/kg dryweight
%
%   Avlant Nilsson, 2016-05-16
%
    maintenance = fatLeanRatio * individual.fatMassCost + (1-fatLeanRatio) * individual.leanMassCost;    
end

