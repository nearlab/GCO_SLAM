clear
close all
clc

%initialize 3 points in cartesian space
% X = [0 0 0;
%     .1 0 -.1;
%     1 1 1];

% X = [0 0;
%     -.2 0.1;
%     1 1];

X = [0 0 1]';

%number of points
N = size(X,2);

%Camera properties
%Resolution = 1280x960
f_num = 1; %camera focal length
p1_num = 0; %principal point x
p2_num = 0; %principal point y
s = 0; %skew

K = [f_num s p1_num;
    0 f_num p2_num;
    0 0 1]; %camera calibration matrix

%camera attitude (true)
R = eye(3);

%camera position (true)
pos = [.01 .01 0]';

I = imageGen(X,pos,R,K)

% figure
% scatter(I(1,:),I(2,:))
% axis([0 1280 0 960])

%convert to inverse depth coordinates
for ii = 1:N
    [X(1,ii), X(2,ii), X(3,ii)] = cart2invdept(X(1,ii), X(2,ii), X(3,ii));
end

%initialize initial guess of X, X0
X0 = X;% + .0001*randn(size(X));

%initialize initial guess of pos, pos0
pos0 = pos;% + .0001*randn(size(pos));

%create measurement noise inverse
Rinv = eye(2*N);

%create position information matrix
Info = 0*eye(3*N);

%create LS weight matrix
Q = blkdiag(Rinv,Info);

%initial x0 vector for algorithm
x0 = [pos0; X0];

%create measurement, z
z = [reshape(I,2*N,1); zeros(3*N,1)];

%length of x
M = length(x0);

%create symbolic x vector
x = sym('x',[M,1],'real');

%calculate g
syms x1 x2 x3 xC yC zC 'real'
g = K*[eye(3), [x1 x2 x3]']*([xC yC zC 1]');
g = g(1:2)/g(3);

%create homogenous world coordinates
syms u v q 'real'

%substitute homogenous world coordinates into g
g = subs(g,xC,u*zC);
g = subs(g,yC,v*zC);
g = subs(g,zC,1/q);

%create h
h = [];

%reshape initial guess of structure
X0_R = 0*reshape(X0,3*N,1);

for ii = 1:N
    
    %create g for this particular iteration
    g_iter = subs(g,u,X0_R(3*ii-2) + x(3+3*ii-2));
    g_iter = subs(g_iter,v,X0_R(3*ii-1) + x(3+3*ii-1));
    g_iter = subs(g_iter,q,X0_R(3*ii) + x(3+3*ii));
    
    h = [h; g_iter];
end

%add structure deviation states
h = [h; -1*x(4:end)];

%LM tolerance
tol = 1E-10;
maxIter = 1000;

%calculate initial cost
J = (z - double(subs(h,x,x0)))'*Q*(z - double(subs(h,x,x0)));

%perform LM
[x_hat, ii] = LM(z, h, x0, Q, tol, maxIter)

%caculate final cost
J = (z - double(subs(h,x,x_hat)))'*Q*(z - double(subs(h,x,x_hat)));

%generate new image
pos_hat = x_hat(1:3);
X_hat = X0_R + x_hat(4:end);
X_hat = reshape(X_hat,3,N);

%convert to cartesian coordinates
for ii = 1:N
    [X_hat(1,ii), X_hat(2,ii), X_hat(3,ii)] = invdept2cart(X_hat(1,ii), X_hat(2,ii), X_hat(3,ii));
end

% I_hat = imageGen(X_hat,pos_hat,R,K)
% h = matlabFunction(z-h);
% lsqnonlin(h,x0(1), x0(2), x0(3), x0(4), x0(5), x0(6))



