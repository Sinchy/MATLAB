function [ result_all_cycles ] = threeCam3D_alg( settings, cameraSystem, writeToDisk, doShow )
% This function needs a 3 camera input. It will check the epipolar line correspondence
% criteria for all particles in all cameras framewise.
% INPUTS:
%   settings: an struct containing path variables and such. Have a look
%             into the do_stereo_recon.m -script, where examples are given.
%   noOutput: The noOutput flag (true or false) triggers the function to
%             write the data to disk.
%   P1, P2, P3: These are the 3x4 projection matrices as introduced by
%             Hartley/Zisserman, "multiple view geometry in computer vision"
%
%--------------------------------------------------------------------------
%     Copyright (C) 2016 Michael Himpel (himpel@physik.uni-greifswald.de)
%     
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------

warning off MATLAB:MKDIR:DirectoryExists
if nargin<4; doShow=0;end;

if writeToDisk
    [pathstr,~,~] = fileparts(settings.output3Dcoords);
    mkdir(pathstr);
    mkdir([pathstr '/cam123']);
    mkdir([pathstr '/cam132']);
    mkdir([pathstr '/cam213']);
    mkdir([pathstr '/cam231']);
    mkdir([pathstr '/cam312']);
    mkdir([pathstr '/cam321']);
end

% prequesites:
[P1, P2, P3] = cameraSystem.getProjectionMatrices;

P1_steady = P1; % The names of the Ps will change - see the "cycling"
P2_steady = P2;
P3_steady = P3;

result_all_cycles = cell(6,1);

if doShow
    % prepare the graphical output
    figure;
    ax_hnd = axes;
    ax_hnd.XLabel.String = 'frame';
    ax_hnd.YLabel.String = 'no. of detected particles';
    ax_hnd.FontSize = 14;
    part_stats = [];
    hold on
end

% main loop:
fprintf(1,'Reconstructing particles in frame: ');

for frame = settings.im_range(1):settings.im_range(end)
    fprintf(1,'%05d/%05d', frame, settings.im_range(end));
    
    % To be capable of using multiset triangulation techniques, we will 
    % compute the epipolar line criteria 6 times:
    % parts in cam1-> look for candidates in cam2 -> look for candidates in
    % cam3
    % parts in cam1-> look for candidates in cam3 -> look for candidates in
    % cam2
    % parts in cam2-> look for candidates in cam1 -> look for candidates in
    % cam3
    % parts in cam2-> look for candidates in cam3 -> look for candidates in
    % cam1
    % parts in cam3-> look for candidates in cam1 -> look for candidates in
    % cam2
    % parts in cam3-> look for candidates in cam2 -> look for candidates in
    % cam1
    %
    % Theoretically, all of theese should get the same results, but in
    % practice one can use clustering methods to filter out ghost
    % particles.
    
    % load the particle detection result:
    try
        pdat = dlmread(sprintf(settings.output2Dcoords,frame));
        
        c1 = pdat(find(pdat(:,1)),1:2); % without zeros...
        c2 = pdat(find(pdat(:,3)),3:4); % without zeros...
        c3 = pdat(find(pdat(:,5)),5:6); % without zeros...
        
        
        % cycle through the 6 permutations by exchanging the variable names:
        for cycle = 1:6
            % get the correct projection matrix names for this cycle and the
            % data sets
            result_all_cycles{cycle} = [];
            
            switch cycle
                case 1,
                    pdat1=c1;pdat2=c2;pdat3=c3;
                    P1=P1_steady;P2=P2_steady;P3=P3_steady;
                case 2,
                    pdat1=c1;pdat2=c3;pdat3=c2;
                    P1=P1_steady;P2=P3_steady;P3=P2_steady;
                case 3,
                    pdat1=c2;pdat2=c1;pdat3=c3;
                    P1=P2_steady;P2=P1_steady;P3=P3_steady;
                case 4,
                    pdat1=c2;pdat2=c3;pdat3=c1;
                    P1=P2_steady;P2=P3_steady;P3=P1_steady;
                case 5,
                    pdat1=c3;pdat2=c1;pdat3=c2;
                    P1=P3_steady;P2=P1_steady;P3=P2_steady;
                case 6,
                    pdat1=c3;pdat2=c2;pdat3=c1;
                    P1=P3_steady;P2=P2_steady;P3=P1_steady;
            end
            
            % Fundamental matrices are needed for projections...
            F12 = getFundamental(P1, P2);
            F13 = getFundamental(P1, P3);
            F23 = getFundamental(P2, P3);
            
            % for all particles in cam1
            for p1_ctr = 1:size(pdat1,1)
                % get epipolar line in cam2
                [l2_from1, ~] = projectRay(P2, P1, pdat1(p1_ctr,:), F12);
                
                % find points closest to epipolar line in cam2
                d = dist2line2d(pdat2, l2_from1);
                dmin_idx = find(d <= settings.params_3CAM3D.epipolar_distance);
                
                % get the corresponding particles (named: candidates)
                candidates_cam2 = [ pdat2(dmin_idx,1:2) ];
                
                % for each candidate, look for a correspondence in cam3
                % This time, two lines intersect (from cam1 and cam2)
                for p2_ctr = 1:size(candidates_cam2,1)
                    % get epipolar line in cam3
                    [l3_from2, ~] = projectRay(P3, P2, candidates_cam2(p2_ctr,:), F23);
                    [l3_from1, ~] = projectRay(P3, P1, pdat1(p1_ctr,:), F13);
                    
                    % get intersection point in camera3
                    Poly1 = l3_from2;
                    Poly2 = l3_from1;
                    inter_cam3 = [ (Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1)) Poly1(1)*(Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1))+Poly1(2)];
                    
                    % find all particles that are in the allowed distance from that
                    % point:
                    dislocations = bsxfun(@minus, pdat3, inter_cam3); % rowwise minus
                    distances = sqrt(sum(abs(dislocations).^2,2));
                    distances_min_idx = find(distances <= settings.params_3CAM3D.epipolar_distance);
                    if ~isempty(distances_min_idx)
                        candidates_cam3 = pdat3(distances_min_idx,:);
                        
                        % put the results in the result array (for each cycle)
                        
                        for p3_ctr = 1:size(candidates_cam3,1)
                            p_c1 = pdat1(p1_ctr,1:2);
                            p_c2 = candidates_cam2(p2_ctr,1:2);
                            p_c3 = candidates_cam3(p3_ctr,1:2);
                            
                            coord3D = triangulateFrom3Cameras(p_c1, p_c2, p_c3, P1, P2, P3);
                            
                            result_all_cycles{cycle} = [ result_all_cycles{cycle} ; coord3D p_c1 p_c2 p_c3];
                        end
                    end
                    
                end
            end
            
            
            
        end
        fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b');
        
        if doShow
            % plot the number of detected particles
            plot_colors = parula(1);
            try delete(plot_hnd1); end
            part_stats = [part_stats size(result_all_cycles{1},1)];
            plot_hnd1 = plot(ax_hnd,part_stats,'Linewidth',2,'Color',plot_colors); hold on;
            ylim auto;
            ax_hnd.YLim(1) = 0;
            drawnow;
        end
        
        if writeToDisk
            dlmwrite([pathstr '/cam123/'  sprintf('coords3d_%05d.dat',frame) ],result_all_cycles{1} );
            dlmwrite([pathstr '/cam132/'  sprintf('coords3d_%05d.dat',frame) ],result_all_cycles{2} );
            dlmwrite([pathstr '/cam213/'  sprintf('coords3d_%05d.dat',frame) ],result_all_cycles{3} );
            dlmwrite([pathstr '/cam231/'  sprintf('coords3d_%05d.dat',frame) ],result_all_cycles{4} );
            dlmwrite([pathstr '/cam312/'  sprintf('coords3d_%05d.dat',frame) ],result_all_cycles{5} );
            dlmwrite([pathstr '/cam321/'  sprintf('coords3d_%05d.dat',frame) ],result_all_cycles{6} );
        end
    catch
        disp('2D particle-set could not be read.');
    end
    
    
    
end
fprintf(1,'[ done ]\n');
