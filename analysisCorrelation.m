%% analysisCorrelation.m
% Code to generate correlations between atlas scores and functional
% metrices
% Created by: Anna Qi

%% Script

load EDESHCatlas.mat
load ScoresShape.mat

nModes = 10;

% "MastersFile" is not included in the public github repository
patientInfo = readtable('Data/MastersFile.xlsx','PreserveVariableNames',true);
% convert categorical data to numerical data
[GN, ~, G] = unique(patientInfo{:,'Sex'});
patientInfo.Categorical_Sex = G;

patientRisks = ["age_in_months", "Height", "Weight", "BSA", "BMI", "diastolic blood pressure", ... 
   "systolic blood pressure", "Clinic Systolic BP", "Clinic Diastolic BP", "heart rate"];

risksTable = table2array(patientInfo(:,patientRisks));

[correlationMatrix, pValueMatrix] = corr(ScoresShape(:,1:nModes), risksTable, "Rows","pairwise");

categoricalVar = patientInfo.Categorical_Sex;

% t-test for sex
pSex = zeros(nModes, 1);
tSex = zeros(nModes, 1);
for i = 1:nModes
    [h,p,ci,stats] = ttest2(ScoresShape(categoricalVar == 1, i), ScoresShape(categoricalVar == 2, i));
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
colorbar;
clim([-1 1]);  % Set color range from -1 to 1
ax = gca;
ax.FontSize = 16; 
%xlabel('Measurements');
%ylabel('Principal Components');
%title('Bubble Chart of Correlations');

% Adjust axis labels
xticks(1:size(patientRisks')+1);
yticks(1:nModes);
xticklabels({'Age', 'Height', 'Weight', 'BSA', 'BMI', 'SBP (MRI)', 'DBP (MRI)', 'SBP (Clinical)', 'DBP (Clinical)', 'Heart Rate', 'Sex'});
yticklabels(strcat('Mode ', string(1:nModes)));
xtickangle(45);
grid on;

% Add black outlines for p-values < 0.05
significantIdx = pValues < 0.05;
hold on;
scatter(col(significantIdx), row(significantIdx), bubbleSizes(significantIdx)*320, ...
    'k', 'LineWidth', 1.5, 'MarkerEdgeColor', 'k'); % Black outlines
hold off;

%% Bubble Chart for the Measurements

% omitted RV mass
patientMeasures = ["LVEDV index to BSA", "LVESV index to BSA", "RV EDV index to BSA", ... 
    "RV ESV index to BSA", "LV stroke volume", "RV stroke volume", "LVEF", ...
    "RV EF", "LV Mass index to BSA", "RV/LV EDV", "LVM/LV EDV"];

measuresTable = table2array(patientInfo(:,patientMeasures));

[correlationMatrix, pValueMatrix] = corr(ScoresShape(:,1:nModes), measuresTable, "Rows","pairwise");

% Convert the matrix to row-column-value format for plotting
[row, col] = find(~isnan(correlationMatrix));
correlationValues = correlationMatrix(sub2ind(size(correlationMatrix), row, col));
pValues = pValueMatrix(sub2ind(size(pValueMatrix), row, col));

% Define size and color for the bubbles
bubbleSizes = -log(pValues);

bubbleColors = correlationValues*1.9;  % Color represents the correlation value

% Create Bubble Chart
figure(1);
bubblechart(col, row, bubbleSizes, bubbleColors);

% Customize the chart appearance
colorbar;
clim([-1 1]);  % Set color range from -1 to 1
ax = gca;
ax.FontSize = 16; 
%xlabel('Measurements');
%ylabel('Principal Components');
%title('Bubble Chart of Correlations');

% Adjust axis labels
xticks(1:size(patientMeasures'));
% yticks(1:nModes);
xticklabels({'LV EDV_i', 'LV ESV_i', 'RV EDV_i', 'RV ESV_i', 'LV SV', 'RV SV', 'LV EF', 'RVEF', 'LV Mass_i', "RV/LV EDV", "LVM/LV EDV"});
yticklabels(strcat('Mode ', string(1:nModes)));
xtickangle(45);
grid on;

% Add black outlines for p-values < 0.05
significantIdx = pValues < 0.05;
hold on;
scatter(col(significantIdx), row(significantIdx), bubbleSizes(significantIdx)*260, ...
    'k', 'LineWidth', 1.5, 'MarkerEdgeColor', 'k'); % Black outlines
hold off;