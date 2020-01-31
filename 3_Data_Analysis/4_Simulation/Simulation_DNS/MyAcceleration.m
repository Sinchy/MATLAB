function force = MyAcceleration(npoints,beta,tau,pu_pt,Convect,TemFlow,TemVel,g)
%UNTITLED4 此处显示有关此函数的摘要
%   Calculate force on particle/bubble
%   Last Update Date: 2020/1/28
    z = [0,0,1]';

    for m = 1:npoints
    force1 = beta(m) * (pu_pt(:,m) + Convect(:,m));
    force2 = (TemFlow(:,m)-TemVel(:,m))/tau(m);
    force3 = (beta(m)-1) * g .* z;
    force = force1 + force2 + force3;
    end

end

