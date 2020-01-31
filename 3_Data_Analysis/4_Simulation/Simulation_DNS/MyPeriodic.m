function NextPos = MyPeriodic(NextPos)
%Periodic Boundary Condition
%   Particle Jump on Periodic Boundary
%   Last Update Date: 2020/1/28
    BoudLab_1 = (NextPos(:,:)>=(2*pi));
    BoudLab_2 = (NextPos(:,:)<0);
    
    NextPos = NextPos + 2*pi*(BoudLab_2 - BoudLab_1) ;
end

