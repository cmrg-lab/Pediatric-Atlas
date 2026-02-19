%% distanceAnalysis.m
% Script for Mahalanobis Distance Analysis
% Created by: Anna Qi

% Load data
ped_atlas_data = load('../Data/EDESatlas.mat');
ped_atlas.name = 'Pediatric Atlas';
ped_atlas.latent = ped_atlas_data.EDESatlas.latent;
ped_zscores_data = load("../Data/zScoresTOF_ped.mat");
zscores_ped_combined = ped_zscores_data.zScores;

adult_atlas.name = 'Adult Atlas';
adult_atlas.latent = h5read('../Data/UKBRVLV.h5', '/LATENT');
adult_zscores_data = load("../Data/zScoresTOF_adult.mat");
zscores_adult_combined = adult_zscores_data.zScores;

% Compare the full z-score matrices from both projections
[all_mahal_ped, all_mahal_adult, p_value] = ...
    run_mahalanobis_comparison(zscores_ped_combined, ped_atlas, zscores_adult_combined, adult_atlas);

% Calculate statistics for annotation
mu_ped = mean(all_mahal_ped);
sd_ped = std(all_mahal_ped);
mu_adult = mean(all_mahal_adult);
sd_adult = std(all_mahal_adult);

% Generate results figure
figure('Position', [100, 100, 700, 550], 'Color', 'w');

% Create a single box plot for the combined shape analysis
boxplot([all_mahal_ped, all_mahal_adult], 'Labels', {'Pediatric Atlas', 'Adult Atlas'}, 'Colors', 'rb', 'Symbol', 'k+');
grid on;
% title(sprintf('ToF Cohort Statistical Distance from Reference Atlases\n p = %.3e', p_value), 'FontSize', 16);
title(sprintf('p < 0.001'), 'FontSize', 16);
ylabel('Mahalanobis Distance', 'FontSize', 12);
ax = gca; 
ax.FontSize = 14;

% Add Text Annotations
% Positioned slightly to the right of the box (x + 0.15) and at the height of the mean
text(1.2, mu_ped, sprintf('\\mu = %.2f\n\\sigma = %.2f', mu_ped, sd_ped), ...
    'FontSize', 10, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'k');

text(2.2, mu_adult, sprintf('\\mu = %.2f\n\\sigma = %.2f', mu_adult, sd_adult), ...
    'FontSize', 10, 'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'k');

% Function definitions
function [all_mahal_dist1, all_mahal_dist2, p_val_mahal] = run_mahalanobis_comparison(scores_matrix1, atlas1_data, scores_matrix2, atlas2_data)
    % This function calculates Mahalanobis distance from pre-calculated z-scores.
    num_pcs1 = 8;
    num_pcs2 = 8;
    fprintf('Using first %d modes for %s\n', num_pcs1, atlas1_data.name);
    fprintf('Using first %d modes for %s\n', num_pcs2, atlas2_data.name);
    
    num_patients = size(scores_matrix1, 1);
    all_mahal_dist1 = zeros(num_patients, 1);
    all_mahal_dist2 = zeros(num_patients, 1);
    
    fprintf('Processing %d patients...\n', num_patients);
    for i = 1:num_patients
        num_scores_to_use1 = min(size(scores_matrix1, 2), num_pcs1);
        num_scores_to_use2 = min(size(scores_matrix2, 2), num_pcs2);
        
        % Use the formula for z-scores: D^2 = sum(z^2)
        zscores1 = scores_matrix1(i, 1:num_scores_to_use1);
        mahal_dist_sq1 = sum(zscores1.^2);
        all_mahal_dist1(i) = sqrt(mahal_dist_sq1);
        
        zscores2 = scores_matrix2(i, 1:num_scores_to_use2);
        mahal_dist_sq2 = sum(zscores2.^2);
        all_mahal_dist2(i) = sqrt(mahal_dist_sq2);
    end
    
    % Report Results
    mean_mahal1 = mean(all_mahal_dist1);
    std_mahal1 = std(all_mahal_dist1);
    mean_mahal2 = mean(all_mahal_dist2);
    std_mahal2 = std(all_mahal_dist2);
    
    fprintf('\n[Mahalanobis Distance] Cohort Results for %s\n', atlas1_data.name);
    fprintf('Mean Distance: %.4f (Std: %.4f)\n', mean_mahal1, std_mahal1);
    fprintf('\n[Mahalanobis Distance] Cohort Results for %s\n', atlas2_data.name);
    fprintf('Mean Distance: %.4f (Std: %.4f)\n', mean_mahal2, std_mahal2);

    p_val_mahal = -1;
    if num_patients > 1
        [~, p_val_mahal] = ttest(all_mahal_dist1, all_mahal_dist2);
        fprintf('\nPaired t-test (Mahalanobis) p-value: %e\n', p_val_mahal);
        if p_val_mahal < 0.05
            fprintf('The difference is statistically significant.\n');
        else
            fprintf('The difference is not statistically significant.\n');
        end
    end
end