function maintainance = estimateMaintenance(curWeight, FM, individual, activityCost)
% estimateMaintenance
% Calculates the 3 contributions to maintainance. Fat free mass (FFM), Fat
% mass (FM) and activity.
%
%   curWeight      the mass of the infant (in gram)
%   FM             the fat mass of the infant (in gram)
%   individual      an individual structure
%   activityCost    the cost of activity in kcal/kg
%   maintainance    an array with the 3 contributions in kcal
%
%   Avlant Nilsson, 2016-05-16
%

    FFM = curWeight - FM;
    maintainance = zeros(1,3);
    maintainance(1) = individual.leanMassMaintenance * FFM/1000;
    maintainance(2) = individual.fatMassMaintenance * FM/1000;
    maintainance(3) = activityCost * curWeight/1000;    
end

