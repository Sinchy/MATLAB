loc='/Volumes/Transcend/04.13.18/Run1/Bubbles2/Reconstruction/';
frame=2450;
load([loc 'Bubble_Frame_' num2str(frame,'%06i') '.mat'])
min_rad=3;
bubs=find(cent_rad_vol(:,4)>=min_rad);
figure
for i=1:length(bubs)
    ind=bubbles(1,bubs(i)):bubbles(2,bubs(i));
    p=voxels(ind,:);
    scatter3(p(1:100:end,1),p(1:100:end,2),p(1:100:end,3))
    hold on
    [vx,vy,vz,vox]=map2grid(voxels(ind,1),voxels(ind,2),voxels(ind,3),voxel_size_2);
    vox=imfill(vox,'holes');
    ind=find(vox>0);
    fv=isosurface(vx,vy,vz,vox,0.999);
    facevert(i).faces=fv.faces;
    facevert(i).vertices=fv.vertices;
end
axis equal
nb=length(bubs);
filename='./test.stl';
patch2stl_combineV2(filename, facevert, nb);