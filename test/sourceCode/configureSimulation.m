function simSettings = configureSimulation(model, simLength, timeStep, parsimoniousFBA)
% configureSimulation
% Makes a struct controling how the simulation is run and the model to use.
% The settings are: The starting point, the time increments and if 
% parsimonious FBA should be used.
%
%   model             a model structure
%   simLength         the length of the simulation in days
%   timeStep          simulation increment in days
%   parsimoniousFBA   bolean should pFBA be used?
%   simSettings       a structure with the model and the settings
%
%   Avlant Nilsson, 2016-05-16
%
    simSettings.model = model; %The FBA model
    simSettings.length = simLength; %nr of days
    simSettings.timeStep = timeStep; %timeStep (days)
    
    %Run FBA solver in parsimonius mode
    simSettings.parsimonious = parsimoniousFBA;
end

