function [ Res_out, pos_new, isConverged, isLost] = STB_getResidual( p3d, STB_params, intensities, I_rec, I_projected, cameraSystem, shake_dim)
% Shake it!
% input recorded images must be (x,y)-format!

%data2d = STB_get2DPositions(p3d, cameraSystem); %without distortion
data2d = projectPoints2d_distortion(p3d, cameraSystem); %with distortion

shake_vektor = zeros(1,3);
shake_vektor(shake_dim) = STB_params.normalShakeWidth;
p3d1 = p3d - shake_vektor;
p3d2 = p3d;
p3d3 = p3d + shake_vektor;
isConverged = 0;
isLost = 0;



for camNo = 1:cameraSystem.nCameras
    window2d.xmin = round(data2d{camNo}(1))-STB_params.evalWindowSize;
    window2d.xmax = round(data2d{camNo}(1))+STB_params.evalWindowSize;
    window2d.ymin = round(data2d{camNo}(2))-STB_params.evalWindowSize;
    window2d.ymax = round(data2d{camNo}(2))+STB_params.evalWindowSize;
    try % it is possible, that the evaluation window lies outside the image boundaries
        I_rec_window = I_rec{camNo}( window2d.ymin:window2d.ymax, window2d.xmin:window2d.xmax);
        I_proj = I_projected{camNo}( window2d.ymin:window2d.ymax, window2d.xmin:window2d.xmax);
    catch
        % if so, mark the particle as "lost"
        isLost = 1;
        % create a dummy window to let the function complete
        Res_out = zeros(3,1);
        pos_new = [0 0 0];
        isConverged = 0;
        return;
    end
    
    [IPartShaked1, lost1 ] = STB_projectImage(camNo, STB_params,        p3d1, cameraSystem , window2d, intensities( camNo) );
    [IPartShaked2, lost2 ] = STB_projectImage(camNo, STB_params,        p3d2, cameraSystem , window2d, intensities( camNo) );
    [IPartShaked3, lost3 ] = STB_projectImage(camNo, STB_params,        p3d3, cameraSystem , window2d, intensities( camNo) );
    
    isLost = union(isLost,find(lost1) );
    isLost = union(isLost,find(lost2) );
    isLost = union(isLost,find(lost3) );
    
    Residual1 = ( I_rec_window - I_proj + IPartShaked2 - IPartShaked1 ).^2;
    Residual2 = ( I_rec_window - I_proj ).^2;
    Residual3 = ( I_rec_window - I_proj + IPartShaked2 - IPartShaked3 ).^2;
    
    Res{camNo}(1) = sum(Residual1(:));
    Res{camNo}(2) = sum(Residual2(:));
    Res{camNo}(3) = sum(Residual3(:));
    
    if STB_params.verboseMode ==1
        % look for existing window
        fig_name = sprintf('ProjectionsCam%d',camNo);
        hnd = findobj('Name', fig_name);
        if isempty(hnd)
            hnd = figure('Name', fig_name);
        end
        set(0, 'currentfigure', hnd);
        cscaling = 0.6;
        subplot(2,2,1)
        
        pcolor(I_rec_window); shading flat; caxis([-cscaling cscaling])
        title('Irecwindow');
        subplot(2,2,2);
        
        pcolor(I_proj); shading flat;caxis([-cscaling cscaling])
        title('Iproj');
        subplot(2,2,3);
        
        pcolor(IPartShaked2); shading flat; caxis([-cscaling cscaling])
        title('IPartShaked');
        subplot(2,2,4);
        
        pcolor(I_rec_window-I_proj); shading flat;caxis([-cscaling cscaling])
        title('Irecwindow-Iproj');

    end
    
end
% summarize residual over all cameras
Res_out = zeros(3,1);

for camNo2 = 1:cameraSystem.nCameras
    Res_out(1) = Res_out(1)+Res{camNo2}(1);
    Res_out(2) = Res_out(2)+Res{camNo2}(2);
    Res_out(3) = Res_out(3)+Res{camNo2}(3);
end

% fit parabola to the three values
parabolaFit = polyfit([p3d1(shake_dim)-p3d2(shake_dim) 0 p3d3(shake_dim)-p3d2(shake_dim)], [Res_out(1), Res_out(2), Res_out(3)],2);

% get extremum
extr = -0.5* parabolaFit(2)/parabolaFit(1);

% absolute distance of extremum to initial point?
dist_ex = abs(extr);

% look, which shake performed better and output position with lower
% residual
if dist_ex<STB_params.normalShakeWidth
    pos_new = p3d2;
    pos_new(shake_dim) = extr+p3d2(shake_dim);
    isConverged = 1;
elseif Res_out(3)>Res_out(1)
    pos_new = p3d1;
elseif Res_out(1)>Res_out(3)
    pos_new = p3d3;
end

end

