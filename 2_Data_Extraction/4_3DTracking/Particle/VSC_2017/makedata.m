data=[];
for i=1:800;
    load (['./pos3D/cleanlistpos2Dframe' num2str(i) '.mat']);
    eval(['a1=cell2mat(pos3Dframe' num2str(i) ');']);
    if i==1
        data=a1;
    else
        data=[data;a1];
    end
    
end

save data.mat data