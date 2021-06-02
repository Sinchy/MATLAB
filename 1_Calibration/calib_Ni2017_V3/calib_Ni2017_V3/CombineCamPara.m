function camParaCalib_all = CombineCamPara(file_path)
for i = 1 : 4
    load([file_path 'cam' num2str(i) '.mat']);
    camParaCalib_all(i, :) = camParaCalib;
end
end

