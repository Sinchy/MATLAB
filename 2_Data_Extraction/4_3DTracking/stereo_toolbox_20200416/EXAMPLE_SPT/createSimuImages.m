
window2d_full.xmin = 1;
window2d_full.xmax = 1280;
window2d_full.ymin = 1;
window2d_full.ymax = 1024;

mkdir cam1
mkdir cam2
mkdir cam3
mkdir cam4

P = cameraSystem.getProjectionMatrices;

fprintf(1,'Generating artificial images from data: ');
for frame = 1:100
    fprintf(1,'%04d',frame);
    positions = [];
    
    for partNum = 1:length(groundTruthData)
        positions =  [ positions ; groundTruthData(partNum).position( groundTruthData(partNum).frames == frame  , :) ];
    end

    for camNo = 1:4
        I{camNo} = STB_projectImage(camNo, SPT_params, positions, cameraSystem , window2d_full, 0.3*ones( size(positions,1) ) );
    end
    
    imwrite(I{1},sprintf(cam1_filename,frame));
    imwrite(I{2},sprintf(cam2_filename,frame));
    imwrite(I{3},sprintf(cam3_filename,frame));
    imwrite(I{4},sprintf(cam4_filename,frame));
    fprintf(1,'\b\b\b\b');
end
fprintf(1,' [ done ]\n');