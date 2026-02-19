classdef Subdivision_Surface
    % This class create a surface from the control mesh
    % Based on Catmull Clark subdivision surface method

    properties
        
        control_mesh;               % X,Y,Z parameters
        matrix;                     % subdivision matrix (from coarse mesh to 3D model)
        numNodes = 388;             % number of nodes (coarse mesh)
        numElements = 187;          % number of elements
        ETIndices;                  % Faces (subdivided model)
        etPos;                      % Subdivided mesh
        faceCM;                     % Faces (coarse mesh)
        etVertexXi;                 % local coordinates
        etVertexElementNum ;        % element number
        etVertexStartEnd;
        CMStartEnd;
        SurfaceStartEnd;
        
    end

    methods

        function obj = Subdivision_Surface(CM,FilePath)
            
            obj.control_mesh = CM;
            obj.matrix = importdata(strcat(FilePath,'subdivision_matrix.txt'));
            obj.ETIndices = importdata(strcat(FilePath,'ETIndices.txt'));
            obj.etPos = obj.matrix* obj.control_mesh;
            obj.faceCM = importdata(strcat(FilePath,'ETIndices_control_mesh.txt'));
            obj.etVertexXi = importdata(strcat(FilePath,'etVertexXi.txt'));
            obj.etVertexElementNum = importdata(strcat(FilePath,'etVertexElementNum.txt'));

            obj.CMStartEnd = [1,96;  % LV
                              97,211; % RV
                              212,354]; % Epi

            obj.etVertexStartEnd = [1,1500;      % LV (vertices 1 to 1500 belong to the LV chamber...)
                                    1501,2165;   % RVS
                                    2166,3224;   % RVFW
                                    3225,5582;   % Epi
                                    5583,5631;   % Mitral valve
                                    5632,5656;   % Aortic valve
                                    5657,5697;   % Tricuspid valve
                                    5698,5730;   % Pulmonary valve
                                    5731,5810];  % RV insert

            obj.SurfaceStartEnd = [ 1,3072;       % LV (faces 1 to 3072 belong to the LV chamber...)
                                    3073,4480;    % RVS
                                    4481,6752;    % RVFW
                                    6753,11616;   % Epi
                                    11617,11664;  % Mitral
                                    11665,11688;  % Aortic valve
                                    11689,11728;  % Tricuspid valve
                                    11729,11760]; % Pulmonary valve
            
        end
                
        % Function to plot surface
         function obj = Plot(obj,SurfaceType)
             
             if strcmp(SurfaceType,'endo')
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(1,1):obj.SurfaceStartEnd(1,2),:),'Vertices',obj.etPos,'FaceColor',[0, 0.5, 0],'FaceAlpha',0.8,'EdgeColor','k'); % LV
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(2,1):obj.SurfaceStartEnd(3,2),:),'Vertices',obj.etPos,'FaceColor',[0, 0, 0.5],'FaceAlpha',0.8,'EdgeColor','k'); % RV
                title('Endocardium');
                set(gcf,'color','w');
             end
             
             if strcmp(SurfaceType,'LV')
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(1,1):obj.SurfaceStartEnd(1,2),:),'Vertices',obj.etPos,'FaceColor',[0, 0.5, 0],'FaceAlpha',0.8,'EdgeColor','k'); % LV
                title('LV');
             end
             
             if strcmp(SurfaceType,'RV')
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(2,1):obj.SurfaceStartEnd(3,2),:),'Vertices',obj.etPos,'FaceColor',[0, 0, 0.8],'FaceAlpha',1,'EdgeColor','k','SpecularStrength',0.1); % RV
                title('RV');
             end
             
             if strcmp(SurfaceType,'epi')
            	patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(4,1):obj.SurfaceStartEnd(4,2),:),'Vertices',obj.etPos,'FaceColor',[0.8, 0, 0],'FaceAlpha',0.8,'EdgeColor','k');
                title('Epicardium');
             end
             
             if strcmp(SurfaceType,'all')             
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(1,1):obj.SurfaceStartEnd(1,2),:),'Vertices',obj.etPos,'FaceColor',[0, 0.5, 0],'EdgeColor','none','FaceAlpha',1,'EdgeAlpha',1); % LV
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(2,1):obj.SurfaceStartEnd(3,2),:),'Vertices',obj.etPos,'FaceColor',[0, 0, 0.8],'EdgeColor','none','FaceAlpha',1,'EdgeAlpha',1); % RV
                patch('Faces',obj.ETIndices(obj.SurfaceStartEnd(4,1):obj.SurfaceStartEnd(4,2),:),'Vertices',obj.etPos,'FaceColor',[0.5, 0, 0],'EdgeColor','none','FaceAlpha',0.5,'EdgeAlpha',1); % epi
             end
             
             set(gcf,'color','w');
             axis off;
             axis equal
             
         end
         
         % Function to plot coarse mesh
         function obj = PlotCM(obj,SurfaceType)
             
             if strcmp(SurfaceType,'all')
                 hold on;
                 patch('Faces',obj.faceCM(obj.CMStartEnd(1,1):obj.CMStartEnd(1,2),:),'Vertices',obj.control_mesh,'FaceColor',[0 0.5 0],'FaceAlpha',0.4,'EdgeColor','k','LineWidth',2);
                 patch('Faces',obj.faceCM(obj.CMStartEnd(2,1):obj.CMStartEnd(2,2),:),'Vertices',obj.control_mesh,'FaceColor',[0 0 0.8],'FaceAlpha',0.4,'EdgeColor','k','LineWidth',2);
                 patch('Faces',obj.faceCM(obj.CMStartEnd(3,1):obj.CMStartEnd(3,2),:),'Vertices',obj.control_mesh,'FaceColor',[0.5 0 0],'FaceAlpha',0.4,'EdgeColor','k','LineWidth',2);
             end
             
             if strcmp(SurfaceType,'LV')
                 patch('Faces',obj.faceCM(obj.CMStartEnd(1,1):obj.CMStartEnd(1,2),:),'Vertices',obj.control_mesh,'FaceColor',[0 0.5 0],'FaceAlpha',0.4,'EdgeColor','k','LineWidth',2);
             end
             
             if strcmp(SurfaceType,'RV')
                 patch('Faces',obj.faceCM(obj.CMStartEnd(2,1):obj.CMStartEnd(2,2),:),'Vertices',obj.control_mesh,'FaceColor',[0 0 0.8],'FaceAlpha',0.4,'EdgeColor','k','LineWidth',2);
             end
             
             if strcmp(SurfaceType,'endo')
                 patch('Faces',obj.faceCM(obj.CMStartEnd(1,1):obj.CMStartEnd(2,2),:),'Vertices',obj.control_mesh,'FaceColor',[0.5 0 0],'FaceAlpha',0.4,'EdgeColor','k');
             end
             
             if strcmp(SurfaceType,'epi')
                 patch('Faces',obj.faceCM(obj.CMStartEnd(3,1):obj.CMStartEnd(3,2),:),'Vertices',obj.control_mesh,'FaceColor',[0.5 0 0],'FaceAlpha',0.4,'EdgeColor','k');
             end
             
             set(gcf,'color','w');
             axis off;
             axis equal
             
         end

    end
    
end