function [t,LE]=FO_Lyapunov(ne,ext_fcn,t_start,h_norm,t_end,x_start,h,q,out)
%
% Reference:
% https://www.worldscientific.com/doi/abs/10.1142/S0218127418500670
% Program to compute LEs of systems of FO.
%
% The program uses a fast variant of the
% predictor-corrector Adams-Bashforth-Moulton,
% "FDE12.m" for FDEs, by Roberto Garrappa:
%
% https://goo.gl/XScYmi
%
% m-file required: FDE12 and
% the function containing the extended system
% (see e.g. LE_RF.m).
%
% FO_Lyapunov.m was developed, by
% modifying the program Lyapunov.m,
% by V.N. Govorukhin:
%
% https://goo.gl/wZVCtg
%
% FO_Lyapunov.m, FDE12.m and LE_RF.m
% must be in the same folder.
%
% How to use it:
% [t,LE]=FO_Lyapunov(ne,ext_fcn,t_start,...
% h_norm,t_end,x_start,h,q,out);
%
% Input:
% ne - system dimension;
% ext_fcn - function containing the extended
% system;
% t_start, t_end - time span;
% h_norm - step for Gram-Schmidt
% renormalization;
% x_start - initial condition;
% outp - priniting step of LEs;
% ioutp==0 - no print.
%
% Output:
% t - time values;
% LE Lyapunov exponents to each time value.
%
% Example of use for the RF system:
% [t,LE]=FO_Lyapunov(3,@LE_RF,0,0.02,300,...
% [0.1;0;1;0.1],0.005,0.999,1000);
%
% The program is presented in:
%
% Marius-F. Danca and N. Kuznetsov,
% Matlab code for Lyapunov exponents of
% fractional order systems
% %
hold on;
% Memory allocation
x=zeros(ne*(ne+1),1);
x0=x;
c=zeros(ne,1);
gsc=c; zn=c;
n_it = round((t_end-t_start)/h_norm);
% Initial values
x(1:ne)=x_start;
i=1;
while i<=ne
x((ne+1)*i)=1.0;
i=i+1;
end
t=t_start;
% Main loop
it=1;
while it<=n_it
% Solution of extended ODE system
[T,Y] = FDE12(q,ext_fcn,t,t+h_norm,x,h);
t=t+h_norm;
Y=transpose(Y);
x=Y(size(Y,1),:); %solution at t+h_norm
i=1;
while i<=ne
j=1;
while j<=ne
x0(ne*i+j)=x(ne*j+i);
j=j+1;
end
i=i+1;
end
% orthonormal Gram-Schmidt basis
zn(1)=0.0;
j=1;
while j<=ne
zn(1)=zn(1)+x0(ne*j+1)*x0(ne*j+1);
j=j+1;
end
zn(1)=sqrt(zn(1));
j=1;
while j<=ne
x0(ne*j+1)=x0(ne*j+1)/zn(1);
j=j+1;
end
j=2;
while j<=ne
k=1;
while k<=j-1
gsc(k)=0.0;
l=1;
while l<=ne
gsc(k)=gsc(k)+x0(ne*l+j)*x0(ne*l+k);
l=l+1;
end
k=k+1;
end
k=1;
while k<=ne
l=1;
while l<=j-1
x0(ne*k+j)=x0(ne*k+j)-gsc(l)*x0(ne*k+l);
l=l+1;
end
k=k+1;
end
zn(j)=0.0;
k=1;
while k<=ne
zn(j)=zn(j)+x0(ne*k+j)*x0(ne*k+j);
k=k+1;
end
zn(j)=sqrt(zn(j));
k=1;
while k<=ne
x0(ne*k+j)=x0(ne*k+j)/zn(j);
k=k+1;
end
j=j+1;
end
% update running vector magnitudes
k=1;
while k<=ne
c(k)=c(k)+log(zn(k));
k=k+1;
end
% normalize exponent
k=1;
while k<=ne
LE(k)=c(k)/(t-t_start);
k=k+1;
end
i=1;
while i<=ne
j=1;
while j<=ne
x(ne*j+i)=x0(ne*i+j);
j=j+1;
end
i=i+1;
end
x=transpose(x);
it=it+1;
% print and plot the results
if (mod(it,out)==0) % (*)
fprintf('%10.2f %10.4f %10.4f%10.4f\n',[t,LE]); % (*)
end % (*)
plot(t,LE) % (*)
end
% displays the box outline around axes
xlabel('t','fontsize',16) % (*)
ylabel('LEs','fontsize',14) % (*)
set(gca,'fontsize',14)% (*)
box on;% (*)
line([0,t],[0,0],'color','k')% (*)

function f=LE_RF(t,x)
%Output data must be a column vector
f=zeros(size(x));
%variables allocated to the variational equations
X= [x(4), x(7), x(10);
x(5), x(8), x(11);
x(6), x(9), x(12)];
%RF equations
f(1)=x(2)*(x(3)-1+x(1)*x(1))+0.1*x(1);
f(2)=x(1)*(3*x(3)+1-x(1)*x(1))+0.1*x(2);
f(3)=-2*x(3)*(0.98+x(1)*x(2));
%Jacobian matrix
J=[2*x(1)*x(2)+0.1, x(1)*x(1)+x(3)-1, x(2);
-3*x(1)*x(1)+3*x(3)+1,0.1,3*x(1);
-2*x(2)*x(3),-2*x(1)*x(3),-2*(x(1)*x(2)+0.98)
];
%Righthand side of variational equations
f(4:12)=J*X; % To be modified if ne>3


function run_Lyapunov_p(ne,ext_fcn,t_start,h_norm,t_end,x_start,h,q,p_min,p_max,n)
hold on;
p_step=(p_max-p_min)/np=p_min;
while p<=p_max
LE=FO_Lyapunov_p(ne,ext_fcn,t_start,h_norm,t_end,x_start,h,q,p);
p=p+p_step;
plot(p,LE);
end

function f=LE_RF_p(t,x,p)
%p is the parameter
f=zeros(size(x));
X= [x(4), x(7), x(10);...
x(5), x(8), x(11);...
x(6), x(9), x(12)];
%RF equations
f(1)=x(2)*(x(3)-1+x(1)*x(1))+0.1*x(1);
f(2)=x(1)*(3*x(3)+1-x(1)*x(1))+0.1*x(2);
f(3)=-2*x(3)*(p+x(1)*x(2));
%Jacobian matrix
J=[2*x(1)*x(2)+0.1, x(1)*x(1)+x(3)-1, x(2); ...
-3*x(1)*x(1)+3*x(3)+1,0.1,3*x(1);...
-2*x(2)*x(3),-2*x(1)*x(3),-2*(x(1)*x(2)+p)];
f(4:12)=J*X; % To be modified if ne>3

function run_FO_Lyapunov_q(ne,ext_fcn,t_start,h_norm,t_end,x_start,h,q_min,q_max,n)
hold on;
q_step=(q_max-q_min)/n;
q=q_min;
while q<q_max
[t,LE]=FO_Lyapunov_q(ne,ext_fcn,t_start,h_norm,t_end,x_start,h,q);
q=q+q_step;
fprintf('q=%10.4f\n %10.4f', q);
plot(q,LE);
end