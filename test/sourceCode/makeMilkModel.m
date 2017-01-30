function results = makeMilkModel(baseModel, deviation)
% makeMilkModel
% Load the milk model from the file and multiply with some deviation
%
%   baseModel         a vector containing days in column 1 and milk amounts
%                     in column 2 (ml/day).
%   deviation         a factor to multiply the milk with, typically 1.
%   result            a list of milk intakes for each day.
%
%   Avlant Nilsson, 2016-05-16
%
    results = load(baseModel);
    results(:,2) = results(:,2) * deviation;
    results(:,1) = [];
end
