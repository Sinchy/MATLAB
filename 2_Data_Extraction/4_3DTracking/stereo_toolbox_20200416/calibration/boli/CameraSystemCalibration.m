%--------------------------------------------------------------------------
%     Copyright (C) 2013 Bo Li (prclibo@gmail.com)
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
classdef CameraSystemCalibration < handle
    properties
        %
        nCameras;
        isCameraCalibrated;
        fixIntrinsics;
        pattern;
        
        % Mono camera calibrations
        cameraCalibrations;
        
        % System structure
        edgeList;
        vertexList;
        
    end
    methods
        %
        function obj = CameraSystemCalibration(nCameras, pattern)
            obj.nCameras = nCameras;
            obj.pattern = pattern;
            obj.isCameraCalibrated = false(nCameras, 1);
            obj.fixIntrinsics = true;
            
            obj.cameraCalibrations = CameraCalibrationBase.empty(nCameras, 0);
            for ci = 1:nCameras
                obj.cameraCalibrations = CameraCalibrationBase([], [], []);
            end
            
            obj.vertexList = repmat(struct('pose', [], 'key', '\0'), nCameras, 1);
            obj.edgeList = repmat(struct('cameraVertex', 0, 'photoVertex', 0, 'photoIndex', 0, 'transform', []), 0, 1);
            
        end
        
        %
        function obj = setCameraType(obj, cameraIndices, type, width, height)
            if strcmpi(type, 'CataCamera')
                for ci = cameraIndices(:)'
                    obj.cameraCalibrations(ci) = CataCameraCalibration(width, height, obj.pattern);
                end
            elseif strcmpi(type, 'PinholeCamera')
                for ci = cameraIndices(:)'
                    obj.cameraCalibrations(ci) = PinholeCameraCalibration(width, height, obj.pattern);
                end
            else
                error(['Unknown camera type "', type, '"!']);
            end
        end
        %
        function obj = save(obj, name)
            for ci = 1:obj.nCameras
                obj.cameraCalibrations(ci).save([name, '.camera.', num2str(ci), '.mat']);
            end
            
            nCameras = obj.nCameras;
            isCameraCalibrated = obj.isCameraCalibrated;
            edgeList = obj.edgeList;
            vertexList = obj.vertexList;
            pattern = obj.pattern;
            
            save([name, '.mat'], ...
                'nCameras', ...
                'isCameraCalibrated', ...
                'edgeList', ...
                'pattern', ...
                'vertexList');
        end
        
        %
        function obj = load(obj, name)
            for ci = 1:obj.nCameras
                obj.cameraCalibrations(ci).load([name, '.camera.', num2str(ci), '.mat']);
            end
            s = load(name);
            obj.nCameras = s.nCameras;
            obj.isCameraCalibrated = s.isCameraCalibrated;
            obj.edgeList = s.edgeList;
            obj.pattern = s.pattern;
            obj.vertexList = s.vertexList;
            
        end
        
        %
        function obj = addPhoto(obj, cameraIndex, photo, key)
            display(['Camera #', num2str(cameraIndex), ': Adding photo #', key, '...']);
            photoIndex = obj.cameraCalibrations(cameraIndex).addPhoto(photo);
            
            photoVertex = [];
            for i = 1:numel(obj.vertexList)
                if strcmpi(obj.vertexList(i).key, key)
                    photoVertex = i;
                    break;
                end
            end
            
            if isempty(photoVertex)
                obj.vertexList(end + 1) = struct('pose', [], 'key', key);
                photoVertex = numel(obj.vertexList);
            end
            
            obj.edgeList(end + 1) = struct('cameraVertex', cameraIndex, 'photoVertex', photoVertex, 'photoIndex', photoIndex, 'transform', []);
        end
        
        %
        function obj = calibrate(obj)
            obj.initializeVertices();
            %             obj.visualizeObjects();
            obj.outputExtrinsics();
            
            if obj.fixIntrinsics
                obj.optimizeExtrinsics();
            else
                obj.optimizeFully();
            end
        end
        
        %
        function obj = initializeVertices(obj)
            
            for ci = 1:obj.nCameras
                display(['Initialize Camera #', num2str(ci), '...']);
                if obj.isCameraCalibrated(ci)
                    display('....Using user provided data. ');
                    continue;
                end
                obj.cameraCalibrations(ci).calibrate();
                obj.isCameraCalibrated(ci) = true;
            end
            
            kept = [];
            for i = 1:numel(obj.edgeList)
                cameraIndex = obj.edgeList(i).cameraVertex;
                photoIndex = obj.edgeList(i).photoIndex;
                if ~obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).valid
                    continue;
                end
                
                rvec = obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).rvec;
                tvec = obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).tvec;
                R = rodrigues(rvec);
                t = tvec;
                obj.edgeList(i).transform = [R, t; 0, 0, 0, 1];
                kept(end + 1) = i;
            end
            obj.edgeList = obj.edgeList(kept);
            
            
            nVertices = numel(obj.vertexList);
            nEdges = numel(obj.edgeList);
            
            v1 = [obj.edgeList(:).cameraVertex];
            v2 = [obj.edgeList(:).photoVertex];
            edgeIndices = 1:nEdges;
            
            G = sparse(v1, v2, edgeIndices, nVertices, nVertices);
            G = G + G';
            [order, pred] = graphtraverse(G, 1, 'Method', 'BFS');
            if sum(isnan(pred(1:obj.nCameras))) > 0
                error('Some cameras are not connected in the calibration. ');
            end
            
            G = full(G);
            obj.vertexList(1).pose = eye(4);
            for vertexIndex = order(2:end)
                predPose = obj.vertexList(pred(vertexIndex)).pose;
                edgeIndex = G(vertexIndex, pred(vertexIndex));
                transform = obj.edgeList(edgeIndex).transform;
                
                if vertexIndex <= obj.nCameras
                    obj.vertexList(vertexIndex).pose = transform * inv(predPose);
                else
                    obj.vertexList(vertexIndex).pose = predPose \ transform;
                end
                
            end
        end
        
        %
        function obj = optimizeExtrinsics(obj)
            display('Optimizing extrinsics...');
            p = obj.getVertexPoseVector();
            
            objective = @(x) obj.extrinsicsObjective(x);
            
            
            %             options=optimset('Display','iter',...
            %                  'DerivativeCheck','on',...
            %                  'Jacobian','on',...
            %                  'MaxIter',10000, 'MaxFunEvals', 20000, 'TolX', 1e-6, 'TolFun', 1e-6, 'Algorithm', 'trust-region-reflective');
            options=optimset('Display','iter',...
                'DerivativeCheck','off',...
                'Jacobian','on',...
                'MaxIter',10000, 'MaxFunEvals', 20000, 'TolX', 1e-4, 'TolFun', 1e-4, 'Algorithm', 'levenberg-marquardt');
            
            
            [p_res, ~, error] = lsqnonlin(objective, p, [], [], options);
            %             error = mean(sqrt(sum(reshape(error, 2, []).^2)));
            error = sqrt(mean(error(:).^2));
            error
            
            obj.setVertexPoseVector(p_res);
            
            
        end
        
        %
        function obj = optimizeFully(obj)
            display('Optimizing both extrinsics and intrinsics. This maybe very slow...');
            p = [];
            
            for ci = 1:obj.nCameras
                p = [p; obj.cameraCalibrations(ci).camera.toParamVector()];
            end
            offset = length(p);
            
            p = [p; obj.getVertexPoseVector()];
            
            objective = @(x) obj.fullObjective(x);
            
            %             options=optimset('Display','iter',...
            %                  'DerivativeCheck','off',...
            %                  'Jacobian','off',...
            %                  'MaxIter',10000, 'MaxFunEvals', 20000, 'TolX', 1e-4, 'TolFun', 1e-4, 'Algorithm', 'trust-region-reflective');
            options=optimset('Display','iter',...
                'DerivativeCheck','off',...
                'Jacobian','on',...
                'MaxIter',2000, 'MaxFunEvals', 20000, 'TolX', 1e-4, 'TolFun', 1e-4, 'Algorithm', 'levenberg-marquardt');
            
            [p_res, ~, error] = lsqnonlin(objective, p, [], [], options);
            %             error = mean(sqrt(sum(reshape(error, 2, []).^2)));
            error = sqrt(mean(error(:).^2));
            
            error
            
            offset = 0;
            for ci = 1:obj.nCameras
                nParams = obj.cameraCalibrations(ci).camera.nParams;
                obj.cameraCalibrations(ci).camera.fromParamVector(p(offset + (1:nParams)));
                offset = offset + nParams;
            end
            
            
            obj.setVertexPoseVector(p_res(offset + 1:end));
            
        end
        
        %
        function [error, jacob] = fullObjective(obj, p)
            
            offset = 0;
            cameraColEnd = zeros(obj.nCameras, 1);
            for ci = 1:obj.nCameras
                nParams = obj.cameraCalibrations(ci).camera.nParams;
                
                obj.cameraCalibrations(ci).camera.fromParamVector(p(offset + (1:nParams)));
                offset = offset + nParams;
                cameraColEnd(ci) = nParams;
            end
            cameraColEnd = [0; cumsum(cameraColEnd)];
            
            p = p(offset + 1:end);
            
            obj.setVertexPoseVector(p);
            nEdges = numel(obj.edgeList);
            nVertices = numel(obj.vertexList);
            
            
            rowEnd = zeros(nEdges, 1);
            for i = 1:nEdges
                cameraVertex = obj.edgeList(i).cameraVertex;
                cameraIndex = cameraVertex;
                photoIndex = obj.edgeList(i).photoIndex;
                
                rowEnd(i) = obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).nPoints;
            end
            rowEnd = rowEnd * 2;
            rowEnd = [0; cumsum(rowEnd)];
            
            vertexIndex2ParamIndex = zeros(nVertices, 1);
            count = 0;
            for i = 2:nVertices
                if isempty(obj.vertexList(i).pose)
                    continue;
                end
                count = count + 1;
                vertexIndex2ParamIndex(i) = count;
            end
            
            error = [];
            jacobPose = zeros(rowEnd(end), numel(p));
            jacobCamera = zeros(rowEnd(end), offset);
            for i = 1:nEdges
                cameraVertex = obj.edgeList(i).cameraVertex;
                photoVertex = obj.edgeList(i).photoVertex;
                cameraIndex = cameraVertex;
                photoIndex = obj.edgeList(i).photoIndex;
                nPoints = obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).nPoints;
                
                H1 = obj.vertexList(cameraVertex).pose;
                H2 = obj.vertexList(photoVertex).pose;
                H = H1 * H2;
                R = H(1:3, 1:3);
                t = H(1:3, 4);
                
                R1 = H1(1:3, 1:3);
                R2 = H2(1:3, 1:3);
                r1 = rodrigues(R1);
                [~, pR1_dr1] = rodrigues(r1);
                r2 = rodrigues(R2);
                [~, pR2_dr2] = rodrigues(r2);
                
                [pH_dH1, pH_dH2] = dAB(H1, H2);
                pH_dR1 = pH_dH1(:, [1, 2, 3, 5, 6, 7, 9, 10, 11]);
                pH_dR2 = pH_dH2(:, [1, 2, 3, 5, 6, 7, 9, 10, 11]);
                pH_dt1 = pH_dH1(:, [13, 14, 15]);
                pH_dt2 = pH_dH2(:, [13, 14, 15]);
                
                
                
                [r, pr_dR] = rodrigues(R);
                obj.cameraCalibrations(cameraIndex).setPoseVector([r; t], photoIndex);
                
                [each_error, J_pose, J_camera] = obj.cameraCalibrations(cameraIndex).computeReprojError(photoIndex);
                perror_dR = J_pose(:, 1:3) * pr_dR;
                perror_dt = J_pose(:, 4:6);
                perror_dH = zeros(2 * nPoints, 16);
                perror_dH(:, [1, 2, 3, 5, 6, 7, 9, 10, 11]) = perror_dR;
                perror_dH(:, [13, 14, 15]) = perror_dt;
                perror_dr1 = perror_dH * pH_dR1 * pR1_dr1;
                perror_dr2 = perror_dH * pH_dR2 * pR2_dr2;
                perror_dt1 = perror_dH * pH_dt1;
                perror_dt2 = perror_dH * pH_dt2;
                if cameraVertex > 1
                    index = vertexIndex2ParamIndex(cameraVertex);
                    jacobPose(rowEnd(i) + 1:rowEnd(i + 1), (index - 1) * 6 + (1:6)) = [perror_dr1, perror_dt1];
                end
                index = vertexIndex2ParamIndex(photoVertex);
                jacobPose(rowEnd(i) + 1:rowEnd(i + 1), (index - 1) * 6 + (1:6)) = [perror_dr2, perror_dt2];
                
                jacobCamera(rowEnd(i) + 1:rowEnd(i + 1), cameraColEnd(cameraVertex) + 1:cameraColEnd(cameraVertex + 1)) = J_camera;
                
                
                error = [error; each_error];
            end
            jacob = [jacobCamera, jacobPose];
            jacob = sparse(jacob);
        end
        
        %
        function [error, jacobPose] = extrinsicsObjective(obj, p)
            obj.setVertexPoseVector(p);
            nEdges = numel(obj.edgeList);
            nVertices = numel(obj.vertexList);
            
            rowEnd = zeros(nEdges, 1);
            for i = 1:nEdges
                cameraVertex = obj.edgeList(i).cameraVertex;
                cameraIndex = cameraVertex;
                photoIndex = obj.edgeList(i).photoIndex;
                
                rowEnd(i) = obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).nPoints;
            end
            rowEnd = rowEnd * 2;
            rowEnd = [0; cumsum(rowEnd)];
            
            vertexIndex2ParamIndex = zeros(nVertices, 1);
            count = 0;
            for i = 2:nVertices
                if isempty(obj.vertexList(i).pose)
                    continue;
                end
                count = count + 1;
                vertexIndex2ParamIndex(i) = count;
            end
            error = [];
            jacobPose = zeros(rowEnd(end), numel(p));
            for i = 1:nEdges
                cameraVertex = obj.edgeList(i).cameraVertex;
                photoVertex = obj.edgeList(i).photoVertex;
                cameraIndex = cameraVertex;
                photoIndex = obj.edgeList(i).photoIndex;
                nPoints = obj.cameraCalibrations(cameraIndex).photosInfo(photoIndex).nPoints;
                
                H1 = obj.vertexList(cameraVertex).pose;
                H2 = obj.vertexList(photoVertex).pose;
                H = H1 * H2;
                R = H(1:3, 1:3);
                t = H(1:3, 4);
                
                R1 = H1(1:3, 1:3);
                R2 = H2(1:3, 1:3);
                r1 = rodrigues(R1);
                [~, pR1_dr1] = rodrigues(r1);
                r2 = rodrigues(R2);
                [~, pR2_dr2] = rodrigues(r2);
                
                [pH_dH1, pH_dH2] = dAB(H1, H2);
                pH_dR1 = pH_dH1(:, [1, 2, 3, 5, 6, 7, 9, 10, 11]);
                pH_dR2 = pH_dH2(:, [1, 2, 3, 5, 6, 7, 9, 10, 11]);
                pH_dt1 = pH_dH1(:, [13, 14, 15]);
                pH_dt2 = pH_dH2(:, [13, 14, 15]);
                
                
                
                [r, pr_dR] = rodrigues(R);
                obj.cameraCalibrations(cameraIndex).setPoseVector([r; t], photoIndex);
                
                [each_error, J_pose] = obj.cameraCalibrations(cameraIndex).computeReprojError(photoIndex);
                perror_dR = J_pose(:, 1:3) * pr_dR;
                perror_dt = J_pose(:, 4:6);
                perror_dH = zeros(2 * nPoints, 16);
                perror_dH(:, [1, 2, 3, 5, 6, 7, 9, 10, 11]) = perror_dR;
                perror_dH(:, [13, 14, 15]) = perror_dt;
                perror_dr1 = perror_dH * pH_dR1 * pR1_dr1;
                perror_dr2 = perror_dH * pH_dR2 * pR2_dr2;
                perror_dt1 = perror_dH * pH_dt1;
                perror_dt2 = perror_dH * pH_dt2;
                if cameraVertex > 1
                    index = vertexIndex2ParamIndex(cameraVertex);
                    jacobPose(rowEnd(i) + 1:rowEnd(i + 1), (index - 1) * 6 + (1:6)) = [perror_dr1, perror_dt1];
                end
                index = vertexIndex2ParamIndex(photoVertex);
                jacobPose(rowEnd(i) + 1:rowEnd(i + 1), (index - 1) * 6 + (1:6)) = [perror_dr2, perror_dt2];
                
                error = [error; each_error];
            end
        end
        
        %
        function p = getVertexPoseVector(obj)
            nVertices = numel(obj.vertexList);
            p = [];
            for i = 2:nVertices
                if isempty(obj.vertexList(i).pose)
                    continue;
                end
                H = obj.vertexList(i).pose;
                rvec = rodrigues(H(1:3, 1:3));
                tvec = H(1:3, 4);
                p = [p; rvec(:); tvec(:)];
            end
        end
        
        %
        function obj = setVertexPoseVector(obj, p)
            nVertices = numel(obj.vertexList);
            offset = 0;
            for i = 2:nVertices
                if isempty(obj.vertexList(i).pose)
                    continue;
                end
                rvec = p(offset + (1:3));
                tvec = p(offset + (4:6));
                H = eye(4);
                H(1:3, 1:3) = rodrigues(rvec);
                H(1:3, 4) = tvec;
                obj.vertexList(i).pose = H;
                offset = offset + 6;
            end
        end
        
        %
        function visualizeObjects(obj)
            width = size(obj.pattern, 2);
            height = size(obj.pattern, 1);
            
            figure; hold on
            
            for i = 1:obj.nCameras
                if isempty(obj.vertexList(i).pose)
                    continue;
                end
                
                H = inv(obj.vertexList(i).pose);
                
                C = H(1:3, 4);
                camLabel = sprintf('CAM%d',i);
                plotCamera('Location',C, 'Label',camLabel, ...
                    'Size', 20, 'Orientation', obj.vertexList(i).pose(1:3,1:3) );
            end
            
            for i = obj.nCameras + 1:numel(obj.vertexList)
                if isempty(obj.vertexList(i).pose)
                    continue;
                end
                
                H = obj.vertexList(i).pose;
                
                rect = [-width/2, width/2,  width/2, -width/2, -width/2;
                    -height/2, -height/2, height/2, height/2, -height/2;
                    0,     0,      0,      0, 0;
                    1,     1,      1,      1, 1];
                
                rect = H * rect;
                
                plot3(rect(1, :), rect(2, :), rect(3, :), 'b', 'linewidth', 0.5);
            end
            
            xlabel('x(mm)');
            ylabel('y(mm)');
            zlabel('z(mm)');
            
            box on
            view([45 45])
            axis equal
            axis tight
        end
        
        function obj = setPPshift( obj, shift, camNo )
            shift_x = shift(1);
            shift_y = shift(2);
            obj.cameraCalibrations(camNo).camera.u0 = obj.cameraCalibrations(camNo).camera.u0 -shift_x;
            obj.cameraCalibrations(camNo).camera.v0 = obj.cameraCalibrations(camNo).camera.v0 -shift_y;
        end
        
        function obj = resetPP( obj)
            for k = 1:obj.nCameras
                width  = obj.cameraCalibrations(k).camera.width;
                height = obj.cameraCalibrations(k).camera.height;
                obj.cameraCalibrations(k).camera.u0 = width/2;
                obj.cameraCalibrations(k).camera.v0 = height/2;
            end
            fprintf(1,'Principal Point has been reset to image center.\n');
        end
        
        %
        function visualizeGraph(obj)
            nVertices = numel(obj.vertexList);
            nEdges = numel(obj.edgeList);
            
            v1 = [obj.edgeList(:).cameraVertex];
            v2 = [obj.edgeList(:).photoVertex];
            edgeIndices = 1:nEdges;
            
            G = sparse(v1, v2, edgeIndices, nVertices, nVertices);
            label = cell(nVertices, 1);
            for ci = 1:obj.nCameras
                label{ci} = ['Cam#', num2str(ci)];
            end
            for i = obj.nCameras + 1:nVertices
                label{i} = ['Pat#', num2str(i)];
            end
            graph = biograph(G, label,  'LayoutType', 'equilibrium', 'LayoutScale', 0.8, 'ShowArrow', 'off');
            for ci = 1:obj.nCameras
                graph.Nodes(ci).LineColor = [1, 0, 0];
            end
            view(graph);
            
        end
        
        %
        function outputExtrinsics(obj)
            display('Extrinsics: ');
            for ci = 1:obj.nCameras
                display(['Camera #', num2str(ci),' :']);
                H = obj.vertexList(ci).pose;
                %                 H(1:3, 4) = H(1:3, 4) / norm(H(1:3, 4));
                display(num2str(H));
            end
        end
        
        %
        function outputIntrinsics(obj)
            for ci = 1:obj.nCameras
                display(['Camera #', num2str(ci),' :']);
                obj.cameraCalibrations(ci).camera.outputIntrinsics();
            end
        end
        
        function alignSystemToCenter(obj)
            % this method translates the system, so that the intersection
            % of the principal rays lies in the coordinate origin
            
            % take the principal rays from the first 2 cameras and get the
            % intersection point
            P = getProjectionMatrices(obj);
            
            pp1 = [obj.cameraCalibrations(1).camera.u0 obj.cameraCalibrations(1).camera.v0];
            pp2 = [obj.cameraCalibrations(2).camera.u0 obj.cameraCalibrations(2).camera.v0];
            
            P1 = P(1).projectionMatrix;
            P2 = P(2).projectionMatrix;
            shiftOrigin = triangulateFrom2Cameras(pp1, pp2, P1,P2 , getFundamental(P1,P2));
            
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % situation is as follows: cam #1 is the coordinate origin, with the
            % z-axis being the camera's principal axis
            
            % (1) translate camera "end-1" to origin
            for k = 1:obj.nCameras
                Tcell{k} = -Rcell{k}*(Ccell{k}-shiftOrigin(1:3));
            end
            
            % move camera system 
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k} , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % shift marker-objects accordingly
            for k = obj.nCameras+1 : length(obj.vertexList)
                if ~isempty(obj.vertexList(k).pose)
                    % translate:
                    obj.vertexList(k).pose = [diag([1 1 1]) -shiftOrigin(1:3) ; 0 0 0 1]*obj.vertexList(k).pose;
                end
            end
            
            
        end
        
        
        function alignSystemPFC(obj)
            fprintf(1,'This method rotates and shifts the camera system with the following results:\n');
            fprintf(1,'1. The principal rays of all cameras intersect at [0 0 0]\n');
            fprintf(1,'2. Camera 2''s principal ray points along the x-z-plane\n');
            fprintf(1,'3. The last 2 cameras lie in the x-y-plane\n');
            
            Ccell = cell(obj.nCameras,1);
            Rcell = cell(obj.nCameras,1);
            Tcell = cell(obj.nCameras,1);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % situation is as follows: cam #1 is the coordinate origin, with the
            % z-axis being the camera's principal axis
            
            % (1) translate camera "end-1" to origin
            for k = 1:obj.nCameras
                Tcell{k} = -Rcell{k}*(Ccell{k}-Ccell{obj.nCameras-1});
            end
            shift1 = -Ccell{obj.nCameras-1};
            
            % move camera system and images
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k} , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % rotate system to get cam(end) and cam(end-1) into the
            % x-y-plane
            
            pYZ = ( Ccell{obj.nCameras}-Ccell{obj.nCameras-1} ).*[ 0; 1; 1];
            % angle between y axis and it's projection pYZ
            phi_x = acos([0  1  0]*pYZ / (norm([0 ; 1 ; 0])*norm(pYZ)));
            
            % rotation matrix for this:
            R_x = rodrigues(-phi_x*[1 ; 0 ; 0]);
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_x , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % get new positions:
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % get the camera(end-1)'s principal ray to the x-z-plane
            % (rotate around z)
            
            % get principal ray from camera 2
            [~, P2, ~] = getProjectionMatrices(obj);
            % decompose matrices
            
            % (5) - do some decomposition on camera matrices
            M2 = P2(1:3,1:3); m2_3 = M2(3,:)';
            pr2 = det(M2)*m2_3;
            pr2 = pr2./norm(pr2); % better numerics
            pXY = ( pr2 ).*[ 1; 1; 0];
            % angle between y axis and it's projection pYZ
            phi_z = acos([1  0  0]*pXY / (norm([1 ; 0 ; 0])*norm(pXY)));
            
            % rotation matrix for this:
            R_z = rodrigues(phi_z*[0 ; 0 ; 1]);
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_z , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % find the intersectionpoint of all three cams and translate it
            % to the origin [0 0 0]
            [P1, P2, P3] = getProjectionMatrices(obj);
            pp1 = [obj.cameraCalibrations(1).camera.u0 obj.cameraCalibrations(1).camera.v0];
            pp2 = [obj.cameraCalibrations(2).camera.u0 obj.cameraCalibrations(2).camera.v0];
            pp3 = [obj.cameraCalibrations(3).camera.u0 obj.cameraCalibrations(3).camera.v0];
            shiftOrigin = triangulateFrom3Cameras(pp1, pp2, pp3, P1, P2, P3);
            
            % get new positions:
            for k =1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                Tcell{k} = -Rcell{k}*(Ccell{k} - shiftOrigin');
                obj.vertexList(k).pose =  [ Rcell{k} , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            
            % apply to marker images:
            for k = obj.nCameras+1 : length(obj.vertexList)
                if ~isempty(obj.vertexList(k).pose)
                    % translate
                    obj.vertexList(k).pose = [diag([1 1 1]) shift1 ; 0 0 0 1]*obj.vertexList(k).pose;
                    % rotate
                    obj.vertexList(k).pose = [R_x , [0 ; 0 ; 0] ; 0 0 0 1 ] * [R_z , [0 ; 0 ; 0] ; 0 0 0 1 ]*obj.vertexList(k).pose;
                    % translate:
                    obj.vertexList(k).pose = [diag([1 1 1]) -shiftOrigin' ; 0 0 0 1]*obj.vertexList(k).pose;
                end
            end
            
        end
        
        function alignSystemRectangular(obj)
            fprintf(1,'Cameras are aligned in Mulle-style\n');
            
            Ccell = cell(obj.nCameras,1);
            Rcell = cell(obj.nCameras,1);
            Tcell = cell(obj.nCameras,1);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % get cameras 1 and 3 into the x-y-plane
            % (1) translate camera 1 to origin
            for k = 1:obj.nCameras
                Tcell{k} = -Rcell{k}*(Ccell{k}-Ccell{1});
            end
            shift1 = -Ccell{1}; % keep in mind for later
            
            % move camera system and images
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k} , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % (2) get the camera1's principal ray to the x-y-plane
            % (rotate around x)
            
            % get principal ray from camera 1
            [P1, ~, ~] = getProjectionMatrices(obj);
            % decompose matrices
            
            % (5) - do some decomposition on camera matrices
            M1 = P1(1:3,1:3); m1_3 = M1(3,:)';
            pr1 = det(M1)*m1_3;
            pr1 = pr1./norm(pr1); % better numerics
            pYZ = ( pr1 ).*[ 0; 1; 1];
            % angle between y axis and it's projection pYZ
            phi_x = acos([0  1  0]*pYZ / (norm([0 ; 1 ; 0])*norm(pYZ)));
            
            % rotation matrix for this:
            R_x = rodrigues(+phi_x*[1 ; 0 ; 0]);
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_x , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            
            % rotate system to get cam1 and cam3 into the
            % x-y-plane (cam1 is already there(0 0 0) )
            
            pXZ = ( Ccell{3}-Ccell{1} ).*[ 1; 0; 1];
            % angle between x axis and it's projection pXZ
            phi_y = acos([1  0  0]*pXZ / (norm([1 ; 0 ; 0])*norm(pXZ)));
            
            % rotation matrix for this:
            R_y = rodrigues(-phi_y*[0 ; 1 ; 0]);
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_y , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % get new positions:
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % get the camera1's principal ray to the y-z-plane
            % (rotate around z)
            
            % get principal ray from camera 1
            [P1, ~, ~] = getProjectionMatrices(obj);
            % decompose matrices
            
            % (5) - do some decomposition on camera matrices
            M1 = P1(1:3,1:3); m1_3 = M1(3,:)';
            pr1 = det(M1)*m1_3;
            pr1 = pr1./norm(pr1); % better numerics
            pXY = ( pr1 ).*[ 1; 1; 0];
            % angle between y axis and it's projection pXY
            phi_z = acos([0  1  0]*pXY / (norm([0 ; 1 ; 0])*norm(pXY)));
            
            % rotation matrix for this:
            R_z = rodrigues(-phi_z*[0 ; 0 ; 1]);
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_z , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            
            % find the intersectionpoint of all three cams and translate it
            % to the origin [0 0 0]
            [P1, P2, P3] = getProjectionMatrices(obj);
            pp1 = [obj.cameraCalibrations(1).camera.u0 obj.cameraCalibrations(1).camera.v0];
            pp2 = [obj.cameraCalibrations(2).camera.u0 obj.cameraCalibrations(2).camera.v0];
            pp3 = [obj.cameraCalibrations(3).camera.u0 obj.cameraCalibrations(3).camera.v0];
            shiftOrigin = triangulateFrom3Cameras(pp1, pp2, pp3, P1, P2, P3);
            
            % get new positions:
            for k =1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                Tcell{k} = -Rcell{k}*(Ccell{k} - shiftOrigin');
                obj.vertexList(k).pose =  [ Rcell{k} , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % apply to marker images:
            for k = obj.nCameras+1 : length(obj.vertexList)
                if ~isempty(obj.vertexList(k).pose)
                    % rotate
                    obj.vertexList(k).pose = [R_x , [0 ; 0 ; 0] ; 0 0 0 1 ]  *[R_y , [0 ; 0 ; 0] ; 0 0 0 1 ] * [R_z , [0 ; 0 ; 0] ; 0 0 0 1 ]*obj.vertexList(k).pose;
                    % translate:
                    obj.vertexList(k).pose = [diag([1 1 1]) shiftOrigin' ; 0 0 0 1]*obj.vertexList(k).pose;
                end
            end
            
        end
        
        function [RR ] = alignSystemCams12ToXY(obj)
            % rotate cameras 1 and 2 to the XY-Plane
            
            %get the camera1's principal ray to the x-y-plane
            % (rotate around x)
            
            % get principal ray from camera 1
            
            P = getProjectionMatrices(obj);
            P1 = P(1).projectionMatrix;
            % decompose matrices
            
            % (5) - do some decomposition on camera matrices
            M1 = P1(1:3,1:3); m1_3 = M1(3,:)';
            pr1 = det(M1)*m1_3;
            pr1 = pr1./norm(pr1); % better numerics
            pYZ = ( pr1 ).*[ 0; 1; 1];
            % angle between y axis and it's projection pYZ
            phi_x = acos([0  1  0]*pYZ / (norm([0 ; 1 ; 0])*norm(pYZ)));
            
            % rotation matrix for this:
            R_x = rodrigues(+phi_x*[1 ; 0 ; 0]);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_x , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % (rotate about y)
            % get principal ray from camera 2
            
            P = getProjectionMatrices(obj);
            P2 = P(2).projectionMatrix;
            % decompose matrices
            
            % - do some decomposition on camera matrices
            M2 = P2(1:3,1:3); m2_3 = M2(3,:)';
            pr2 = det(M2)*m2_3;
            pr2 = pr2./norm(pr2); % better numerics
            pXZ = ( pr2 ).*[ 1; 0; 1];
            % angle between x axis and it's projection pXZ
            phi_y = acos([1  0  0]*pXZ / (norm([1 ; 0 ; 0])*norm(pXZ)));
            
            % rotation matrix for this:
            R_y = rodrigues(+phi_y*[0 ; 1 ; 0]);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_y , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % apply to marker images:
            for k = obj.nCameras+1 : length(obj.vertexList)
                if ~isempty(obj.vertexList(k).pose)
                    % rotate
                    obj.vertexList(k).pose = [R_x , [0 ; 0 ; 0] ; 0 0 0 1 ]*[R_y , [0 ; 0 ; 0] ; 0 0 0 1 ] * obj.vertexList(k).pose;
                    % translate:
                    %obj.vertexList(k).pose = [diag([1 1 1]) shiftOrigin' ; 0 0 0 1]*obj.vertexList(k).pose;
                end
            end
            RR = R_x*R_y;
            
        end
        
         function [RR ] = alignSystemCams14ToXY(obj)
            % rotate cameras 1 and 4 to the XY-Plane
            
            %get the camera1's principal ray to the x-y-plane
            % (rotate around x)
            
            % get principal ray from camera 1
            
            P = getProjectionMatrices(obj);
            P1 = P(1).projectionMatrix;
            % decompose matrices
            
            % (5) - do some decomposition on camera matrices
            M1 = P1(1:3,1:3); m1_3 = M1(3,:)';
            pr1 = det(M1)*m1_3;
            pr1 = pr1./norm(pr1); % better numerics
            pYZ = ( pr1 ).*[ 0; 1; 1];
            % angle between y axis and it's projection pYZ
            phi_x = acos([0  1  0]*pYZ / (norm([0 ; 1 ; 0])*norm(pYZ)));
            
            % rotation matrix for this:
            R_x = rodrigues(+phi_x*[1 ; 0 ; 0]);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_x , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % (rotate about y)
            % get principal ray from camera 2
            
            P = getProjectionMatrices(obj);
            P2 = P(4).projectionMatrix;
            % decompose matrices
            
            % - do some decomposition on camera matrices
            M2 = P2(1:3,1:3); m2_3 = M2(3,:)';
            pr2 = det(M2)*m2_3;
            pr2 = pr2./norm(pr2); % better numerics
            pXZ = ( pr2 ).*[ 1; 0; 1];
            % angle between x axis and it's projection pXZ
            phi_y = acos([1  0  0]*pXZ / (norm([1 ; 0 ; 0])*norm(pXZ)));
            
            % rotation matrix for this:
            R_y = rodrigues(+phi_y*[0 ; 1 ; 0]);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_y , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % apply to marker images:
            for k = obj.nCameras+1 : length(obj.vertexList)
                if ~isempty(obj.vertexList(k).pose)
                    % rotate
                    obj.vertexList(k).pose = [R_x , [0 ; 0 ; 0] ; 0 0 0 1 ]*[R_y , [0 ; 0 ; 0] ; 0 0 0 1 ] * obj.vertexList(k).pose;
                    % translate:
                    %obj.vertexList(k).pose = [diag([1 1 1]) shiftOrigin' ; 0 0 0 1]*obj.vertexList(k).pose;
                end
            end
            RR = R_x*R_y;
            
         end
        
         function [RR ] = alignSystemCams24ToXY(obj)
            % rotate cameras 2 and 4 to the XY-Plane
            
            %get the camera1's principal ray to the x-y-plane
            % (rotate around x)
            
            % get principal ray from camera 1
            
            P = getProjectionMatrices(obj);
            P1 = P(2).projectionMatrix;
            % decompose matrices
            
            % (5) - do some decomposition on camera matrices
            M1 = P1(1:3,1:3); m1_3 = M1(3,:)';
            pr1 = det(M1)*m1_3;
            pr1 = pr1./norm(pr1); % better numerics
            pYZ = ( pr1 ).*[ 0; 1; 1];
            % angle between y axis and it's projection pYZ
            phi_x = acos([0  1  0]*pYZ / (norm([0 ; 1 ; 0])*norm(pYZ)));
            
            % rotation matrix for this:
            R_x = rodrigues(+phi_x*[1 ; 0 ; 0]);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_x , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            % (rotate about y)
            % get principal ray from camera 2
            
            P = getProjectionMatrices(obj);
            P2 = P(4).projectionMatrix;
            % decompose matrices
            
            % - do some decomposition on camera matrices
            M2 = P2(1:3,1:3); m2_3 = M2(3,:)';
            pr2 = det(M2)*m2_3;
            pr2 = pr2./norm(pr2); % better numerics
            pXZ = ( pr2 ).*[ 1; 0; 1];
            % angle between x axis and it's projection pXZ
            phi_y = acos([1  0  0]*pXZ / (norm([1 ; 0 ; 0])*norm(pXZ)));
            
            % rotation matrix for this:
            R_y = rodrigues(+phi_y*[0 ; 1 ; 0]);
            
            for k = 1:obj.nCameras
                Rcell{k} = obj.vertexList(k).pose(1:3,1:3);
                Tcell{k} = obj.vertexList(k).pose(1:3,4);
                Ccell{k} = -Rcell{k}'*Tcell{k};
            end
            
            for k = 1:obj.nCameras
                obj.vertexList(k).pose =  [ Rcell{k}*R_y , ...
                    Tcell{k} ; 0 0 0 1];
            end
            
            % apply to marker images:
            for k = obj.nCameras+1 : length(obj.vertexList)
                if ~isempty(obj.vertexList(k).pose)
                    % rotate
                    obj.vertexList(k).pose = [R_x , [0 ; 0 ; 0] ; 0 0 0 1 ]*[R_y , [0 ; 0 ; 0] ; 0 0 0 1 ] * obj.vertexList(k).pose;
                    % translate:
                    %obj.vertexList(k).pose = [diag([1 1 1]) shiftOrigin' ; 0 0 0 1]*obj.vertexList(k).pose;
                end
            end
            RR = R_x*R_y;
            
        end
        
        function [ P1, P2, P3  ] = getProjectionMatrices( obj )
            % This function extracts the projection matrices from the
            % cameraSystem-object generated by the calibration routine.
            
            
            for nCam = 1: obj.nCameras
                
                % get camera matrix (intrinsic)
                cam_intr = obj.cameraCalibrations(nCam).camera;
                
                % get camera matrix (extrinsic)
                KK = [ cam_intr.gamma1,         1,           cam_intr.u0 ; ...
                    0                 cam_intr.gamma2,    cam_intr.v0 ; ...
                    0                         0,                  1     ];
                
                extr = obj.vertexList(nCam).pose;
                
                % compose to 3x4 projection matrix
                projectionMatrices(nCam).projectionMatrix = KK * extr(1:3,:);
            end
            
            if nargout==3
                P1 = projectionMatrices(1).projectionMatrix;
                P2 = projectionMatrices(2).projectionMatrix;
                P3 = projectionMatrices(3).projectionMatrix;
            else
                P1 = projectionMatrices;
                
            end
            
        end
        
        function obj = cutOffOutliers(obj)
            
            % threshold
            tresh = input('Want to cut the outliers? [px] : ');
            
            % plot the outliers
            for k = 1:obj.nCameras
                figure('Name', sprintf('Camera %d',k));
                for imNo = 1:numel(obj.cameraCalibrations(k).photosInfo)
                    try % inactive images produce errors here
                        error = obj.cameraCalibrations(k).computeReprojError(imNo);
                        error = reshape(error, [],2 );
                        if tresh
                            mn_error = sqrt(error(:,1).^2 + error(:,2).^2);
                            idx_to_cut = mn_error>tresh;
                            obj.cameraCalibrations(k).photosInfo(imNo).patternPoints(idx_to_cut,:) = [];
                            obj.cameraCalibrations(k).photosInfo(imNo).photoPoints(idx_to_cut,:) = [];
                            obj.cameraCalibrations(k).photosInfo(imNo).nPoints = size(obj.cameraCalibrations(k).photosInfo(imNo).photoPoints,1);
                            if obj.cameraCalibrations(k).photosInfo(imNo).nPoints == 0
                                obj.cameraCalibrations(k).photosInfo(imNo).isValid = 0;
                            end
                        end
                        plot(error(:,1), error(:,2),'+'); hold on;
                    end
                end
            end
        end
        
        function obj = recalibrate(obj)
            obj.isCameraCalibrated = false(obj.nCameras,1);
            obj.calibrate;
        end
        
      
        
    end
end
