%% alignPoints.m
% Created by: Sachin Govil
% Edited by: Anna Qi
% Align ED and ES points onto the same axis
%
% This script is included for examples sake. The Matlab objects used to
% rerun this script isn't included for privacy.

%% Script
load unalignedPts.mat

meanED = mean(ptsED);
meanED3D = reshape(meanED,3,[])';
alignedptsED = zeros(size(ptsED));
alignedptsES = zeros(size(ptsES));
nModels = size(ptsED,1);

scalingFactors = zeros(size(nModels));

for i=1:nModels
    patientED = ptsED(i,:);
    patientED3D = reshape(patientED,3,[])';
    patientES = ptsES(i,:);
    patientES3D = reshape(patientES,3,[])';
    
    [~,~,transform] = procrustes(meanED3D,patientED3D);
    T = transform.c;
    R = transform.T;

    scalingFactors(i) = transform.b;
    
    patientED3Daligned = patientED3D*R+T;
    patientES3Daligned = patientES3D*R+T;

    alignedptsED(i,:) = reshape(patientED3Daligned',1,[]);
    alignedptsES(i,:) = reshape(patientES3Daligned',1,[]);
end

ptsED = alignedptsED;
ptsES = alignedptsES;
save('alignedPts','ptsES','ptsED')

%% Adjust against heights

patientInfo = readtable('../Data/MastersFile.xlsx','PreserveVariableNames',true);
heights = table2array(patientInfo(:, "Height"));

% Fit a linear model
linearModel = fitlm(heights, scalingFactors);

% Display the regression result
disp(linearModel);

% Plot the results
figure;
scatter(heights, scalingFactors, 'filled');
hold on;
plot(heights, predict(linearModel, heights), 'r-', 'LineWidth', 2);
xlabel('Height (cm)');
ylabel('Procrustes Scale Factor');
title('Height vs Procrustes Scale Factor');
legend('Observed Data', 'Fitted Line');
grid on;

predictedScale = predict(linearModel, heights);
patientInfo.heightFactor = predictedScale;

% writetable(patientInfo,'Data/MastersFile.csv','Delimiter',',')  

%% Scale for height
load unalignedPts.mat

meanED = mean(ptsED);
meanED3D = reshape(meanED,3,[])';
alignedptsED = zeros(size(ptsED));
alignedptsES = zeros(size(ptsES));
nModels = size(ptsED,1);

% load in height linear scaling factor
% patientInfo = readtable('Data/MastersFile.csv','PreserveVariableNames',true);
heights = patientInfo{:,"heightFactor"};

scalingFactors = zeros(size(nModels));

for i=1:nModels
    patientED = ptsED(i,:);
    patientED3D = reshape(patientED,3,[])';
    patientES = ptsES(i,:);
    patientES3D = reshape(patientES,3,[])';
    
    [~,~,transform] = procrustes(meanED3D,patientED3D);
    T = transform.c;
    R = transform.T;

    scalingFactors(i) = transform.b;
    
    patientED3Daligned = patientED3D*R+T;
    patientES3Daligned = patientES3D*R+T;

    % correct for heights
    patientED3Daligned = heights(i) * patientED3Daligned;
    patientES3Daligned = heights(i) * patientES3Daligned;

    alignedptsED(i,:) = reshape(patientED3Daligned',1,[]);
    alignedptsES(i,:) = reshape(patientES3Daligned',1,[]);
end

ptsED = alignedptsED;
ptsES = alignedptsES;
save('alignedHCPts','ptsES','ptsED')