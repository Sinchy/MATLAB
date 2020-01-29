function [ data2d ] = STB_get2DPositions( part3D, cameraSystem )
%  This function extracts the 2d positions in all given cameras

P = cameraSystem.getProjectionMatrices;
for camNo = 1:cameraSystem.nCameras
    for partNo = 1:size(part3D,1)
        data2d{camNo}(partNo,:) = P(camNo).projectionMatrix*[part3D(partNo,:)' ; 1];
        data2d{camNo}(partNo,:) = data2d{camNo}(partNo,1:3)./data2d{camNo}(partNo,3);
    end
    data2d{camNo} = data2d{camNo}(:,1:2);
end

end

