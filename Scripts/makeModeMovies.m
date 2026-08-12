% makeModeMovies.m
% modified 1029-10-04 AAY for template code from Charlene
% Edited by Anna Qi

load('../Data/EDESatlas.mat');
out_path = '../Images/pedatlas_characterization/mode_movies/';
nModes = 8; 

%% plot surfaces and save to png

%calculate vertices
for nview = 1:3 %three viewpoints
  for mode=1:nModes
    for s=[-3,3]
        shapes = EDESatlas.mean + s* sqrt(EDESatlas.latent(mode)) * EDESatlas.coeff(:,mode)';
        S = [shapes(1:3:end)',shapes(2:3:end)',shapes(3:3:end)'];

        ED_Shape = S(1:5810,:);
        ES_Shape = S(5811:end,:);

        ETIndices = importdata('../Data/ETIndices.txt');

        h=figure('Position',[0 0 900 900],'visible','off'); %set visible to off for faster processing
        axis equal manual % this ensures that getframe() returns a consistent size
            xlim([-90,90]);
            ylim([-90,90]);
            zlim([-90,90]);
        switch nview
            case 1, view(55,55); %anterior view
            case 2, view(55,-125) %posterior view
            case 3, view(55, -225)
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
        saveas(h,strcat(out_path,'/mode_EDES_',int2str(mode),'_',int2str(nview),'_',int2str(s),'.png'));
    end
  end
end

%% plot gifs of each mode

ETIndices = importdata('../Data/ETIndices.txt');

% Compute global axis bounds across all modes and frames
pad = 0;
all_min = inf(1,3);
all_max = -inf(1,3);
for mode_tmp = 1:nModes
    s_tmp = [linspace(-3*sqrt(EDESatlas.latent(mode_tmp)), 3*sqrt(EDESatlas.latent(mode_tmp)), 20), ...
             linspace(3*sqrt(EDESatlas.latent(mode_tmp)), -3*sqrt(EDESatlas.latent(mode_tmp)), 20)];
    all_shapes_tmp = arrayfun(@(n) EDESatlas.mean + s_tmp(n) * EDESatlas.coeff(:,mode_tmp)', 1:length(s_tmp), 'UniformOutput', false);
    all_verts_tmp = cellfun(@(sh) [sh(1:3:end)',sh(2:3:end)',sh(3:3:end)'], all_shapes_tmp, 'UniformOutput', false);
    all_verts_tmp = cat(1, all_verts_tmp{:});
    all_min = min(all_min, min(all_verts_tmp));
    all_max = max(all_max, max(all_verts_tmp));
end
xl = [all_min(1)-pad, all_max(1)+pad];
yl = [all_min(2)-pad, all_max(2)+pad];
zl = [all_min(3)-pad, all_max(3)+pad];

% Loop through the modes
for mode=1:nModes
    % Change label here along with the view you're using
    filename = strcat(out_path,'/mode_EDES_Base_', num2str(mode),'.gif');
    s1 = linspace(-3*sqrt(EDESatlas.latent(mode)),3*sqrt(EDESatlas.latent(mode)),20);
    s2 = linspace(3*sqrt(EDESatlas.latent(mode)),-3*sqrt(EDESatlas.latent(mode)),20);
    s = [s1 s2];

    for n=1:20
        shapes = EDESatlas.mean + s(n) * EDESatlas.coeff(:,mode)';
        S = [shapes(1:3:end)',shapes(2:3:end)',shapes(3:3:end)'];
        ED_Shape = S(1:5810,:);
        ES_Shape = S(5811:end,:);

        h=figure('Position',[0 0 900 900],'visible','off');
        % view(55,55); %anterior view
        % view(55,-125) %posterior view
        view(55,-225) %basal view
        camlight('headlight');
        light('Position',[0 -1 0]);
        material shiny;
        lighting gouraud;
        
        patch('Faces',ETIndices(1:3072,:),'Vertices',ED_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.3); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ED_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.3); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.3,'EdgeAlpha',0.1); % epi
        
        patch('Faces',ETIndices(1:3072,:),'Vertices',ES_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',1); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ES_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',1); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ES_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.0,'EdgeAlpha',0.3); % epi
        
        axis off;
        axis equal manual % this ensures that getframe() returns a consistent size
        axis vis3d;
        xlim(xl); ylim(yl); zlim(zl);
        set(gca, 'Position', [0 0 1 1])  % axes fills entire figure, no margins
        frame = getframe(h);
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if n == 1 
            imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0.1); 
        else 
            imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1); 
        end 
        close(h);
    end
end
