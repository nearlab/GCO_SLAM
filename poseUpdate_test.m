clear
close all
clc

%initialize N points in cartesian space
N = 100;

X = [.1*randn(2,N);
    .1*randn(1,N)+1];

% X = [0 0;
%     -.2 0.1;
%     1 1];

% X = [0 0 1]';


%Camera properties
%Resolution = 1280x960
f_num = 1000; %camera focal length
p1_num = 640; %principal point x
p2_num = 480; %principal point y
s = 0; %skew

K = [f_num s p1_num;
    0 f_num p2_num;
    0 0 1]; %camera calibration matrix

%camera attitude (true)
R = eye(3);

%camera position (true)
pos = [.01 .01 0]';

I = imageGen(X,pos,R,K);

figure
scatter(I(1,:),I(2,:))
axis([0 1280 0 960])
hold on

%convert to inverse depth coordinates
for ii = 1:N
    [X(1,ii), X(2,ii), X(3,ii)] = cart2invdept(X(1,ii), X(2,ii), X(3,ii));
end

%initialize initial guess of X, X0
X0 = X + .01*randn(size(X));

%initialize initial guess of pos, pos0
pos0 = pos + .01*randn(size(pos));

%create measurement noise inverse diagonals
Rinv = 100*ones(1,2*N);

%create position information matrix diagonals
Info = 0*ones(1,3*N);

%create LS weight matrix diagonal
Q = [Rinv, Info];

%initial x0 vector for algorithm
x0 = [pos0; zeros(3*N,1)];

%create measurement, z
z = reshape(I,2*N,1);

% %length of x
% M = length(x0);
% 
% %create symbolic x vector
% x = sym('x',[M,1],'real');
% 
% %calculate g
% syms x1 x2 x3 xC yC zC 'real'
% g = imageGen([xC yC zC]',[x1 x2 x3]',eye(3),K);
% 
% %create homogenous world coordinates
% syms u v q 'real'
% 
% %substitute homogenous world coordinates into g
% g = subs(g,xC,u*zC);
% g = subs(g,yC,v*zC);
% g = subs(g,zC,1/q);
% 
% %create h
% h = [];
% 
% %reshape initial guess of structure
% X0_R = reshape(X0,3*N,1);
% 
% for ii = 1:N
%     
%     %create g for this particular iteration
%     g_iter = subs(g,u,X0_R(3*ii-2) + x(3+3*ii-2));
%     g_iter = subs(g_iter,v,X0_R(3*ii-1) + x(3+3*ii-1));
%     g_iter = subs(g_iter,q,X0_R(3*ii) + x(3+3*ii));
%     
%     h = [h; g_iter];
% end
% 
% %add structure deviation states
% h = [h; -1*x(4:end)];
% 
% %LM tolerance
% tol = 1E-10;
% maxIter = 100;
% 
% %calculate initial cost
% J = (z - double(subs(h,x,x0)))'*Q*(z - double(subs(h,x,x0)));
% 
% %perform LM
% [x_hat, iters, J_out] = LM(z, h, x0, Q, tol, maxIter)
% 

%create anoynmous function
f_min = @(x)v_stateUpdate(x,z,X0,K,Q);

%call nonlinear least squares
options = optimoptions('lsqnonlin','Display','iter','Algorithm','levenberg-marquardt',...
    'FunctionTolerance',1e-10);
x_hat = lsqnonlin(f_min, x0,[],[],options);


% %caculate final cost
% J = (z - double(subs(h,x,x_hat)))'*Q*(z - double(subs(h,x,x_hat)));

%extract ls output
pos_hat = x_hat(1:3);
X_hat = X0 + reshape(x_hat(4:end),3,N);

%convert to cartesian coordinates
for ii = 1:N
    [X_hat(1,ii), X_hat(2,ii), X_hat(3,ii)] = invdept2cart(X_hat(1,ii), X_hat(2,ii), X_hat(3,ii));
    [X(1,ii), X(2,ii), X(3,ii)] = invdept2cart(X(1,ii), X(2,ii), X(3,ii));
    [X0(1,ii), X0(2,ii), X0(3,ii)] = invdept2cart(X0(1,ii), X0(2,ii), X0(3,ii));
end

I_hat = imageGen(X_hat,pos_hat,R,K);
scatter(I_hat(1,:),I_hat(2,:))
legend('True','I Hat')

%plot 3D scene
figure
scatter3(X(1,:),X(2,:),X(3,:))
axis equal
hold on
scatter3(X_hat(1,:),X_hat(2,:),X_hat(3,:))
scatter3(pos(1),pos(2),pos(3))
scatter3(pos_hat(1),pos_hat(2),pos_hat(3))
legend('True','Estimated','True Pos','Est Pos')
xlabel('x')
ylabel('y')
zlabel('z')


figure
scatter3(X(1,:)-X_hat(1,:),X(2,:)-X_hat(2,:),X(3,:)-X_hat(3,:))
hold on
scatter3(X(1,:)-X0(1,:),X(2,:)-X0(2,:),X(3,:)-X0(3,:))
legend('Estimate Error','Initial Error')
xlabel('x')
ylabel('y')
zlabel('z')
% axis equal




