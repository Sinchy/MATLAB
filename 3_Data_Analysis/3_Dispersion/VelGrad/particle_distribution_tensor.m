function shape=particle_distribution_tensor(p)
% theta=linspace(0,2*pi,40);
% phi=linspace(0,pi,40);
% [theta,phi]=meshgrid(theta,phi);
% theta=reshape(theta,[numel(theta) 1]);
% phi=reshape(phi,[numel(phi) 1]);
% rho=1;
% x=rho*sin(phi).*cos(theta);
% y=rho*sin(phi).*sin(theta);
% z=rho*cos(phi);
% z=abs(z);
% 
% % p=[0 0 0;1 0 0;0 1 0;1 1 0;0 0 1;1 0 1;0 1 1;1 1 1];
% % p=[0 0 0;1 0 0;0 1 0;.4 .4 1];
% % p=[1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;0 0 -1];
% p=[1 0 0;-1 0 0;0 1 0;0 -1 0;0 0 1;2 0 0];
x=p(:,1);y=p(:,2);z=p(:,3);

s1(1:3:3*length(x)-2,1:3)=[x y z];
s1(2:3:3*length(x)-1,1:3)=[x y z];
s1(3:3:3*length(x),1:3)=[x y z];
s2(1:3:3*length(x)-2,1:3)=[x x x];
s2(2:3:3*length(x)-1,1:3)=[y y y];
s2(3:3:3*length(x),1:3)=[z z z];
s_dum=s1.*s2;
s=zeros(3,3,length(x));
for i=1:length(x)
    s(:,:,i)=s_dum(3*(i-1)+1:3*i,1:3);    
end
s=sum(s,3);
[eig_v,eig_d]=eig(s);
shape=min(diag(eig_d))/max(diag(eig_d));
% y2(1:3:3*length(y)-2,1)=y;
% y2(2:3:3*length(y)-1,1)=y;
% y2(3:3:3*length(y),1)=y;
% z2(1:3:3*length(z)-2,1)=z;
% z2(2:3:3*length(z)-1,1)=z;
% z2(3:3:3*length(z),1)=z;

% scatter3(x,y,z);
% axis equal