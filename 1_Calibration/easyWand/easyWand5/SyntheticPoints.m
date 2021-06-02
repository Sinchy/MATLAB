% %% Generate ponts
% n_pt = 200;
% % pts = rand(n_pt, 3) * 20 - 10;
% 
% %% generate 2D points for each camera
% i = 1;
% clear uv;
% while (i <= n_pt)
%     pt =  rand(1, 3) * 10 - 5;
%     for cm = 1 : 4
%         uv(cm, :) = dlt_inverse(c(:,cm), pt);
%     end
%     if sum(uv(:,1) < 0) > 0 || sum(uv(:,1) > 1280) > 0 || ...
%             sum(uv(:,2) < 0) > 0 || sum(uv(:,2) > 800) > 0
%         continue;
%     end
%     cam1(i, :) = [pt uv(1,:)];
%     cam2(i, :) = [pt uv(2,:)];
%     cam3(i, :) = [pt uv(3,:)];
%     cam4(i, :) = [pt uv(4,:)];
%     i = i + 1;
% end

wandpts1_reconstr = dlt_reconstruct(c, wandpts(:, 1:8)) * 1000;
cam1 = [ wandpts(:, 1:2) wandpts1_reconstr];
cam2 = [ wandpts(:, 3:4) wandpts1_reconstr];
cam3 = [ wandpts(:, 5:6) wandpts1_reconstr];
cam4 = [ wandpts(:, 7:8) wandpts1_reconstr];

%% calibrate

camParaCalib2(1,:) = TsaiCalibration(800, 1280, .02, .02, cam1);
camParaCalib2(2,:) = TsaiCalibration(800, 1280, .02, .02, cam2);
camParaCalib2(3,:) = TsaiCalibration(800, 1280, .02, .02, cam3);
camParaCalib2(4,:) = TsaiCalibration(800, 1280, .02, .02, cam4);

figure; CameraDistribution(camParaCalib2);

%% save results
file_path = 'D:\1.Projects\2.Bubble-Particle\Data_analysis\DissipationRate\040621\WangSynthetic\';
save( [file_path 'camParaCalib.mat'], 'camParaCalib2');
CalibMatToTXT(camParaCalib2,  [file_path 'camParaCalib.txt']);