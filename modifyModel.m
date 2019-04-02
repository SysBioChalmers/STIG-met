%This loads the model, makes some changes (adds rxns, makes the rxn
%directionality uniform etc.) and saves the result as a matlab struct for
%future use.

%load Raven Model
addpath('sourceCode')
load('fbaModel/humanGEM.mat')
model = ihuman;
model = setupModel(model);

%Overwrite old model
save('fbaModel/genericHuman2', 'model')
