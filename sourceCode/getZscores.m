function zScore = getZscores(timePoints, weights, childData)
% getZscores
% calculates the z scores for weights at different timepoints from 
% literature data
%
%   timePoints          a list of timePoints
%   weights             a list of corresponding weights
%   childData           literature data with the L, M and S values
%   zScore              the calculated zScore for the weights at the given
%                       timepoints
%
%   Avlant Nilsson, 2016-05-16
%
    L = childData(timePoints+1,2);
    M = childData(timePoints+1,3);
    S = childData(timePoints+1,4);
    % Equation at www.who.int/growthref/computation.pdf
    zScore = (((weights./M).^L)-1)./(L.*S);
end

