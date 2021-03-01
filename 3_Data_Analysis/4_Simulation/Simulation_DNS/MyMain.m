
clear all;
close all;
clc;

%==================================================================
%====================== Definition in JHUTDB ======================
%==================================================================

authkey = 'edu.jhu.xruan4-9cf8301c';
dataset = 'isotropic1024coarse';

% ---- Temporal Interpolation Options ----
NoTInt   = 'None' ; % No temporal interpolation
PCHIPInt = 'PCHIP'; % Piecewise cubic Hermit interpolation in time

% ---- Spatial Interpolation Flags for getVelocity & getVelocityAndPressure ----
NoSInt = 'None'; % No spatial interpolation
Lag4   = 'Lag4'; % 4th order Lagrangian interpolation in space
Lag6   = 'Lag6'; % 6th order Lagrangian interpolation in space
Lag8   = 'Lag8'; % 8th order Lagrangian interpolation in space

% ---- Spatial Differentiation & Interpolation Flags for getVelocityGradient & getPressureGradient ----
FD4NoInt = 'None_Fd4' ; % 4th order finite differential scheme for grid values, no spatial interpolation
FD6NoInt = 'None_Fd6' ; % 6th order finite differential scheme for grid values, no spatial interpolation
FD8NoInt = 'None_Fd8' ; % 8th order finite differential scheme for grid values, no spatial interpolation
FD4Lag4  = 'Fd4Lag4'  ; % 4th order finite differential scheme for grid values, 4th order Lagrangian interpolation in space

% ---- Spline interpolation and differentiation Flags for getVelocity,
% getPressure, getVelocityGradient, getPressureGradient,
% getVelocityHessian, getPressureHessian
M1Q4   = 'M1Q4'; % Splines with smoothness 1 (3rd order) over 4 data points. Not applicable for Hessian.
M2Q8   = 'M2Q8'; % Splines with smoothness 2 (5th order) over 8 data points.
M2Q14   = 'M2Q14'; % Splines with smoothness 2 (5th order) over 14 data points.

%===================================================================
%====================== Definition in My Part ======================
%===================================================================

StartTime = 3; %Initial time step, must (>=3)
dt = 0.002; %Time step
itmax = 5000; %Maximum simulation Maximum, (StartTime+itmax<=5028)
MaxTime = 5028; %Maximum Maximum in JHUTDB coarse HIT
npoints_p = 10000; %Particle number
npoints_b = 0; % bubble number
npoints = npoints_p + npoints_b;

nu = 0.000185; %Kinematic viscosity
g = 0; %Gravitational acceleration

rho_p = 17.57; % Particle density
rho_b = 25; % Bubble density
rho_f = 1; % Fluid density

beta = linspace(0,0,npoints)';
beta(1:(npoints_p)) = 3*rho_f/(rho_f+2*rho_p);
beta((npoints_p + 1):npoints_p + npoints_b) = 3*rho_f/(rho_f+2*rho_b);

rp_p = 0.001; % Particle radius
rp_b = 0.001; % Bubble radius

rp = linspace(0,0,npoints)';
rp(1:(npoints_p)) = rp_p;
rp((npoints_p + 1):npoints_p + npoints_b) = rp_b;

tau = rp.*rp./beta/3/nu; % Relaxation time

file_path = '/home/tanshiyong/Documents/Documents/2.Particles/Simulation/Particles.txt';

%==================================================================
%======================         Main         ======================
%==================================================================

%-----------------------------------------------------------------
%--------------------------- File Head ---------------------------
fid = fopen(file_path,'a+');
nParticles = fid;

% Check Total Time Length
fprintf('\n ====== MyCheckTime Starts ====== \n');
MyCheckTime(StartTime,itmax,MaxTime);
fprintf('\n ====== MyCheckTime Ends ====== \n');

%--------------------------------------------------
%----------------- Initialization -----------------
%--------------------------------------------------

%  Set initial positions and velocity
time = StartTime*dt;
TemPos = 2*pi*rand([3 npoints]);
TemFlow = getVelocity (authkey, dataset, time, Lag6, NoTInt, npoints, TemPos);
TemVel = TemFlow;

%--------------------------------------------------
%--------------- Temporal Evolution ---------------
%--------------------------------------------------
for i = 1:itmax
    % Accurate time for each step
    time = (StartTime+i-1)*dt;
    
    %----------------------- (1) First Sub Time Step ----------------------
    
    % Get velocity at particle positions
    fprintf('\nRequesting velocity at it = %i (%i/%i) \n',i,i,itmax);
    
    % Flow velocity at current step (n)
    % Note: Since particle locations change every step, we have to inquire
    % new local flow velocity every time
    to_get_data = 1;
    while(to_get_data)
        try
            TemFlow = getVelocity (authkey, dataset, time, Lag6, NoTInt, npoints, TemPos);
            to_get_data = 0; %if data is obtained then exit the loop
        catch
            to_get_data = 1;
        end
    end
    
    % Calculate force on particles
    % pu/pt = (partial u/partial t)
    pu_pt = MyTempoDeri(authkey, dataset, time, dt, Lag6, NoTInt, npoints, TemPos);
    
    % Convection term
    Convect = MyConvection(authkey, dataset, time,  FD4Lag4, NoTInt, npoints, TemPos,TemFlow);
    
    % Acceleration
    Acc_1 = MyAcceleration(npoints,beta,tau,pu_pt,Convect,TemFlow,TemVel,g);

    
    % Evolve position/velocity for the first sub step
    x_sub = TemPos + TemVel*dt;
    x_sub = MyPeriodic(x_sub); % Check periodicity
    v_sub = TemVel + Acc_1*dt;
    
    %---------------------- (2) Second Sub Time Step ----------------------
        to_get_data = 1;
    while(to_get_data)
        try
            uf_sub = getVelocity (authkey, dataset, (time+dt), Lag6, NoTInt, npoints, x_sub);
            to_get_data = 0; %if data is obtained then exit the loop
        catch
            to_get_data = 1;
        end
    end
    pu_pt = MyTempoDeri(authkey, dataset, (time+dt), dt, Lag6, NoTInt, npoints, x_sub);
    
    Convect = MyConvection(authkey, dataset, (time+dt),  FD4Lag4, NoTInt, npoints, x_sub,uf_sub);
    
    Acc_2 = MyAcceleration(npoints,beta,tau,pu_pt,Convect,uf_sub,v_sub,g);
    
    %----------------------- (3) Evolve one step -----------------------
    NewPos = TemPos + (TemVel+v_sub) * dt/2;
    NewPos = MyPeriodic(NewPos);
    Acc = (Acc_1+Acc_2)/2;
    NewVel = TemVel + Acc * dt;
    
    % Output to file
    for np = 1:npoints
    fprintf(nParticles,'%f %f %f %f %f %f\n',TemPos(1,np),...
        TemPos(2,np),TemPos(3,np),TemVel(1,np),TemVel(2,np),TemVel(3,np));
    end
    
    % Update particle position/velocity
    TemPos = NewPos;
    TemVel = NewVel;
end % for i = 1:(itmax+1)

% Output last-step result
for np = 1:npoints
    fprintf(nParticles,'%f %f %f %f %f %f\n',NewPos(1,np),...
    NewPos(2,np),NewPos(3,np),NewVel(1,np),NewVel(2,np),NewVel(3,np));
end

fclose(nParticles);

%MyTrajectory;
