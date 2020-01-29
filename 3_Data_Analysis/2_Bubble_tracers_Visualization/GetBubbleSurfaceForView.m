function  GetBubbleSurfaceForView(reconstruction_path, frame_range)
addpath 3-Bubble-breakup/;
% reconstruction_path='/Volumes/Transcend/04.13.18/Run1/Bubbles2/Reconstruction/';
mkdir([reconstruction_path 'STL']);
for n = frame_range(1) :  frame_range(2)
    load([reconstruction_path 'Bubble_Frame_' num2str(n,'%06i') '.mat'])
    min_rad=0;
    bubs=find(cent_rad_vol(:,4)>=min_rad);
%     figure
    for i=1:length(bubs)
        ind=bubbles(1,bubs(i)):bubbles(2,bubs(i));
        p=voxels(ind,:);
%         scatter3(p(1:100:end,1),p(1:100:end,2),p(1:100:end,3))
%         hold on
        [vx,vy,vz,vox]=map2grid(voxels(ind,1),voxels(ind,2),voxels(ind,3),voxel_size_2);
        vox=imfill(vox,'holes');
        ind=find(vox>0);
        fv=isosurface(vx,vy,vz,vox,0.999);
        facevert(i).faces=fv.faces;
        facevert(i).vertices=fv.vertices;
    end
%     axis equal
    nb=length(bubs);
    filename=[reconstruction_path '/STL/BSFrame' num2str(n,'%06i') '.stl'];
    patch2stl_combineV2(filename, facevert, nb);
end
end

