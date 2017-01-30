function [result, labels] = breastMilkFA(weight, day)
% breastMilkFA
% Content of fatty acids in Breast Milk. Mass from
% Yamawaki, N., Yamada, M., Kan-no, T., Kojima, T., Kaneko, T., & Yonekubo,
% A. (2005). Macronutrient, mineral and trace element composition of breast
% milk from Japanese women. Journal of Trace Elements in Medicine and 
% Biology, 19, 171–181. doi:10.1016/j.jtemb.2005.05.001
%
% Ratios from
% Peng, Y. M., Zhang, T. Y., Wang, Q., Zetterström, R., & Strandvik, B.
% (2007). Fatty acid composition in breast milk and serum phospholipids of 
% healthy term Chinese infants during first 6 weeks of life. Acta 
% Pædiatrica, 96(11), 1640–1645. doi:10.1111/j.1651-2227.2007.00482.x
%
%   weight                  weight of milk
%   day                     age of infant
%   result                  content of metabolites in milk (in mol)
%   labels                  metabolite names
%   Avlant Nilsson, 2016-05-17
%   

labels = {
    '10:0'
    '12:0'
    '14:0'
    '15:0'
    '17:0'
    '16:0'
    '18:0'
    '20:0'
    '22:0'
    '24:0'
    '14:1n-9'
    '16:1n-7'
    '18:1n-9'
    '18:1n-7'
    '20:1n-9'
    '22:1n-9'
    '18:2n-6'
    '18:3n-6'
    '20:2n-6'
    '20:3n-6'
    '20:4n-6'
    '22:4n-6'
    '18:3n-3'
    '20:5n-3'
    '22:5n-3'
    '22:6n-3'
};

labels = {
    'decanoic acid'
    'lauric acid'
    'myristic acid'
    'pentadecylic acid'
    'margaric acid'
    'palmitate'
    'stearate'
    'eicosanoate'
    'behenic acid'
    'lignocerate'
    'physeteric acid'
    'palmitolate'
    'oleate'
    'cis-vaccenic acid'
    'cis-gondoic acid'
    'cis-erucic acid'
    'linoleate'
    'gamma-linolenate'
    '(11Z,14Z)-eicosadienoic acid'
    'dihomo-gamma-linolenate'
    'arachidonate'
    'adrenic acid'
    'linolenate'
    'EPA'
    'DPA'
    'DHA'
};


%http://toolbox.foodcomp.info/References/FattyAcids/Anders%20M%C3%B8ller%20%20-%20%20FattyAcids%20Molecular%20Weights%20and%20Conversion%20Factors.pdf
molWeights = [
    172.270
    200.1776
    228.2089
    242.2246
    270.2559
    256.2402
    284.2715
    312.3028
    340.3341
    368.3654
    226.1933
    254.2246
    282.2559
    282.2559
    310.2872
    338.3185
    280.2402
    278.2246
    308.2715
    306.2559
    304.2402
    332.2715
    278.2246
    302.2246
    330.2559
    328.2402
    ];

timeIntervals1 = [5 42];

fatPercent = [
    0	0
3.18	5.55
4.76	4.41
0	0
0	0
23.91	21.52
4.96	5.36
0.1	0.13
0.07	0.05
0.07	0.07
0.04	0.04
1.67	1.96
31.83	31.53
0	0
0	0
0	0
24.99	25.8
0.08	0.14
0.99	0.37
0.71	0.36
0.56	0.49
0	0
1.35	1.76
0	0
0	0
0.33	0.27
];


fatPercent = fatPercent./repmat(sum(fatPercent), size(fatPercent,1), 1); %Normalize

if day<timeIntervals1(1)
    result = fatPercent(:, 1);
elseif day>timeIntervals1(end)
    result = fatPercent(:, end);
else
    result = interp1q(timeIntervals1, fatPercent', day)';
end



timeIntervals2 = [2.5	7.5	15	54.5	134.5	272.5];
lipidContent = [2.68	2.77	3.9	3.75	3.2	3.17];

if day<timeIntervals2(1)
    lipidFactor = lipidContent(1);
elseif day>timeIntervals2(end)
    lipidFactor = lipidContent(end);
else
    lipidFactor = interp1q(timeIntervals2', lipidContent', day);
end
    
    result=result .* lipidFactor .* 10 .* weight;
    result=result./molWeights;
end

