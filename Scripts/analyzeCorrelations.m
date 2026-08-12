%% analyzeCorrelations.m
% Code to generate correlations between atlas scores and functional
% metrices
% Created by: Anna Qi

%% Script

addpath("helpers/")

load ../Data/ScoresShape.mat
nModes = 8;

% "MastersFile" is not included in this public github repository since it
% contains patient-specific data. I can share it upon request if the user
% has permissions with the CAP project
patientInfo = readtable('../Data/MastersFile.xlsx','PreserveVariableNames',true);

% convert categorical data to numerical data
[~, ~, G] = unique(patientInfo{:,'Sex'});
patientInfo.Categorical_Sex = G;

patientRisks = ["Age", "Height", "Weight", "BSA", "BMI", "MRI SBP", ... 
"MRI DBP", "Clinic SBP", "Clinic DBP", "Heart Rate", "LVEDV index to BSA", ...
   "LVESV index to BSA", "RV EDV index to BSA", ... 
   "RV ESV index to BSA", "LV SV indexed to BSA", "RV SV indexed to BSA", "LVEF", ...
   "RV EF", "LV Mass index to BSA", "RV/LV EDV", "LV Mass/EDV"];

risksTable = table2array(patientInfo(:,patientRisks));

[correlationMatrix, pValueMatrix] = corr(ScoresShape(:,1:nModes), risksTable, ...
    "Rows", "pairwise", ...
    "Type", "Spearman");
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

% size = significance, but capped so extreme p-values don't dominate
CAP = 8; % cap at p = 1e-8
bubbleSizes  = min(-log10(pValues), CAP);
bubbleColors = correlationValues; % Color represents the correlation value

% Create Bubble Chart
figure(1);
bc = bubblechart(col, row, bubbleSizes, bubbleColors);
bc.MarkerEdgeColor = [0.75 0.78 0.82]; % subtle outline on every bubble

% Customize the chart appearance
colormap(gca, divbwr(256)); % diverging color scheme
clim([-1 1]);
colorbar;

% Adjust axis labels
ax = gca; 
ax.FontSize = 18;
xticks(1:size(correlationMatrix,2)); 
yticks(1:nModes);
xticklabels({'Age', 'Height', 'Weight', 'BSA', 'BMI', 'SBP (MRI)', 'DBP (MRI)', ...
    'SBP (Clinical)', 'DBP (Clinical)', 'Heart Rate', 'LV EDV_i', 'LV ESV_i', ...
    'RV EDV_i', 'RV ESV_i', 'LV SV_i', 'RV SV_i', 'LV EF', 'RVEF', 'LV Mass_i', ...
    "RV/LV EDV", "LVM/LV EDV", 'Sex'});
yticklabels(strcat('Mode ', string(1:nModes)));
xtickangle(45); grid on;

% Tight cells, then size bubbles automatically size
axis(ax, [0.5, size(correlationMatrix,2)+0.5, 0.5, nModes+0.5]);
drawnow; % force Position to update
oldU = ax.Units; 
ax.Units = 'points';
pos  = ax.Position; 
ax.Units = oldU; % axes size in points
ptsPerCell = min(pos(3)/diff(xlim), pos(4)/diff(ylim));
maxDiam    = 0.97 * ptsPerCell; % < 1 cell so bubbles can never touch
bubblesize(ax, [0.15*maxDiam, maxDiam]);
bubblelim(ax, [0 CAP]);

% Add black outlines for p-values < 0.05
hold on
sigIdx = pValues < 0.05;
bc2 = bubblechart(col(sigIdx), row(sigIdx), bubbleSizes(sigIdx));
bc2.MarkerFaceAlpha = 0; % hollow
bc2.MarkerEdgeColor = 'k';
bc2.LineWidth = 1.4;
hold off

% Save high-quality figure
exportgraphics(ax, '../Images/pedatlas_characterization/pedAtlas_correlations.jpg', 'Resolution', 330)

%% Correlations - BSA-residualized

load ../Data/ScoresShape.mat
nModes = 8;

patientInfo = readtable('../Data/MastersFile.xlsx','PreserveVariableNames',true);
% convert categorical data to numerical data
[~, ~, G] = unique(patientInfo{:,'Sex'});
patientInfo.Categorical_Sex = G;

patientRisks = ["Age", "Height", "Weight", "BMI", "MRI SBP", ... 
"MRI DBP", "Clinic SBP", "Clinic DBP", "Heart Rate", "LVEDV index to BSA", ...
   "LVESV index to BSA", "RV EDV index to BSA", ... 
   "RV ESV index to BSA", "LV SV indexed to BSA", "RV SV indexed to BSA", "LVEF", ...
   "RV EF", "LV Mass index to BSA", "RV/LV EDV", "LV Mass/EDV"];

risksTable = table2array(patientInfo(:,patientRisks));
Y = [risksTable, patientInfo.Categorical_Sex]; % all variables (Sex included)
Z = patientInfo{:, "BSA"}; % covariate we control for

% partial correlations controlling for BSA
[correlationMatrix, pValueMatrix] = partialcorr(ScoresShape(:,1:nModes), Y, Z, ...
                                                "Rows", "pairwise", ...
                                                "Type", "Spearman");

% Convert the matrix to row-column-value format for plotting
[row, col] = find(~isnan(correlationMatrix));
correlationValues = correlationMatrix(sub2ind(size(correlationMatrix), row, col));
pValues = pValueMatrix(sub2ind(size(pValueMatrix), row, col));

% size = significance, but capped so extreme p-values don't dominate
CAP = 8; % cap at p = 1e-8
bubbleSizes  = min(-log10(pValues), CAP);
bubbleColors = correlationValues; % Color represents the correlation value

% Create Bubble Chart
figure(1);
bc = bubblechart(col, row, bubbleSizes, bubbleColors);
bc.MarkerEdgeColor = [0.75 0.78 0.82]; % subtle outline on every bubble

% Customize the chart appearance
colormap(gca, divbwr(256)); % diverging color scheme
clim([-1 1]);
colorbar;

% Adjust axis labels
ax = gca; 
ax.FontSize = 18;
xticks(1:size(correlationMatrix,2)); 
yticks(1:nModes);
xticklabels({'Age', 'Height', 'Weight', 'BMI', 'SBP (MRI)', 'DBP (MRI)', ...
    'SBP (Clinical)', 'DBP (Clinical)', 'Heart Rate', 'LV EDV_i', 'LV ESV_i', ...
    'RV EDV_i', 'RV ESV_i', 'LV SV_i', 'RV SV_i', 'LV EF', 'RVEF', 'LV Mass_i', ...
    "RV/LV EDV", "LVM/LV EDV", 'Sex'});
yticklabels(strcat('Mode ', string(1:nModes)));
xtickangle(45); grid on;

% Tight cells, then size bubbles automatically size
axis(ax, [0.5, size(correlationMatrix,2)+0.5, 0.5, nModes+0.5]);
drawnow; % force Position to update
oldU = ax.Units; 
ax.Units = 'points';
pos  = ax.Position; 
ax.Units = oldU; % axes size in points
ptsPerCell = min(pos(3)/diff(xlim), pos(4)/diff(ylim));
maxDiam    = 0.97 * ptsPerCell; % < 1 cell so bubbles can never touch
bubblesize(ax, [0.15*maxDiam, maxDiam]);
bubblelim(ax, [0 CAP]);

% Add black outlines for p-values < 0.05
hold on
sigIdx = pValues < 0.05;
bc2 = bubblechart(col(sigIdx), row(sigIdx), bubbleSizes(sigIdx));
bc2.MarkerFaceAlpha = 0; % hollow
bc2.MarkerEdgeColor = 'k';
bc2.LineWidth = 1.4;
hold off

% Save high-quality figure
exportgraphics(ax, '../Images/pedatlas_characterization/pedAtlas_correlations_bsa_adjusted.jpg', 'Resolution', 330)

%% Diverging color bar 

function cmap = divbwr(m)
    if nargin < 1, m = 256; end
    blue = [0.23 0.30 0.75];  white = [0.90 0.90 0.90];  red = [0.71 0.07 0.16];
    x = linspace(0, 1, m)';
    lo = x <= 0.5;  t = zeros(m,1);
    t(lo)  = x(lo)/0.5;      cmap(lo,:)  = (1-t(lo)).*blue  + t(lo).*white;
    t(~lo) = (x(~lo)-0.5)/0.5; cmap(~lo,:) = (1-t(~lo)).*white + t(~lo).*red;
end