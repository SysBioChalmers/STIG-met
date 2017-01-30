%This loads the model, makes some changes (adds rxns, makes the rxn
%directionality uniform etc.) and saves the result as a matlab struct for
%future use.

%load Raven Model
addpath('sourceCode')
model = importExcelModel('fbaModel/HMRdatabase2_00.xlsx');
model = setupModel(model);

%Overwrite raven model
save('fbaModel/genericHuman2', 'model')
