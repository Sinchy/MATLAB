function calarray = mat2calarray(camParaCalib)
% mat2calarray

    for i=1:length(camParaCalib)
        calarray(1:3,i)=rotm2eul(camParaCalib(i).R);
        calarray(4:6,i)=camParaCalib(i).T;
        calarray(7,i)=camParaCalib(i).f_eff;
        calarray(8,i)=camParaCalib(i).k1;
        calarray(9,i)=camParaCalib(i).err_x;
        calarray(10,i)=camParaCalib(i).err_y;
        calarray(11,i)=camParaCalib(i).err_t;


    end



end