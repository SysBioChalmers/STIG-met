function [result, labels] = breastMilkMajorTrace(weight, day)
% breastMilkMajorTrace
% Content of major trace elements in Breast Milk from
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


    labels = {
        %'Cl'
        %'Na'
        %'Mg'
        %'P'
        'K'
        'Ca'
        'Zn'};

    labels = {
        %'chloride'
        %'Na+'
        %''
        %''
        'K+'
        'Ca2+'
        'zinc'};
    
    
    molWeight = [
        %35.453
        %22.989770
        %24.3050
        %30.973761
        39.0983
        40.078
        65.409
    ];
    
    data = [
        %34.1	33.8	38.3	33.4	39.3	28.6
        %32.7	24.1	24.2	13.9	10.7	11.6
        %3.2	3	2.9	2.5	2.7	3.3
        %15.9	19	17.6	15.6	13.8	13
        72.3	70.9	63.9	46.6	43.4	43.2
        29.3	31	30.4	25.7	23	26
        0.475	0.384	0.337	0.177	0.067	0.065
        ];
    
    timeIntervals = [2.5	7.5	15	54.5	134.5	272.5];

    
    if day<timeIntervals(1)
        result = data(:,1);
    elseif day>timeIntervals(end)
        result = data(:,end);
    else
        result = interp1q(timeIntervals, data', day)';
    end
    
    
    result = result .* weight/10/1000 ;
    result = result ./molWeight;
end