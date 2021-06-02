% addpath 'G:\My Drive\PHD\Data_processing_codes\Matlab_codes\Post_track_processing'
%% Make a gdf file of tracks from STB
%tracks: Frame,trkID,x,y,z
% load 'tracks.mat'
% write_gdf(or3d(:,[4 5 1:3])','tracks.gdf');

%% Read Output from velacc code
% velacc: x,y,z,trID,frame,vx,vy,vz,ax,ay,az,vx',vy',vz'
% curv: [:, curv], last 4 elements:curvmean, umagmean, amagmean, anmagmean
% curvfield: xGridAvg,yGridAvg,zGridAvg,vxcurv,0,0,vxrmscurv,0,0,nsamples,xGrid,yGrid,zGrid in grid
% velfield: xGridAvg,yGridAvg,zGridAvg,vx,vy,vz,vxrms,vyrms,vzrms,nsamples,xGrid,yGrid,zGrid in grid
% accfield: xGridAvg,yGridAvg,zGridAvg,ax,ay,az,axrms,ayrms,azrms,nsamples,xGrid,yGrid,zGrid in grid
% pospdf: 
    %col1: max, col2: min, col3: mean, col4:var, col5:skew, col6:flat of x,0,y,0,z,0
    %col6-200: xbin, xpdf,  ybin, ypdf,  ybin, ypdf
% trklen: bin, # of tracks
% config param: tot_particles, # of tracks, velfiltwidth, velfiltwlen,
%               accfiltwidth, accfiltlen, nxbin,nybin, nzbin, xmin, ymin, zmin, xbinsize,
%               ybinsize, zbinsize, first_frm, last_frm

    output = 'E:\VONSET\20210524\T4\Results\';
    velacc = read_gdf([output 'velacc_velacc.gdf']); velacc(:,12:14) = read_gdf([output 'velacc_velfluc.gdf']); %velacc(:,16:18) = read_gdf([output '_accfluc.gdf']);
    curv = read_gdf([output 'velacc_curv.gdf']); 
    curvfield = read_gdf([output 'velacc_kfield.gdf']); curvfield = curvfield'; 
    velfield = read_gdf([output 'velacc_vfield.gdf']); velfield = velfield'; 
    accfield = read_gdf([output 'velacc_afield.gdf']); accfield = accfield'; 
    pospdf = read_gdf([output 'velacc_pospdf.gdf']); 
    trklen = read_gdf([output 'velacc_trklen.gdf']); 
    trkstats = read_gdf([output 'velacc_trackstats.gdf'], 'int32'); 
    config_param = read_gdf([output 'velacc_configparam.gdf'], 'double'); 
    
    %% creating a copy of velacc output files
%      write_gdf(velacc(:,1:11)','out_velacc.gdf');
%      write_gdf(curv','out_curv.gdf');
%      write_gdf(curvfield,'out_kfield.gdf');
%      write_gdf(accfield,'out_afield.gdf');
%      write_gdf(pospdf','out_pospdf.gdf');
%      write_gdf(trklen','out_trklen.gdf');
%      write_gdf(trkstats','out_trackstats.gdf');
%      write_gdf(config_param','out_configparam.gdf');
%      write_gdf(velfield,'out_vfield.gdf');
     
%% Outputs from vE3Dstruct

%vE3Dstruct:
%r,nsample,DLL,DNN,DLLL,DLNN,DLLLL,DLLNN,DNNNN,Dtke,rnominal,r2,rlin,nsample_lin,RLL,RNN,DLL_lin,DNN_lin,DLLL_lin
%vE3Dstruct.UA: r_UA, nsampleUA, Daal, Daan, Dual, Duan, Raal, Raan, Rual,
%               Ruan, vLv2v02, v0Lv02v2, uLuV2, uLu2V2, uLu2v02, uLu2v2, cosalpha2, va0v2, vav02, v02dva, v2dva
%vE3Dstruct.strips:  col1: n_strips, strips_direction-'x', 0.0, 0.0, 0.0, 0.0, 0.0
%                   every strip: jmax, nIncTotal[k], strips_boundary[k], strips_boundary[k+1], strips_center[k], 0.0, 0.0
%                                r_strip[i], nsamp_strip[i], Dll_strip[i], Dnn_strip[i], Dlll_strip[i], Dlnn_strip[i], duda_strip[i]

    
%     output = 'D:\1.Projects\2.Bubble-Particle\Data_analysis\20210514\Run5\Results\';
    struct = read_gdf([output 'vE3DstructOUT.gdf'],'double');
    struct_UA = read_gdf([output 'vE3DstructOUT.UA.gdf'],'double');
    struct_strips = read_gdf([output 'vE3DstructOUT.strips.gdf'],'double');
    
  %% vE3Dstruct.CGVG_all: Frame, npts_frame, S11, S12, S13, S22, S23, S33, R, Q, lambda1, lambda2, lambda3, vorticity, 
%                     ev1[1,2,3], ev2[1,2,3], ev3[1,2,3], omega[1,2,3]
%vE3Dstruct.CGVG_stats (Lagrangian correlations): Frame, R_RR, R_QQ, R_ev1ev1, R_ev2ev2, R_ev3ev3, R_ev1omega,
%                                                 R_ev2omega, R_ev3omega, R_omegeV1, R_omegeV2, R_omegeV3
    struct_CGVG_all = read_gdf(['vE3DstructOUT' output '.CGVG_all.gdf'],'double');
    struct_CGVG_all(struct_CGVG_all(:,2) == 0,:) = [];
    struct_CGVG_stats = read_gdf(['vE3DstructOUT' output '.CGVG_stats.gdf'],'double');
    struct_CGVG_stats(struct_CGVG_stats(:,2) == 0,:) = [];