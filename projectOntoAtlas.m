%% projectOntoAtlas.m
% Projects pediatric models (unalignedPts.mat) against an adult atlas
% Created by: Anna Qi

%% Script
load unalignedPts.mat

pts = [ptsED ptsES];
nModels = size(pts,1);
nModes = 10;

% read the principal components of the adult atlas
coeff = h5read('UKBRVLV.h5', '/COEFF');
% read the eigenvalues
latent = h5read('UKBRVLV.h5', '/LATENT');
% read the mean shape
mean = h5read('UKBRVLV.h5', '/MU');

zScores = zeros(nModels, nModes);

for i=1:nModels
    patient = pts(i,:);
    patient3D = reshape(patient,3,[])';

    mean3D = reshape(mean,3,[])';
    
    [~,~,transform] = procrustes(mean3D,patient3D);
    T = transform.c;
    R = transform.T;
    
    patient3Daligned = patient3D*R+T;
    patient1Daligned = reshape(patient3Daligned',1,[]);
    projectedScores = ((patient1Daligned - mean)*(coeff(:,1:nModes))./sqrt(latent(1:nModes)'));

    zScores(i,:) = projectedScores;
end

%% Visualize scores as boxplots

% Preallocate for storing p-values
pValues = zeros(1, nModes);

% Perform one-sample t-test for each shape mode
for i = 1:nModes
    [~, pValues(i)] = ttest(zScores(:, i), 0);  % Test against mean of 0
end

% Display the p-values
disp('P-values for each shape mode:');
disp(array2table(pValues, 'VariableNames', strcat('Mode_', string(1:nModes))));

figure;
boxplot(zScores, 'Labels', strcat('Mode ', string(1:nModes)));

% Customize plot appearance
%xlabel('Shape Modes');
ylabel('Z-Score');
set(gca,'FontSize',14);
yline(0,'k','LineWidth',2,'HandleVisibility','off')
grid on;
ylim([-6, 6]);

% Annotate p-values on the plot
hold on;
for i = 1:nModes
    yPos = prctile(zScores(:, i), 85) + 0.7;  % Arbitrary position above each boxplot
    if pValues(i) < 0.05
        text(i, yPos, sprintf('p=%.3f', pValues(i)), 'HorizontalAlignment', 'center', 'Color', 'red', 'FontSize', 11);
    else
        text(i, yPos, sprintf('p=%.3f', pValues(i)), 'HorizontalAlignment', 'center', 'Color', 'black', 'FontSize', 11);
    end
end
hold off;
