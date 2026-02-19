%% analyzeCorrelations.m
% Code to generate correlations between atlas scores and functional
% metrices
% Created by: Anna Qi

%% Script

addpath("helpers/")

load ../Data/ScoresShapeHC.mat
nModes = 11;
imageOutput = "../Images/pedatlas_characterization";

% "MastersFile" is not included in the public github repository since it
% contains patient-specific data. Can be shared upon request if the user
% has permissions with the CAP project
patientInfo = readtable('../Data/MastersFile.xlsx','PreserveVariableNames',true);

% convert categorical data to numerical data
[GN, ~, G] = unique(patientInfo{:,'Sex'});
patientInfo.Categorical_Sex = G;

patientRisks = ["Age", "Height", "Weight", "BSA", "BMI", "MRI SBP", ... 
"MRI DBP", "Clinic SBP", "Clinic DBP", "Heart Rate", "LVEDV index to BSA", ...
   "LVESV index to BSA", "RV EDV index to BSA", ... 
   "RV ESV index to BSA", "LV SV indexed to BSA", "RV SV indexed to BSA", "LVEF", ...
   "RV EF", "LV Mass index to BSA", "RV/LV EDV", "LV Mass/EDV"];

risksTable = table2array(patientInfo(:,patientRisks));

[correlationMatrix, pValueMatrix] = corr(ScoresShape(:,1:nModes), risksTable, "Rows","pairwise");

categoricalVar = patientInfo.Categorical_Sex;

% t-test for sex
pSex = zeros(nModes, 1);
tSex = zeros(nModes, 1);
for i = 1:nModes
    [h,p,ci,stats] = ttest2(ScoresShape(categoricalVar == 1, i), ...
        ScoresShape(categoricalVar == 2, i));
    pSex(i) = p;
    tSex(i) = stats.tstat;
end

correlationMatrix = [correlationMatrix zeros(length(tSex),1)];
pValueMatrix = [pValueMatrix pSex];

% Convert the matrix to row-column-value format for plotting
[row, col] = find(~isnan(correlationMatrix));
correlationValues = correlationMatrix(sub2ind(size(correlationMatrix), row, col));
pValues = pValueMatrix(sub2ind(size(pValueMatrix), row, col));

% Clip sizes to ensure valid values
bubbleSizes = -log(pValues);
bubbleColors = correlationValues;  % Color represents the correlation value

% Create Bubble Chart
figure(1);
bubblechart(col, row, bubbleSizes, bubbleColors);

% Customize the chart appearance
% Set the color limits to be symmetric around 0
maxAbsCor = max(abs(bubbleColors)); 
clim([-maxAbsCor maxAbsCor]);
colorbar;
ax = gca;
ax.FontSize = 18; 
%xlabel('Measurements');
%ylabel('Principal Components');
%title('Bubble Chart of Correlations');

% Adjust axis labels
xticks(1:size(patientRisks,2)+1);
yticks(1:nModes);
xticklabels({'Age', 'Height', 'Weight', 'BSA', 'BMI', 'SBP (MRI)', 'DBP (MRI)', ...
    'SBP (Clinical)', 'DBP (Clinical)', 'Heart Rate', 'LV EDV_i', 'LV ESV_i', ...
    'RV EDV_i', 'RV ESV_i', 'LV SV_i', 'RV SV_i', 'LV EF', 'RVEF', 'LV Mass_i', ...
    "RV/LV EDV", "LVM/LV EDV", 'Sex'});
yticklabels(strcat('Mode ', string(1:nModes)));
xtickangle(45);
grid on;

% Add black outlines for p-values < 0.05
significantIdx = pValues < 0.05;
hold on;
bubbleFactor = 200;
scatter(col(significantIdx), row(significantIdx), bubbleSizes(significantIdx)*bubbleFactor, ...
    'k', 'LineWidth', 1.5, 'MarkerEdgeColor', 'k'); % Black outlines
hold off;

% Save high-quality figure
f = gcf;
exportgraphics(f, imageOutput + '/pedAtlasHC_correlations.jpg', 'Resolution', 330)