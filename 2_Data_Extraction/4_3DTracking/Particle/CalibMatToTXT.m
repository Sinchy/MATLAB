function CalibMatToTXT(camParaCalib, save_path)

fileID = fopen(save_path,'w');
fprintf(fileID, '# Camera configuration file\n');
fprintf(fileID, '# generated %s\n \n', datetime);

fprintf(fileID, '4    # camera number\n');

for i = 1 : 4
    fprintf(fileID, '\n#camera %d\n', i );
    fprintf(fileID,'%d    #Noffh\n',camParaCalib(i).Noffh);
    fprintf(fileID,'%d    #Noffw\n',camParaCalib(i).Noffw);
    fprintf(fileID,'%d    #Npixw\n',camParaCalib(i).Npixw);
    fprintf(fileID,'%d    #Npixh\n',camParaCalib(i).Npixh);
    fprintf(fileID,'%6.10f    #wpix\n',camParaCalib(i).wpix);
    fprintf(fileID,'%6.10f    #hpix\n',camParaCalib(i).hpix);
    fprintf(fileID,'%6.10f    #f_eff\n',camParaCalib(i).f_eff);
    fprintf(fileID,'%6.10f    #kr\n',camParaCalib(i).k1);
    fprintf(fileID,'%d    #kx\n',1);
    fprintf(fileID,'%6.10f    #R\n',camParaCalib(i).R');
    fprintf(fileID,'%6.10f    #T\n',camParaCalib(i).T);
    fprintf(fileID,'%6.10f    #Rinv\n',camParaCalib(i).Rinv');
    fprintf(fileID,'%6.10f    #Tinv\n',camParaCalib(i).Tinv);
end

fclose(fileID);
end

