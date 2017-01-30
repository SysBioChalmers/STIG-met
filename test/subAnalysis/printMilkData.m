%Output the milk function

timePoints = 0:7;

[food, foodLabels] = breastMilkData(1, 1);

results = zeros(length(foodLabels), length(timePoints));

for i = 1:length(timePoints)
   day = i*30;
   results(:, i) = breastMilkData(1, day);
end

for i = 1:length(foodLabels)
   fprintf('%s',  foodLabels{i})
   for j = 1:length(timePoints)
       fprintf('\t%f',  results(i,j))
   end
   fprintf('\n')
end