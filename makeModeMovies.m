%makeModeMovies.m
% modified 1029-10-04 AAY for template code from Charlene
%         obj.SurfaceStartEnd = [ 1,3072;       % LV (faces 1 to 3072 belong to the LV chamber...)
%                                     3073,4480;    % RVS
%                                     4481,6752;    % RVFW
%                                     6753,11616;   % Epi
%                                     11617,11664;  % Mitral 
%                                     11665,11688;  % Aortic valve
%                                     11689,11728;  % Tricuspid valve
%                                     11729,11760]; % Pulmonary valve

clearvars;
close all;

load('EDESHCatlas.mat');
path = 'Images/movies/';
nModes = size(EDESHCatlas.latent,1); 

%% plot surfaces and save to png

%calculate vertices
for nview = 1:3 %three viewpoints
  for mode=1:10 %10 modes
    for s=[-3,3]
        shapes = EDESHCatlas.mean + s* sqrt(EDESHCatlas.latent(mode)) * EDESHCatlas.coeff(:,mode)';
        S = [shapes(1:3:end)',shapes(2:3:end)',shapes(3:3:end)'];

        ED_Shape = S(1:5810,:);
        ES_Shape = S(5811:end,:);

        ETIndices = importdata('./Data/ETIndices.txt');

        h=figure('Position',[0 0 900 900],'visible','off'); %set visible to off for faster processing
        axis equal manual % this ensures that getframe() returns a consistent size
            xlim([-90,90]);
            ylim([-90,90]);
            zlim([-90,90]);
        switch nview
            case 1, view(55,55); %anterior view
            case 2, view(55,-125) %posterior view
            case 3, view(55,-200) %basal view
        end
        camlight('headlight');
        light('Position',[0 -1 0]);
        material shiny;
        lighting gouraud ;
        axis off;

        %patch('Faces',ETIndices,'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0.1,0.1,0.9],'EdgeAlpha',0.3); % RVLV
        patch('Faces',ETIndices(1:3072,:),'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0, 0.5, 0],'FaceAlpha',0.0,'EdgeAlpha',0.1); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0, 0, 0.8],'FaceAlpha',0.0,'EdgeAlpha',0.1); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0.5, 0, 0],'FaceAlpha',0.0,'EdgeAlpha',0.1); % epi

        %patch('Faces',ETIndices,'Vertices',ES_Shape,'FaceColor','none','EdgeColor',[0.1,0.9,0.1],'EdgeAlpha',0.3); % RVLV
        patch('Faces',ETIndices(1:3072,:),'Vertices',ES_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',0.0); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ES_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',0.0); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ES_Shape,'FaceColor',[0.5, 0, 0],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.0); % epi

        material shiny;
        lighting gouraud ;
        saveas(h,strcat('Images/movies/mode_EDES_',int2str(mode),'_',int2str(nview),'_',int2str(s),'.png'));
    end
  end
end

%% plot movies from PlotMode.m file

%calculate vertices
for mode=1:10
    %filename = strcat('mode',num2str(mode),'_long.gif');
    filename = strcat('Images/movies/mode_EDES_Post_', num2str(mode),'.gif');
    s1 = linspace(-3*sqrt(EDESHCatlas.latent(mode)),3*sqrt(EDESHCatlas.latent(mode)),20);
    s2 = linspace(3*sqrt(EDESHCatlas.latent(mode)),-3*sqrt(EDESHCatlas.latent(mode)),20);
    s = [s1 s2];
    %s = s1; %save space by animating one way on scores
    for n=1:20
        shapes = EDESHCatlas.mean + s(n) * EDESHCatlas.coeff(:,mode)';
        S = [shapes(1:3:end)',shapes(2:3:end)',shapes(3:3:end)'];
        ED_Shape = S(1:5810,:);
        ES_Shape = S(5811:end,:);

        ETIndices = importdata('./Data/ETIndices.txt');

        h=figure('Position',[0 0 900 900],'visible','off');
        axis equal manual % this ensures that getframe() returns a consistent size
            xlim([-90,90]);
            ylim([-90,90]);
            zlim([-90,90]);
        %view(55,55); %anterior view
        view(55,-125) %posterior view
        %view(55,-200) %basal view
        camlight('headlight');
        light('Position',[0 -1 0]);
        material shiny;
        lighting gouraud ;
        axis off;
        
        %patch('Faces',ETIndices,'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'EdgeAlpha',0.3); % RVLV
        patch('Faces',ETIndices(1:3072,:),'Vertices',ED_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.3); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ED_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.3); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.3,'EdgeAlpha',0.1); % epi
        
        %patch('Faces',ETIndices,'Vertices',ES_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'EdgeAlpha',0.3); % RVLV
        patch('Faces',ETIndices(1:3072,:),'Vertices',ES_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',1); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ES_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',1); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ES_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.0,'EdgeAlpha',0.3); % epi


        material shiny;
        lighting gouraud ;
        axis off;
        %title(['s=',num2str(s(n)/sqrt(EDESHCatlas.latent(mode)))],'FontSize',40,'Units', 'normalized', 'Position', [0.5, 0.5, 0],"Color","r");
        frame = getframe(h,[250, 250, 450, 450]); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if n == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1); 
        end 
    end
end
%% just points
for mode=1:10
    h = figure;
    axis equal manual % this ensures that getframe() returns a consistent size
    filename = strcat(path,'ED_mode',num2str(mode),'_long.gif');
    last = size(EDESHCatlas.mean,2)/2;
    s1 = linspace(-3*sqrt(EDESHCatlas.latent(mode)),3*sqrt(EDESHCatlas.latent(mode)),11);
    s2 = linspace(3*sqrt(EDESHCatlas.latent(mode)),-3*sqrt(EDESHCatlas.latent(mode)),11);
    s = [s1 s2];
    for n=1:22
        pts = EDESHCatlas.mean' + s(n)*EDESHCatlas.coeff(:,mode);
        plot3(pts(1:3:last)',pts(2:3:last)',pts(3:3:last)','LineStyle','none','Marker','.')
        axis equal manual % this ensures that getframe() returns a consistent size
        xlim([-80,80]);
        ylim([-80,80]);
        zlim([-80,80]);
        %view(60,-25); % apex view
        view(-110,-54); % long view
        drawnow 
          % Capture the plot as an image 
          frame = getframe(h); 
          im = frame2im(frame); 
          [imind,cm] = rgb2ind(im,256); 
          % Write to the GIF File 
          if n == 1 
              imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1); 
          else 
              imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1); 
          end 
    end
end