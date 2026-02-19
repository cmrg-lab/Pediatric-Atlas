%% compareCohorts.m
% Compare shape scores of participants in two different cohorts
% Created by: Anna Qi

%% Script

load ../Data/EDESatlas.mat
load ../Data/ScoresShape.mat

patientInfo = readtable('../Data/MastersFile.xlsx','PreserveVariableNames',true);

% Compare women and men
%males = patientInfo(strcmp(patientInfo.Sex, 'Male'), :);
%females = patientInfo(strcmpi(patientInfo.Sex, 'Female'), :);

%maleIndexes = find(strcmp(patientInfo.Sex, 'Male'));
%femaleIndexes = find(strcmp(patientInfo.Sex, 'Female'));

%maleScores = ScoresShape(maleIndexes,:);
%femaleScores = ScoresShape(femaleIndexes,:);

% Compare BMI >= 35 and less than
highBMI = patientInfo(patientInfo.BMI >= 30, :);
lowBMI = patientInfo(patientInfo.BMI < 30, :);

highBMIIndexes = find(patientInfo.BMI >= 30);
lowBMIIndexes = find(patientInfo.BMI < 30);

highBMIScores = ScoresShape(highBMIIndexes,:);
lowBMIScores = ScoresShape(lowBMIIndexes,:);

%% Plot and compare the scores of two cohorts

nModes = 11;
mean_1 = mean(highBMIScores(:, 1:nModes), 1);
mean_2 = mean(lowBMIScores(:, 1:nModes), 1);

% Plot group means
figure;
bar_data = [mean_1; mean_2]';
bar_handle = bar(bar_data);
legend({'BMI >= 30', 'BMI < 30'});
xlabel('Shape Mode');
ylabel('Mean Score');
title('Shape Mode Scores: BMI');
grid on;
hold on;

% Statistical test and p-value annotation
p_values = nan(1, nModes);
y_offset = max(max(bar_data)) * 0.05; % height offset for text

for i = 1:nModes
    % Perform t-tests comparing the scores of the two cohorts
    [~, p] = ttest2(highBMIScores(:,i), lowBMIScores(:,i));
    p_values(i) = p;

    % Get bar top for text placement
    y_max = max(mean_1(i), mean_2(i));

    % Annotate p-value
    p_text = sprintf('p = %.3f', p);

    % Mark significance with a red color
    if p < 0.05
        text(i, y_max + y_offset, p_text, 'HorizontalAlignment', 'center', 'Color', 'Red', 'FontSize', 10);
    else
        text(i, y_max + y_offset, p_text, 'HorizontalAlignment', 'center', 'FontSize', 10);
    end
end
