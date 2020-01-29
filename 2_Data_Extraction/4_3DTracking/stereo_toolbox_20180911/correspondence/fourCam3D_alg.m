function [ settings ] = fourCam3D_alg( settings, cameraSystem, writeToDisk, doShow )
% This function uses subsets of 3 cameras each from the given amount of
% cameras. The numbering of the cameras will be permuted to get the desired
% amount of camera sets. This function can be used with 4 (or more)
% cameras.
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
if nargin<3; writeToDisk=0; doShow=0; end;

% take care that triangulation-sets are given
if ~isfield(settings.triangulation,'sets')
    settings.triangulation.sets = [1 2 3 4];
end


% create subfolders with names of the cameraSets
if writeToDisk
    [pathstr,~,~] = fileparts(settings.output3Dcoords);
    mkdir(pathstr);
    for k = 1:size(settings.triangulation.sets,1)
        mkdir([pathstr sprintf('/cameraSet%d%d%d%d',settings.triangulation.sets(k,:))]);
        % store this path information
        settings.triangulation.outputPaths{k} = [pathstr sprintf('/cameraSet%d%d%d%d',settings.triangulation.sets(k,:))];
    end
end

P = cameraSystem.getProjectionMatrices;


% main loop:
fprintf(1,'Reconstructing particles in frame: ');

for frame = settings.im_range(1):settings.im_range(end)
    fprintf(1,'%05d/%05d', frame, settings.im_range(end));
    
    % load the particle detection result:
    %try
    pdat = dlmread(sprintf(settings.output2Dcoords,frame));
    
    for camNo = 1:cameraSystem.nCameras
        c2d{camNo} = pdat(find(pdat(:,camNo*2-1)),camNo*2-1:camNo*2); % without zeros
    end
    
    % cycle through the camera sets by exchanging the variable names:
    for setNo = 1:size(settings.triangulation.sets,1)
        % get the correct projection matrix names for this cycle and the
        % data sets
        result_all_cycles{setNo} = [];
        
        
        pdat1=c2d{settings.triangulation.sets(setNo,1)};
        pdat2=c2d{settings.triangulation.sets(setNo,2)};
        pdat3=c2d{settings.triangulation.sets(setNo,3)};
        pdat4=c2d{settings.triangulation.sets(setNo,4)};
        
        P1=P(settings.triangulation.sets(setNo,1)).projectionMatrix;
        P2=P(settings.triangulation.sets(setNo,2)).projectionMatrix;
        P3=P(settings.triangulation.sets(setNo,3)).projectionMatrix;
        P4=P(settings.triangulation.sets(setNo,4)).projectionMatrix;
        
        % Fundamental matrices are needed for projections...
        F12 = getFundamental(P1, P2);
        F13 = getFundamental(P1, P3);
        F23 = getFundamental(P2, P3);
        F14 = getFundamental(P1, P4);
        F34 = getFundamental(P3, P4);
        
        % for all particles in cam1
        for p1_ctr = 1:size(pdat1,1)
            % get epipolar line in cam2
            [l2_from1, ~] = projectRay(P2, P1, pdat1(p1_ctr,:), F12);
            
            % find points closest to epipolar line in cam2
            d = dist2line2d(pdat2, l2_from1);
            dmin_idx = find(d <= settings.triangulation.epipolarDistanceAllowed);
            
            % get the corresponding particles (named: candidates)
            candidates_cam2 =  pdat2(dmin_idx,1:2) ;
            
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
                distances_min_idx = find(distances <= settings.triangulation.epipolarDistanceAllowed);
                if ~isempty(distances_min_idx)
                    candidates_cam3 = pdat3(distances_min_idx,:);
                    
                    
                    for p3_ctr = 1:size(candidates_cam3,1)
                        p_c1 = pdat1(p1_ctr,1:2);
                        p_c2 = candidates_cam2(p2_ctr,1:2);
                        p_c3 = candidates_cam3(p3_ctr,1:2);
                        
                        % look for candidates in camera4:
                        % get epipolar line in cam4
                        [l4_from3, ~] = projectRay(P4, P3, candidates_cam3(p3_ctr,:), F34);
                        [l4_from1, ~] = projectRay(P4, P1, pdat1(p1_ctr,:), F14);
                        
                        % get intersection point in camera3
                        Poly1 = l4_from3;
                        Poly2 = l4_from1;
                        inter_cam4 = [ (Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1)) Poly1(1)*(Poly2(2)-Poly1(2))/(Poly1(1)-Poly2(1))+Poly1(2)];
                        
                        % find all particles that are in the allowed distance from that
                        % point:
                        distances = distance2d(pdat4, inter_cam4);
                        distances_min_idx = find(distances <= settings.triangulation.epipolarDistanceAllowed);
                        if ~isempty(distances_min_idx)
                            
                            candidates_cam4 = pdat4(distances_min_idx,:);
                            
                            for p4_ctr = 1:size(candidates_cam4,1)
                                p_c1 = pdat1(p1_ctr,1:2);
                                p_c2 = candidates_cam2(p2_ctr,1:2);
                                p_c3 = candidates_cam3(p3_ctr,1:2);
                                p_c4 = candidates_cam4(p4_ctr,1:2);
                                
                                Pset(1).projectionMatrix = P1;
                                Pset(2).projectionMatrix = P2;
                                Pset(3).projectionMatrix = P3;
                                Pset(4).projectionMatrix = P4;
                                coord3D = triangulateFromNCameras({p_c1 , p_c2, p_c3, p_c4}, Pset);
                                
                                result_all_cycles{setNo} = [ result_all_cycles{setNo} ; coord3D p_c1 p_c2 p_c3 p_c4];
                            end
                        end
                        
                    end
                end
                
            end
        end
        
        
        if writeToDisk
            dlmwrite([sprintf('%s/coords3d_%05d.dat',settings.triangulation.outputPaths{k},frame) ],result_all_cycles{setNo} );
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
    
    %catch
    %disp('2D particle-set could not be read.');
    %end
end
fprintf(1,'[ done ]\n');



end

