function [result, labels]= breastMilkMinorTrace(weight, day)
% breastMilkMinorTrace
% Content of minor trace elements in Breast Milk from
% Yamawaki, N., Yamada, M., Kan-no, T., Kojima, T., Kaneko, T., & Yonekubo,
% A. (2005). Macronutrient, mineral and trace element composition of breast
% milk from Japanese women. Journal of Trace Elements in Medicine and 
% Biology, 19, 171–181. doi:10.1016/j.jtemb.2005.05.001
%
%   weight                  weight of milk
%   day                     age of infant
%   result                  content of metabolites in milk (in mol)
%   labels                  metabolite names
%   Avlant Nilsson, 2016-05-17
%   

    %Warning, terrible SD, only for order of magnitude estimates
    labels = {
        'Cr'
        'Mn'
        'Fe'
        'Cu'
        'Se'};

    molWeight = [
        51.9961
        54.938049
        55.845
        63.546
        78.96
    ];
    
    data = [
            1.7	3.5	4.5	5	7.6	2.5
            1.2	1.8	2.5	0.8	1.2	0.9
            110	96	136	180	52	85
            37	48	46	34	36	16
            2.5	2.4	2.7	1.8	1.5	1.3
        ];
    
    timeIntervals = [2.5	7.5	15	54.5	134.5	272.5];

    
    if day<timeIntervals(1)
        result = data(:,1);
    elseif day>timeIntervals(end)
        result = data(:,end);
    else
        result = interp1q(timeIntervals, data', day)';
    end
    
    
    result = result .* weight/10/1000000 ;
    result = result ./molWeight;
end