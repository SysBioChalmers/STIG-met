function [result, labels]= breastMilkData(weight, day, compartment)
% breastMilkData
%
% join the data togeteher and add free metabolites
%
%   weight                  weight of milk
%   day                     age of infant
%   compartment             abbreviaton of compartment e.g. 's'
%   result                  content of metabolites in milk (in mol)
%   labels                  metabolite names with compartment indicator e.g
%                           'glucose[s]'
%   Avlant Nilsson, 2016-05-17
%    
    if nargin == 2
        compartment = 's';
    end

    [Carb CarbLab] = breastMilkCarbs(weight, day);
    [AA AALab] =   breastMilkAA(weight, day);
    [FA FALab] =   breastMilkFA(weight, day);
    %[MaT MaTLab] =  breastMilkMajorTrace(weight, day);
    %[MiT MiTLab] =  breastMilkMinorTrace(weight, day);
    
    %Fake metabolites:
    fakeA = {    
        'O2'
        'Pi'
        'H2O'
        'sulfate'
        'Na+'
        'chloride'
        };
    fakeVal = [
        1000
        100
        1000
        100
        100
        100
    ];




    labels = [
        fakeA
        CarbLab
        AALab        
        FALab
        %MaTLab
        %MiTLab
    ];
    
    result = [
        fakeVal
        Carb
        AA        
        FA
        %MaT
        %MiT
    ];

    labels = strcat(labels, ['[' compartment ']']);
end