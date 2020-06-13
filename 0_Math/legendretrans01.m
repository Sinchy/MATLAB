function [xx,yy,y]=legendretrans01(F,x,h,varargin)
%[xx,yy,y]=legendretrans01(F,x,h,varargin) Legendre Transformation of a one variable function
%	Given a function F and a vector x, the corresponding points of the legendre
%	transformation are numerically approximated and stored in the vectors xx and yy, where 
%		xx=F'(x) and 	yy=F(x)-xx*x
% 	If F is not defined for vectors, a loop is used to evaluate it at each point on x
%
%	Inputs:
%		F: the name of a function or an inline variable
%		x: vector of points
%		h: increment used to calculate F'(x) using a centered finite difference approximation
%			pass an empty vector if needed. The default value is h=1e-5
%		varargin: refers to additional parameters of F (i.e.: F(x,a,b,c...))
%	Outputs:
%		xx: column vector with the values of the new independent variable
%		yy: column vector with the values of the new dependent variable
%		y: column vector with the values of F(x)--this is not a part of the Transformation
%
%	Example 1: y=3*x^2
%	x=-5:.1:5; F=inline('a*x^n','x','a','n');
% 	[xx,yy,y]=legendretrans01(F,x,[],3,2);
%	h=plot(x,y,'b',xx,yy,'r'); grid on, legend(h,'Original function','Legendre Transformation')
%
%	Example 2: the function "humps" has no unique transformation on [-1,1] since F''(x)=0 for some points
%	x=linspace(-1,1); [xx,yy,y]=legendretrans01('humps',x,0.001);
%	h=plot(x,y,'b',xx,yy,'r'); grid on, legend(h,'Original function','Legendre Transformation')


%%(c) Miguel Duque B. 07-29-2006
x=x(:);
if nargin<3 | isempty(h) 
   h=1e-5;
end
x1=x-h; x2=x+h;
k=2*h;
%Try to use vectors first, since it's faster
try
   xx=(feval(F,x2,varargin{:})-feval(F,x1,varargin{:}))/k;
   y=feval(F,x,varargin{:});
catch 
   %If vectors did not work, try a loop
   xx=x;	%Initialize the variables for the loop
   yy=x;
   y=x;
   for ii=1:length(xx)
      xx(ii)=(feval(F,x2(ii),varargin{:})-feval(F,x1(ii),varargin{:}))/k;
      y(ii)=feval(F,x(ii),varargin{:});
   end
end
yy=y-xx.*x;



