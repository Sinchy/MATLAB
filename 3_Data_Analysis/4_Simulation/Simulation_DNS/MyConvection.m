function Convect = MyConvection(authkey, dataset, time,  FD4Lag4, NoTInt, npoints, TemPos,TemFlow)
% Calculate the convection term u*grad(u)
%   Last Update Date: 2020/1/28
%   1=duxdx, 2=duxdy, 3=duxdz, 4=duydx, 5=duydy, 6=duydz, 7=duzdx, 8=duzdy, 9=duzdz
    Convect = zeros(3,npoints);
    
    VelGrad = getVelocityGradient (authkey, dataset, time,  FD4Lag4, NoTInt, npoints, TemPos);
    
    Convect(1,:)=TemFlow(1,:).*VelGrad(1,:)+TemFlow(2,:).*VelGrad(2,:)+TemFlow(3,:).*VelGrad(3,:);
    Convect(2,:)=TemFlow(1,:).*VelGrad(4,:)+TemFlow(2,:).*VelGrad(5,:)+TemFlow(3,:).*VelGrad(6,:);
    Convect(3,:)=TemFlow(1,:).*VelGrad(7,:)+TemFlow(2,:).*VelGrad(8,:)+TemFlow(3,:).*VelGrad(9,:);
end

