function [EDmodel, ESmodel, WMmodel] = genEDESModels(atlas,mode,score)
%% Created by: Anna Qi

if mode == 0
    shape = atlas.mean;
else
    d = score.*sqrt(atlas.latent(mode))';
    shape = atlas.mean+d*atlas.coeff(:,mode)';
end

N = length(shape);
EDmodel = reshape(shape(1:N/2), 3, [])';
ESmodel = reshape(shape((N/2+1):end), 3, [])';
WMmodel = EDmodel - ESmodel;

end