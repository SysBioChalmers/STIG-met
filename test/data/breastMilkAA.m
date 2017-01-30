function [result, labels]= breastMilkAA(weight, day)
% breastMilkAA
% Content of Amino Acids in Breast Milk from
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
'alanine'
'arginine'
'aspartate'
'cystine'
'glutamate'
'glycine'
'histidine'
'isoleucine'
'leucine'
'lysine'
'methionine'
'phenylalanine'
'proline'
'serine'
'threonine'
'tryptophan'
'tyrosine'
'valine'
};

molWeight = [
    89.0935
    174.2017
    133.1032
    121.159
    147.1299
    75.0669
    155.1552
    131.1736
    131.1736
    146.1882
    149.2124
    165.19
    115.131
    105.093
    119.1197
    204.2262
    181.1894
    117.1469
]; %http://www.webqc.org/aminoacids.php


timeIntervals = [2.5	7.5	15	54.5	134.5	272.5];
totalWeight = [1903.9	2077.1	1526.6	1183.8	996.1	957.5];

    
ratios = [
0.039	0.039	0.035	0.036	0.036	0.037
0.040	0.039	0.035	0.032	0.032	0.033
0.094	0.093	0.093	0.089	0.088	0.088
0.023	0.024	0.021	0.022	0.022	0.019
0.162	0.163	0.168	0.181	0.190	0.191
0.026	0.026	0.025	0.023	0.023	0.023
0.029	0.029	0.029	0.030	0.029	0.030
0.041	0.041	0.046	0.049	0.049	0.049
0.089	0.088	0.099	0.097	0.096	0.097
0.062	0.063	0.068	0.067	0.067	0.067
0.014	0.014	0.015	0.015	0.015	0.014
0.042	0.042	0.041	0.040	0.039	0.040
0.076	0.075	0.085	0.087	0.097	0.097
0.051	0.050	0.045	0.044	0.043	0.043
0.047	0.047	0.044	0.044	0.043	0.043
0.020	0.018	0.017	0.017	0.017	0.016
0.093	0.102	0.081	0.076	0.062	0.058
0.051	0.048	0.051	0.052	0.053	0.055
];

if day<timeIntervals(1)
    resultRatio = ratios(:,1);
    resultWeight = totalWeight(1);
elseif day>timeIntervals(end)
    resultRatio = ratios(:,end);
    resultWeight = totalWeight(end);
else
    resultRatio = interp1q(timeIntervals, ratios', day)';
    resultWeight = interp1q(timeIntervals, totalWeight', day);
end

result = resultRatio .* resultWeight .* 10/1000 .* weight;
result = result./molWeight;

end