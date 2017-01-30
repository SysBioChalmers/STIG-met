function referenceData = makeReferenceObject(weightData, fatData, zScore, heightData, heightZscore)
% makeReferenceObject
% Loads text files with reference data from literature for comparison in
% plotResults
%
%   weightData          weight of infant in kg [col 1]: age (in days) 
%                       [col 2,3,4,5,6]: 5:centile, 25:centile, 
%                       50:centile, 75:centile and 95:centile
%   fatData             fat weight of infant [col 1]: age (in months),
%                       [col 2], weight (in grams), [col 3] fat (in grams)
%                       [col 4] 2SD of fat (in grams).
%   zScore              data for Z-score calculations [col 1] age (in days)
%                       [col 2] L value [col 3] M value [col 4] S value.
%   heightData          as weight data but with height in cm.
%   referenceData       A struct conting the reference data
%
%   Avlant Nilsson, 2016-05-16
%
    referenceData.weight = load(weightData);
    if nargin>1
        referenceData.fat = load(fatData);
    end
    if nargin>2
        referenceData.zscore = load(zScore);
    end
    if nargin>3
        referenceData.height = load(heightData);
    end    
    if nargin>4
        referenceData.zscoreheight = load(heightZscore);
    end        
end

