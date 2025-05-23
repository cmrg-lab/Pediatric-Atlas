function [] = plotValves(model)
%% Created by: Sachin Govil

ETIndices = importdata('./Data/ETIndices.txt');
SurfaceStartEnd = [ 1,3072;       % LV (faces 1 to 3072 belong to the LV chamber...)
                    3073,4480;    % RVS
                    4481,6752;    % RVFW
                    6753,11616;   % Epi
                    11617,11664;  % Mitral valve
                    11665,11688;  % Aortic valve
                    11689,11728;  % Tricuspid valve
                    11729,11760]; % Pulmonary valve

patch('Faces',ETIndices([SurfaceStartEnd(5,1):2:11638,11639+1:2:SurfaceStartEnd(5,2)],[1,3]),'Vertices',model,'FaceColor','none','EdgeColor','cyan','EdgeAlpha',1,'Linewidth',2); % Mitral valve
patch('Faces',ETIndices([SurfaceStartEnd(5,1)+1:2:11638,11639:2:SurfaceStartEnd(5,2)],[1,2]),'Vertices',model,'FaceColor','none','EdgeColor','cyan','EdgeAlpha',1,'Linewidth',2); % Mitral valve
patch('Faces',ETIndices(SurfaceStartEnd(6,1):2:SurfaceStartEnd(6,2),[1,3]),'Vertices',model,'FaceColor','none','EdgeColor','yellow','EdgeAlpha',1,'Linewidth',2); % Aortic valve
patch('Faces',ETIndices(SurfaceStartEnd(6,1)+1:2:SurfaceStartEnd(6,2),[1,2]),'Vertices',model,'FaceColor','none','EdgeColor','yellow','EdgeAlpha',1,'Linewidth',2); % Aortic valve
patch('Faces',ETIndices([SurfaceStartEnd(7,1):2:11714,11715+1:2:SurfaceStartEnd(7,2)],[1,3]),'Vertices',model,'FaceColor','none','EdgeColor','magenta','EdgeAlpha',1,'Linewidth',2); % Tricuspid valve
patch('Faces',ETIndices([SurfaceStartEnd(7,1)+1:2:11714,11715:2:SurfaceStartEnd(7,2)],[1,2]),'Vertices',model,'FaceColor','none','EdgeColor','magenta','EdgeAlpha',1,'Linewidth',2); % Tricuspid valve
patch('Faces',ETIndices(SurfaceStartEnd(8,1):2:SurfaceStartEnd(8,2),[1,3]),'Vertices',model,'FaceColor','none','EdgeColor','green','EdgeAlpha',1,'Linewidth',2); % Pulmonary valve
patch('Faces',ETIndices(SurfaceStartEnd(8,1)+1:2:SurfaceStartEnd(8,2),[1,2]),'Vertices',model,'FaceColor','none','EdgeColor','green','EdgeAlpha',1,'Linewidth',2); % Pulmonary valve

end