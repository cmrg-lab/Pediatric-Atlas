%% plotVarianceExplained.m
% Plots variance explained by modes of the atlas
% Created by: Sachin Govil, adapted by Anna Qi

%% Script
load Data/EDESatlas.mat
nmodes = 30; %number of modes to plot

% plotting styles
FS = 14;
MS = 9;
LW = 1.5;
gray = [0.6,0.6,0.6];

figure(1); clf
hold on
plt1 = bar(1:nmodes,EDESatlas.explained(1:nmodes)','LineWidth',LW);
plt2 = stairs(0.4:(nmodes-0.6),cumsum(EDESatlas.explained(1:nmodes))','k-','LineWidth',LW);
xlabel('Mode')
ylabel('Shape Variance Explained (%)')
set(plt1,'FaceColor',gray); set(plt1,'EdgeColor','k');
set(gca,'FontSize',FS)
set(gca,'LineWidth',LW)
set(gca,'FontWeight','bold')
set(gcf,'color','w');
xlim([0,(nmodes+.5)])
xticks(5:5:35)
ylim([0,100])
yticks(0:10:100)

%% look at the cumulative and individual variances

T = table((1:nmodes)', cumsum(EDESHCatlas.explained(1:nmodes)), EDESHCatlas.explained(1:nmodes))

