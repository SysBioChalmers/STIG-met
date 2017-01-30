function results = makeFatModel(baseModel, deviation)
% makeFatModel
% Loads the fat ratios kg fat/ kg infant (values between 0 and 1) from the
% file. And multiply with some deviation (normally 1, ak do nothing).
%
%   baseModel              a list of values between 0 and 1. first column
%                          contains the days starting from 1
%   deviation              could be used to investigate shifts in fat ratio
%   results                a list of ratios, one value for each day
%
%   Avlant Nilsson, 2016-05-16
%

    results = load(baseModel);
    results(:,2) = results(:,2) * deviation;
    results(:,1) = [];
end

