function [] = plotWireframe(model, indices_path)
%% Created by: Anna Qi

ETIndices = importdata(indices_path);
SurfaceStartEnd = [ 1,3072;       % LV (faces 1 to 3072 belong to the LV chamber...)
                    3073,4480;    % RVS
                    4481,6752;    % RVFW
                    6753,11616;   % Epi
                    11617,11664;  % Mitral valve
                    11665,11688;  % Aortic valve
                    11689,11728;  % Tricuspid valve
                    11729,11760]; % Pulmonary valve

patch('Faces',ETIndices(SurfaceStartEnd(1,1):SurfaceStartEnd(1,2),:),'Vertices',model,'FaceColor', 'none','EdgeColor','k','LineWidth',0.3); % LV
patch('Faces',ETIndices(SurfaceStartEnd(2,1):SurfaceStartEnd(3,2),:),'Vertices',model,'FaceColor', 'none','EdgeColor','k','LineWidth',0.3); % RV
patch('Faces',ETIndices(SurfaceStartEnd(4,1):SurfaceStartEnd(4,2),:),'Vertices',model,'FaceColor', 'none','EdgeColor','k','LineWidth',0.3); % Epi

end