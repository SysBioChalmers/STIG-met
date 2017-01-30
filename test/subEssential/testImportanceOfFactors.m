%The purpose of this simulation is to identify the sequencial essentiallity
%of amino acids

clear
load('../../fbaModel/genericHuman2.mat')
addpath('../../sourcecode')
addpath('../../data')

timePoints = linspace(1, 180, 3);

results = zeros(length(timePoints), 5);


[rank, improvmentFactor, growthRate, label] = importanceRank(model, 30);

for i = 1:length(rank)
    currentMap = rank ==i;
    fprintf('%i\t%f\t%f\t%s\n', i, improvmentFactor(currentMap), growthRate(currentMap), label{currentMap})
end



