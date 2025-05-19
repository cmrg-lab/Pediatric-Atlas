%% genZScores.m
% Created by: Sachin Govil
% Adapted by Anna Qi

%% Script
load EDESHCatlas.mat
ScoresShape = zeros(size(EDESHCatlas.score));

for i=1:size(EDESHCatlas.score,2)
    ScoresShape(:,i) = EDESHCatlas.score(:,i)/sqrt(EDESHCatlas.latent(i));
end

save('ScoresShape','ScoresShape');

%% Plot boxplots for first 10 shape modes

load ScoresShape.mat

% plot boxplots of median + interquartile ranges
boxplot(ScoresShape(:,1:10), 'Labels', {'1', '2', '3', ...
    '4', '5', '6', '7', '8', '9', '10'}, 'Whisker', 1)
xlabel("Shape Modes")
ylabel("Shape Scores")
title("Box Plots of first 10 shape modes")