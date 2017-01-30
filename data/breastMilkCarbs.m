function [result, labels] = breastMilkCarbs(weight, day)
% breastMilkCarbs
% Content of Amino Acids in Breast Milk from
% Yamawaki, N., Yamada, M., Kan-no, T., Kojima, T., Kaneko, T., & Yonekubo,
% A. (2005). Macronutrient, mineral and trace element composition of breast
% milk from Japanese women. Journal of Trace Elements in Medicine and 
% Biology, 19, 171–181. doi:10.1016/j.jtemb.2005.05.001
%
% non lactose sugars were taken as glucose.
%
%   weight                  weight of milk
%   day                     age of infant
%   result                  content of metabolites in milk (in mol)
%   labels                  metabolite names
%   Avlant Nilsson, 2016-05-17
%    
labels = {
    'lactose'
    'glucose'
};



timeIntervals = [2.5	7.5	15	54.5	134.5	272.5];

totalCarb = [7.13	7.6	7.48	7.58	7.61	7.53];
lactose = [5.59	5.88	5.92	6.4	6.62	6.46];
glucose = totalCarb - lactose;

molWeights = [
    342.3 %lactose
    180.16 %glucose
    ];


if day<timeIntervals(1)
    result = [
        lactose(1);
        glucose(1);
    ];
elseif day>timeIntervals(end)
    result = [
        lactose(end);
        glucose(end);
    ];
else
    result =  [
        interp1q(timeIntervals, lactose', day);
        interp1q(timeIntervals, glucose', day);
    ];
end

%Convert from g/100g to g/1000 g
result = result * 10 * weight;


result = result./molWeights;
end


