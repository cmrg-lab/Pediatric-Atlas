%% atlasViewer.m
% Created by: Sachin Govil
% Adapted and edited by: Anna Qi
% Visualizes and saves the shape variations created by varying the modes

%% Script
addpath("helpers")

load ../Data/EDESHCatlas.mat
scores = [-3, +3];
modes = [1,2,3,4,5,6,7,8,9,10];

et_indices = "../Data/ETIndices.txt";
output_folder = "../Images/pedatlas_characterization";

for j=1:length(modes)
    mode = modes(j);
    for i=1:length(scores)
        filename = strcat(output_folder,'/HC_modes/mode',num2str(uint8(mode)),'_',num2str(scores(i)),'.png');
        [EDmodel, ESmodel] = genEDESModels(EDESatlas,mode,scores(i));
        figure(i); clf
        hold on
        plotSurface(ESmodel, et_indices)
        plotWireframe(EDmodel, et_indices)
        set(gcf,'color','w');
        axis([-70 70 -70 70 -70 70])
        axis off;
        lighting gouraud
        camlight(80,20)
        %view(75,150) % top down view
        view(75,90); % default view
        camlight('right')
        camlight('left')
        plotValves(ESmodel, et_indices)
        hold off
        saveas(gcf,filename)
    end
end

%% plot mean shape

filename = strcat(output_folder,'/pedatlasHC_average_shape.png');
[EDmodel, ESmodel, ~] = genEDESModels(EDESatlas,0,0);
figure(1); clf
hold on
plotSurface(ESmodel, et_indices)
plotWireframe(EDmodel, et_indices)
set(gcf,'color','w');
axis([-70 70 -70 70 -70 70])
axis off;
lighting gouraud
camlight(80,20)
view(75,90)
camlight('right')
camlight('left')
plotValves(ESmodel, et_indices)
hold off
saveas(gcf,filename)