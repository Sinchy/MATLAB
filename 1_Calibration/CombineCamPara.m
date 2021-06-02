function camParaCalib_all = CombineCamPara(file_path)
for i = 1 : 4
    load([file_path 'cam' num2str(i) '.mat']);
    camParaCalib_all(i, :) = camParaCalib;
end
camParaCalib = camParaCalib_all;
save( [file_path 'camParaCalib.mat'], 'camParaCalib');
CalibMatToTXT(camParaCalib,  [file_path 'camParaCalib.txt']);
end

