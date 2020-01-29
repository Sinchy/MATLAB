function velacc = Post_process(dataset_path, dataset, frame_rate, SF)
current = pwd;
path = extractBefore(current, 'CVersion');
addpath(path);
tracks = ReadAllTracks([dataset_path 'Tracks/ConvergedTracks/']);
write_gdf(tracks(:, [4 5 1:3])', [dataset_path 'tracks.gdf']);

%% Global inputs
%  global C_code_path dataset_path dataset_path1 dataset outputfile_velacc outputfile_vE3DstructOUT config_velacc...
%      config_vE3Dstruct config_pairdisp tot_particles tot_tracks flag_skip_velacc_Calc
 
%     C_code_path = 'G:\"My Drive"\PHD\Data_processing_codes\Turb_Statistics_VS\x64\Release\';
%     dataset_path = 'C:/Users/ash4u/Desktop/Research/Curvature_statistics/Tunnel_dataset/Run1_07.17.18_11_of_88_3s/'; %make sure it has forward slashes
path = extractBefore(current, 'Code');
% C_code_path = [ path 'Code/LocalCode/Post_process/Release/'];
C_code_path = [ path 'Code/Post_process/Release/'];
%     dataset_path = data_path;
%     dataset = '07.17.18_Run1_11_of_88_3s';
%     tot_particles = 245524274; %size(or3d,1); %245524274
    tot_particles = size(tracks, 1);
%     tot_tracks = 9070486; %size(unique(or3d(:,5)),1); %9070487
%     tot_tracks = size(unique(tracks(:,5)), 1);
    last_frame = max(tracks(:,4));
    flag_skip_velacc_Calc = 0; % if they are already calculated

%%
%% Make the config files
%     V = 1;
%     while (isfolder([dataset_path 'result' num2str(V)]))
%         V = V + 1;
%     end
    
%     if (flag_skip_velacc_Calc)
%         prompt = 'Velacc calc skipped, which version of velacc to use for vE3Dstruct: ';
%         V = input(prompt);
%     end
    
    
    if (~isfolder([dataset_path 'result']))
        mkdir([dataset_path 'result']);
    end
    
    % updating data path to result folder
    dataset_path1 = [dataset_path 'result' '/'];
    config_velacc = [dataset_path1 'config_file_velacc_' dataset '.txt'];
    config_vE3Dstruct = [dataset_path1 'config_file_vE3Dstruct_' dataset '.txt']; 
    config_pairdisp = [dataset_path1 'config_file_pairdisp_' dataset '.txt'];
    outputfile_velacc = [dataset_path1 'velacc'];
    outputfile_vE3DstructOUT = [dataset_path1 'vE3DstructOUT'];
    
    % creating the config files
    write_velacc_configFile(dataset_path, frame_rate, config_velacc, outputfile_velacc, config_vE3Dstruct, config_pairdisp, tot_particles, flag_skip_velacc_Calc );
    
    write_vE3Dstruct_configFile(outputfile_velacc, outputfile_vE3DstructOUT, config_vE3Dstruct, last_frame)
%% Run the C code
    clear tracks; % clear tracks to leave space to the C code.
tic
    system(['cd ' C_code_path ' && ./Post_process ' config_velacc '>> ' dataset_path1 'result' '.txt']);
tym = toc;
fprintf('Done: %fs \n',tym);
velacc = read_gdf([dataset_path1 'velacc_velacc.gdf']); 
velacc(:,12:14) = read_gdf([dataset_path1 'velacc_velfluc.gdf']);
velacc(:, 4:5) = velacc(:, [5 4]);
% if SF.enable
%     [statistics_struct, statistics_corr] = CalStructFun(dataset_path1, dataset_path1, SF.redges_lin, SF.redges_log, dataset);
% end
end
%% Functions 

% writing the velacc configuration file
function write_velacc_configFile(dataset_path, framerate, config_velacc, outputfile_velacc, config_vE3Dstruct, config_pairdisp, tot_particles, flag_skip_velacc_Calc )
%     global  dataset_path outputfile_velacc config_velacc config_vE3Dstruct config_pairdisp tot_particles flag_skip_velacc_Calc
    % inputs for velacc config file
%     framerate = 125;
    velfiltwidth = 3;
    accfiltwidth = 3;
    velfiltlen = 14;
    accfiltlen = 14;
    nxbin = 10;
    nybin = 10;
    nzbin = 10;
    filtertype = 'Gaussian';
    flag_pickGoodTracks = 0;
    sigma_pickGoodTracks = 5;
    flag_weighing = 0;

    flag_structfxn = 0;  % Don't use C code to process structure function since it's too slow.

    flag_pairdisp = 0;
%     config_vE3Dstruct = [dataset_path 'config_file_vE3Dstruct.txt']; 
%     config_pairdisp = [dataset_path 'config_file_pairdisp.txt'];

    % writing the file
    if (isfile(config_velacc))
        delete(config_velacc)
    end
    fid = fopen(config_velacc, 'w');
    fprintf(fid,[dataset_path 'tracks.gdf ' '# link to the tracks.txt file from STB \n']); 
    fprintf(fid, '%d # total no. of particles from STB tracks \n', tot_particles); 
%     fprintf(fid, '%d # total no. of tracks from STB \n', tot_tracks); 
    fprintf(fid, '%d # framerate \n', framerate);
    fprintf(fid, '%d # velfilterwidth \n', velfiltwidth);
    fprintf(fid, '%d # accfiltwidth \n', accfiltwidth);
    fprintf(fid, '%d # velfiltlen \n', velfiltlen);
    fprintf(fid, '%d # accfiltlen \n', accfiltlen);
    fprintf(fid, '%d # nxbin \n', nxbin);
    fprintf(fid, '%d # nybin \n', nybin);
    fprintf(fid, '%d # nzbin \n', nzbin);
    fprintf(fid, [filtertype ' # filtertype \n']);
    fprintf(fid, '%d # flag to pick good tracks \n', flag_pickGoodTracks);
    if (flag_pickGoodTracks)
        fprintf(fid, '%d # how many std deviations from mean error of 1000 good tracks to consider? \n', sigma_pickGoodTracks);
    end
    fprintf(fid, '%d # weighing the velocity field based on track size \n', flag_weighing);
    fprintf(fid, [outputfile_velacc ' # outfilename \n']);
    fprintf(fid, '%d # flag to calculate vEstruct3D \n', flag_structfxn);
    fprintf(fid, '%d # flag to skip velacc and only calculate further statistics \n', flag_skip_velacc_Calc);
    fprintf(fid, [config_vE3Dstruct ' # config file for vE3Dstruct \n']);
    fprintf(fid, '%d # flag to calculate pairdisp \n', flag_pairdisp);
    fprintf(fid, [config_pairdisp ' # outfilename \n']);

    fclose(fid);
end


% writing the vE3Dstruct configuration file
function write_vE3Dstruct_configFile(outputfile_velacc, outputfile_vE3DstructOUT, config_vE3Dstruct, last_frame)
%     global dataset_path1  outputfile_velacc outputfile_vE3DstructOUT config_vE3Dstruct
    if (isfile(config_vE3Dstruct))
        delete(config_vE3Dstruct)
    end
    % inputs for vE3Dstruct config file
    flag_rem_mean = 1;
    first_frame = 1;
%     last_frame = 22000;
    max_part_per_frame = 50000;
    vxlim = 2000; %mm/s
    vylim = 2000;
    vzlim = 2000;
    flag_UA_stats = 1;
    flag_UA_Angstats = 0;
    flag_curv_stats = 0;
    DeltaR = 0.5; %mm
    rRatio = 1.12202;
    flag_logbin = 1;
    flag_condition_curv_stats = 0;
    flag_vel_increment_stats = 0;
    flag_CGVG = 0;
    flag_epsT = 0;
    flag_struct_COMconditioned = 0;
    flag_strips = 1;
    strip_direction = 'Z';
    n_strips = 5;

    % writing the file
    fid = fopen(config_vE3Dstruct, 'w');
    fprintf(fid,[outputfile_velacc  '_velacc.gdf # link to the velacc.gdf file from velocity code \n']); 
    fprintf(fid,[outputfile_velacc  '_configparam.gdf # link to the configure parameters gdf  file from velocity code \n']); 
    fprintf(fid,[outputfile_velacc  '_trackstats.gdf # link to the trackstats file from velocity code \n']); 
    fprintf(fid, '%d # flag to remove mean and calculate fluctuations of vel and acc \n', flag_rem_mean); 
    fprintf(fid,[outputfile_velacc  '_vfield.gdf # link to the velfield file from velocity code \n']); 
    fprintf(fid,[outputfile_velacc  '_afield.gdf # link to the accfield file from velocity code \n']); 
    fprintf(fid, '%d # first frame \n', first_frame); 
    fprintf(fid, '%d # last frame \n', last_frame); 
    fprintf(fid, '%d # maximum no. of particles in a frame \n', max_part_per_frame);
    fprintf(fid, '%d # absolute of vxlim (mm/s) \n', vxlim);
    fprintf(fid, '%d # absolute of vxlim (mm/s) \n', vylim);
    fprintf(fid, '%d # absolute of vxlim (mm/s) \n', vzlim);
    fprintf(fid, '%d # flag to compute vel and acc stats \n', flag_UA_stats);
    fprintf(fid, '%d # flag to compute angular conditioned vel and acc stats (if 1, give NAngStat) \n', flag_UA_Angstats);
    fprintf(fid, '%d # flag to compute curv stats \n', flag_curv_stats);
    fprintf(fid,[outputfile_velacc  '_curv.gdf # link to the curv.gdf file from velocity code \n']); 
    fprintf(fid,[outputfile_vE3DstructOUT  ' # rootname for output files \n']); 
    fprintf(fid, '%f # Delta R \n', DeltaR);
    fprintf(fid, '%d # flag to use log of bin size \n', flag_logbin);
    fprintf(fid, '%f # r Ratio \n', rRatio);
    fprintf(fid, '%d # flag to compute conditioned curv stats( if yes, it needs additional inputs ) \n', flag_condition_curv_stats);
    fprintf(fid, '%d # flag to compute vel increment stats( if yes, it needs additional inputs ) \n', flag_vel_increment_stats);
    fprintf(fid, '%d # flag to coarse grained vel. grad. stats \n', flag_CGVG);
    fprintf(fid, '%d # flag to compute energy transfer rate stats ( if yes, it needs additional inputs ) \n', flag_epsT);
    fprintf(fid, '%d # flag to compute Eulerian struct. func. conditioned on the COM vel. ( if yes, it needs additional inputs ) \n', flag_struct_COMconditioned);
    fprintf(fid, '%d # flag to compute stats conditioned on strips \n', flag_strips);
    if (flag_strips)
        fprintf(fid, [strip_direction ' # strip direction \n']);
        fprintf(fid, '%d # no. of strips \n', n_strips);
    end

    fclose(fid);
end
