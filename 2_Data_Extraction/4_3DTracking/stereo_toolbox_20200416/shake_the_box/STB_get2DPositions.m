function [ data2d ] = STB_get2DPositions( part3D, cameraSystem )
%  This function extracts the 2d positions in all given cameras

if ~isstruct(cameraSystem)  % cameraSystem object is given
    P = cameraSystem.getProjectionMatrices;
    nCams = cameraSystem.nCameras;
    
    for camNo = 1:nCams
        for partNo = 1:size(part3D,1)
            data2d{camNo}(partNo,:) = P(camNo).projectionMatrix*[part3D(partNo,:)' ; 1];
            data2d{camNo}(partNo,:) = data2d{camNo}(partNo,1:3)./data2d{camNo}(partNo,3);
        end
        data2d{camNo} = data2d{camNo}(:,1:2);
    end
    
    
else % only the projection matrix is given, performance boost!
    P = cameraSystem;
    
    for camNo = 1:numel(P)
        d2d = zeros(size(part3D,1),3);
        for partNo = 1:size(part3D,1)
            d2d(partNo,:) = P(camNo).projectionMatrix*[part3D(partNo,:)' ; 1];
            d2d(partNo,:) = d2d(partNo,1:3)./d2d(partNo,3);
        end
        
        data2d{camNo} = d2d(:,1:2);
    end
    
    
end

end

