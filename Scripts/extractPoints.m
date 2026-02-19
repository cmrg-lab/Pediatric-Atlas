%% extractPoints.m
% Created by: Sachin Govil
% Edited by Anna Qi
% Extract ED and ES points from the model files.
%
% This script is included for examples sake. The Matlab objects used to
% rerun this script isn't included for privacy.

%% Script
addpath("helpers/")
in_dir = "Models/";
listing = dir(in_dir);
nModels = size(listing,1)-2;
pts = zeros(nModels,5810*3);
meshPath = "../Data/MeshFiles";

for i=1:nModels
    if i==1
        disp(strcat(in_dir,listing(i+2).name));
        CoarseMesh = textread(strcat(in_dir,listing(i+2).name));
        model = Subdivision_Surface(CoarseMesh,meshPath);
        model = model.etPos;
        centroid = mean(model);
        model = model-centroid;
        pts(i,:) = reshape(model',1,[]);
        FirstModel = model;
    elseif i==2
        CoarseMesh = textread(strcat(in_dir,listing(i+2).name));
        model = Subdivision_Surface(CoarseMesh,meshPath);
        model = model.etPos;
        model = model-centroid;
        pts(i,:) = reshape(model',1,[]);
    elseif mod(i,2)==1
        CoarseMesh = textread(strcat(in_dir,listing(i+2).name));
        model = Subdivision_Surface(CoarseMesh,meshPath);
        model = model.etPos;
        centroid = mean(model);
        model = model-centroid;
        [~,~,transform] = procrustes(FirstModel,model);
        T = transform.c;
        R = transform.T;
        model = model*R+T;
        pts(i,:) = reshape(model',1,[]);
    elseif mod(i,2)==0
        CoarseMesh = textread(strcat(in_dir,listing(i+2).name));
        model = Subdivision_Surface(CoarseMesh,meshPath);
        model = model.etPos;
        model = model-centroid;
        model = model*R+T;
        pts(i,:) = reshape(model',1,[]);
    end
end

ptsED = pts(1:2:end,:);
ptsES = pts(2:2:end,:);
save('unalignedPts','ptsED','ptsES');