function [vx,vy,vz,vox]=map2grid(x,y,z,voxel_size)

xmin=min(x)-voxel_size(1);xmax=max(x)+voxel_size(1);
ymin=min(y)-voxel_size(2);ymax=max(y)+voxel_size(2);
zmin=min(z)-voxel_size(3);zmax=max(z)+voxel_size(3);

[vx,vy,vz]=meshgrid(xmin:voxel_size(1):xmax,...
    ymin:voxel_size(2):ymax,...
    zmin:voxel_size(3):zmax);

sz=size(vx);

suby=(y-repmat(ymin,length(y),1))./voxel_size(1)+1;
subx=(x-repmat(xmin,length(x),1))./voxel_size(2)+1;
subz=(z-repmat(zmin,length(z),1))./voxel_size(3)+1;

indb=sub2ind(sz,suby,subx,subz);
indb=uint64(indb);
% indbu=unique(indb);
vox=false(sz);
vox(indb)=true;