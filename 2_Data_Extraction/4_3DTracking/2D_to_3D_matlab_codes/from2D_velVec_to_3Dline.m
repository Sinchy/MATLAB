
clear all

err = 0:0.1:4;
figure
for comp = 1:8
    for count = 1:size(err,2)
        load('VSC_calib.mat');
        %% Choosing a 3D vel vector for 3D reconstruction
        for cam = 1:4
            tr{cam} = load(['tracks_cam' num2str(cam) '.mat'],'tracks');
            eval(['tr' num2str(cam) ' = cell2mat(tr(' num2str(cam) '));']);
            eval(['tr' num2str(cam) ' = tr' num2str(cam) '.tracks;']);
        end

        frame = 5;

        for cam = 1:4
            eval(['vel_vec(cam,:) = tr' num2str(cam) '(find(tr' num2str(cam) '(:,4) == ' num2str(frame) '),5:6);']);
        end

        % adding error to vel_vec term
        vel_vec(ceil(comp/2),mod(comp,2) + 1) = vel_vec(ceil(comp/2),mod(comp,2) + 1) + err(count);


        vel_vec = vel_vec./sqrt(sum(vel_vec.^2,2));

        %% Getting the vel vector and its normal vector in World Co-ordinates
        addpath('../')
        for cam = 1:4
            eval(['XImg_init = tr' num2str(cam) '(find(tr' num2str(cam) '(:,4) ==' num2str(frame) '),2:3);']);
            XWorld_init(:,cam) = Img2World(camParaCalib(cam),UnDistort(XImg_init, camParaCalib(cam)));

            % for vel
            XImg_final = XImg_init + vel_vec(cam,:);
            XWorld_final(:,cam) = Img2World(camParaCalib(cam),UnDistort(XImg_final, camParaCalib(cam)));

            % for normal
            YImg_final = XImg_init + [-vel_vec(cam,2) vel_vec(cam,1)];
            YWorld_final(:,cam) = Img2World(camParaCalib(cam),UnDistort(YImg_final, camParaCalib(cam)));
        end

        XWorld_init = XWorld_init';
        XWorld_final = XWorld_final';
        YWorld_final = YWorld_final';


        velWorld = XWorld_final - XWorld_init;
        velWorld = velWorld./sqrt(sum(velWorld.^2,2));

        normWorld = YWorld_final - XWorld_init;
        normWorld = normWorld./sqrt(sum(normWorld.^2,2));

        %% Least square fit to find the intersecting line x = x_0 + L*m, were x_0 is the intercept and m is the slope

         % getting the intercept (point closest to all the intersection lines)
            % getting the intersection lines (4C2 = 6 lines)
%         intersectLineSlope = zeros(6,3);
%         intersectLinePoint = zeros(6,3);
%         i = 1;
%         for cam1 = 1:4
%             for cam2 = 1:4
%                 if (cam1 < cam2)
%                     intersectLineSlope(i,:) = cross(normWorld(cam1,:), normWorld(cam2,:));
%                     k1 = dot(normWorld(cam1,:),XWorld_init(cam1,:));
%                     k2 = dot(normWorld(cam2,:),XWorld_init(cam2,:));
%                     
%                     intersectLinePoint(i,2) = (k1*normWorld(cam2,3) - k2*normWorld(cam1,3))/...
%                         (normWorld(cam1,2)*normWorld(cam2,3) - normWorld(cam2,2)*normWorld(cam1,3));
%                     
%                     intersectLinePoint(i,3) = (k1*normWorld(cam2,2) - k2*normWorld(cam1,2))/...
%                         (normWorld(cam1,3)*normWorld(cam2,2) -normWorld(cam2,3)*normWorld(cam1,2));
%                     
%                     i = i + 1;
%                 end
%             end
%         end
%         
%         intersectLineSlope = intersectLineSlope./sqrt(sum(intersectLineSlope.^2,2));
%                     
%         M = zeros(3,3); % for 3D
%         P = zeros(3,1);
%         for line = 1:6
%             tmp = eye(3) - intersectLineSlope(line,:)'*intersectLineSlope(line,:);
%             M = M + tmp;
%             P = P + tmp*intersectLinePoint(line,:)';
%         end
% 
%         x_0 = (inv(M)*P)';

        
        % getting the intercept (point closest to all the planes)
        M = zeros(3,3); % for 3D
        P = zeros(3,1);
        for cam = 1:4
            tmp = normWorld(cam,:)'*normWorld(cam,:);
            M = M + tmp;
            P = P + tmp*XWorld_init(cam,:)';
        end

        x_0 = (inv(M)*P)';

        % getting the slope (vector that is almost perp. to all the planes)

        [eigVec, eigVal] = eig(normWorld'*normWorld);
        m = eigVec(:,1)';

        %% Get the fitting errors of intercept, slope of 3D line & total error in projected slope (on all the images)
            % calculating the fit error for the intercept point (x_0)
        err_intercep(count) = 0;
        for cam = 1:4
            err_intercep(count) = err_intercep(count) + abs((x_0 - XWorld_init(cam,:))*normWorld(cam,:)');
        end

            % fit error for the slope of 3D line
        err_slope3D(count) = (m*m')*eigVal(1,1);

            % total error in projected slope on all the images
        err_slope2D(count) = 0;
        tmp_3D = [x_0; x_0 + m];
        for cam = 1:4
            X2D = calibProj_Tsai(camParaCalib(cam),tmp_3D);
            tmp = (X2D(2,:) - X2D(1,:));
            slope2D = tmp(2)/tmp(1);
            slopeVel = (vel_vec(cam,2)/vel_vec(cam,1));
            err_slope2D(count) = err_slope2D(count) + abs(slopeVel - slope2D);
        end

        %% Plotting
%             % plotting the planes, the intecept point and the 3D line
%         figure; hold on
%          [P,Q] = meshgrid(-50:50); % Provide a gridwork (you choose the size)
%         for cam = 1:4
%             w = null(normWorld(cam,:)); % Find two orthonormal vectors which are orthogonal to v
%             X = XWorld_init(cam,1)+w(1,1)*P+w(1,2)*Q; % Compute the corresponding cartesian coordinates
%             Y = XWorld_init(cam,2)+w(2,1)*P+w(2,2)*Q; %   using the two vectors in w
%             Z = XWorld_init(cam,3)+w(3,1)*P+w(3,2)*Q;
%             s = surf(X,Y,Z);
%             set(s, 'FaceAlpha', 0.5,'edgecolor','none')
%         end
%         plot3(x_0(1),x_0(2),x_0(3),'ro','MarkerSize',10);
%         line_pt = [(x_0 - 50*m); x_0; (x_0 + 50*m)];
%         plot3(line_pt(:,1),line_pt(:,2),line_pt(:,3),'r-','LineWidth',3.0);

        clearvars -except err_intercep err_slope2D err_slope3D err count comp
    end
    subplot(2,4,comp)
    semilogy(err, err_intercep./err_intercep(1),'r.-')
    hold on; plot(err, err_slope2D./err_slope2D(1),'k.-')
    hold on; plot(err, err_slope3D./err_slope3D(1),'b.-')
    title(['error on V(' num2str(ceil(comp/2)) ',' num2str(mod(comp,2) + 1), ')']);
    xlabel('error value')
    ylabel('fitting errors')
    legend('intercept error', '2D slope error', '3D slope error')
end
