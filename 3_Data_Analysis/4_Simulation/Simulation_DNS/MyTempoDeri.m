function pu_pt_simp = MyTempoDeri(authkey, dataset, time, dt, Lag6, NoTInt, npoints, TemPos)
% Calculate Temporal derivative of flow velocity
%   The 4th-order centered finite differencing format is employed.
%   Calculate temporal derivative of flow velocity (u_f) at time (time) for
%   each particle location (TemPos)
%   Last Update Date: 2020/1/28

    uFlow = zeros(5,3,npoints); % (time,x/y/z direction,particle id)
    to_get_data = 1;
    while(to_get_data)
        try
            TemFlow = getVelocity (authkey, dataset, time, Lag6, NoTInt, npoints, TemPos);
            uFlow(1,:,:) =  TemFlow;
            % Flow velocity at step (n+1)
            uFlow(2,:,:) =  getVelocity (authkey, dataset, (time+dt), Lag6, NoTInt, npoints, TemPos);
            % Flow velocity at step (n-1)
            uFlow(3,:,:) =  getVelocity (authkey, dataset, (time-dt), Lag6, NoTInt, npoints, TemPos);
            % Flow velocity at step (n+2)
            uFlow(4,:,:) =  getVelocity (authkey, dataset, (time+2*dt), Lag6, NoTInt, npoints, TemPos);
            % Flow velocity at step (n-2)
            uFlow(5,:,:) =  getVelocity (authkey, dataset, (time-2*dt), Lag6, NoTInt, npoints, TemPos);
            to_get_data = 0; %if data is obtained then exit the loop
        catch
            to_get_data = 1;
        end
    end
    % pu/pt = (partial u/partial t)
    pu_pt = (2*(uFlow(2,:,:)-uFlow(3,:,:))-1/12*(uFlow(4,:,:)-uFlow(5,:,:)))/dt;
    
    % simplify pu_pt size
    pu_pt_simp = zeros(3,npoints);
    for j = 1:3
        pu_pt_simp(j,:) = pu_pt(1,j,:);
    end
end

