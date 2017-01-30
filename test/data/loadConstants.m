function constStruct = loadConstants()
% loadConstants
% contains conversion constants used throughout the program
%
%   constStruct  
%    .ATPConvertionConstant     kcal/mol ATP
%    .proteinLeanFactor         leanmass/protein content of lean mass
%    .milkDensity               density of milk (kg/l) (could be more 
%                               accurate)
%
%   Avlant Nilsson, 2016-05-17
%   
    constStruct.ATPConvertionConstant = 28.1250;
    constStruct.proteinLeanFactor = 1/(1-0.80);%5 = 1/(1-HF);
    constStruct.milkDensity = 1; %kg/l
end