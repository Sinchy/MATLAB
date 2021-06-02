function tomo_showWeighting( wij, cameraSystem, X,Y,Z )

cmap = jet(4);
proj = cameraSystem.getProjectionMatrices;


for camNo = 1:4
    P = proj(camNo).projectionMatrix;
    p2d = P*[0 0 0 1]';
    p2d = p2d(1:2)./p2d(3);
    
    width = cameraSystem.cameraCalibrations(camNo).camera.width;
    height = cameraSystem.cameraCalibrations(camNo).camera.height;
    
    pxIdx = round(p2d);
    pxIdx = sub2ind([width height],pxIdx(1), pxIdx(2));
    
    idxWij = find([wij(camNo,:).pixel]==pxIdx);
    voxIdx = wij(camNo,idxWij).voxels;
    
    plot3(X(voxIdx), Y(voxIdx), Z(voxIdx),'b+'); hold on
    
    
    H = inv(cameraSystem.vertexList(camNo).pose);
    C = H(1:3, 4);
    %plot3(C(1), C(2), C(3),'o','Color', cmap(camNo,:));
end
plot3(0,0,0,'ro');

                
end

