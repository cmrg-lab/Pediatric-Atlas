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

load('../Data/EDESHCatlas.mat');
out_path = '../Images/pedatlas_characterization/HC_movies/';
nModes = size(EDESatlas.latent,1); 

%% plot surfaces and save to png

%calculate vertices
for nview = 1:3 %three viewpoints
  for mode=1:11
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

start_mode = 1;
end_mode = 11;

% Compute global axis bounds across all modes and frames
pad = 1;
all_min = inf(1,3);
all_max = -inf(1,3);
for mode_tmp = start_mode:end_mode
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
for mode=start_mode:end_mode
    % Change label here along with the view you're using
    filename = strcat(out_path,'/mode_EDES_Ant_', num2str(mode),'.gif');
    s1 = linspace(-3*sqrt(EDESatlas.latent(mode)),3*sqrt(EDESatlas.latent(mode)),20);
    s2 = linspace(3*sqrt(EDESatlas.latent(mode)),-3*sqrt(EDESatlas.latent(mode)),20);
    s = [s1 s2];

    for n=1:20
        shapes = EDESatlas.mean + s(n) * EDESatlas.coeff(:,mode)';
        S = [shapes(1:3:end)',shapes(2:3:end)',shapes(3:3:end)'];
        ED_Shape = S(1:5810,:);
        ES_Shape = S(5811:end,:);

        h=figure('Position',[0 0 900 900],'visible','off');
        view(55,55); %anterior view
        % view(55,-125) %posterior view
        % view(55,-225) %basal view
        camlight('headlight');
        light('Position',[0 -1 0]);
        material shiny;
        lighting gouraud;
        axis off;
        
        patch('Faces',ETIndices(1:3072,:),'Vertices',ED_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.3); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ED_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',0.3,'EdgeAlpha',0.3); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ED_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.3,'EdgeAlpha',0.1); % epi
        
        patch('Faces',ETIndices(1:3072,:),'Vertices',ES_Shape,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',1); % LV
        patch('Faces',ETIndices(3073:6752,:),'Vertices',ES_Shape,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',1.0,'EdgeAlpha',1); % RV
        patch('Faces',ETIndices(6753:11616,:),'Vertices',ES_Shape,'FaceColor','none','EdgeColor',[0.5,0.5,0.5],'FaceAlpha',0.0,'EdgeAlpha',0.3); % epi
        
        axis off;
        axis equal manual % this ensures that getframe() returns a consistent size
        xlim(xl); ylim(yl); zlim(zl);
            % xlim([-90,90]);
            % ylim([-90,90]);
            % zlim([-90,90]);
        set(gca, 'Position', [0 0 1 1])  % axes fills entire figure, no margins
        %title(['s=',num2str(s(n)/sqrt(EDESatlas.latent(mode)))],'FontSize',40,'Units', 'normalized', 'Position', [0.5, 0.5, 0],"Color","r");
        frame = getframe(h);
        im = frame2im(frame); 
        % im = imcrop(im, [100, 100, 700, 700]);
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
