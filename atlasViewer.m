%% atlasViewer.m
%  Created by: Sachin Govil
% Adapted and edited by: Anna Qi

%% Script
load Data/EDESHCatlas.mat
scores = [-3, +3];
modes = [1,2,3,4,5,6,7,8,9,10];

for j=1:length(modes)
    mode = modes(j);
    for i=1:length(scores)
        filename = strcat('Images/modes/mode',num2str(uint8(mode)),'_',num2str(scores(i)),'.png');
        [EDmodel, ESmodel] = genEDESModels(EDESatlas,mode,scores(i));
        figure(i); clf
        hold on
        plotSurface(ESmodel)
        plotWireframe(EDmodel)
        set(gcf,'color','w');
        axis([-70 70 -70 70 -70 70])
        axis off;
        lighting gouraud
        camlight(80,20)
        %view(75,150) % top down view
        view(75,90);
        camlight('right')
        camlight('left')
        plotValves(ESmodel)
        hold off
        %saveas(gcf,filename)
    end
end

%% plot mean shape

filename = strcat('Images/EDES_average_shape.png');
[EDmodel, ESmodel, ~] = genEDESModels(EDESatlas,0,0);
figure(1); clf
hold on
plotSurface(ESmodel)
plotWireframe(EDmodel)
set(gcf,'color','w');
axis([-70 70 -70 70 -70 70])
axis off;
lighting gouraud
camlight(80,20)
view(75,90)
camlight('right')
camlight('left')
plotValves(ESmodel)
hold off
saveas(gcf,filename)