%% genAtlas.m
% Created by: Sachin Govil
% Edited by Anna Qi
% Generate a statistical shape atlas using pca
% 
% This script is included for examples sake. The Matlab objects used to
% rerun this script isn't included for privacy.

%% Script
load Matlab_objects/alignedPtsTOF_self.mat
%pts = ptsED;
pts = [ptsED ptsES];

[coeff,score,latent,tsquared,explained,mean] = pca(pts,'Algorithm','eig');
EDESatlas = struct('coeff',coeff,'score',score,'latent',latent,'tsquared',tsquared,'explained',explained,'mean',mean);

save('Matlab_objects/EDESatlas_TOF','EDESatlas');