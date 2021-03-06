% test of edge generation algorithm
% corey marcus
% UT Austin: ASE
% GCO SLAM


clear
close all
clc

%number of points
N = 100;

%point statistical parameters
mu_x = 1;
mu_y = 1;
mu_z = 1;
sig_x = .25;
sig_y = .25;
sig_z = .25;

sig_s = .1;
sig_R = .1*eye(3);
sig_T = .1*eye(3);
%generate random points
X_I = zeros(N,3); %points in inertial frame
for ii = 1:N
    X_I(ii,:) = mvnrnd([mu_x mu_y mu_z],blkdiag(sig_x,sig_y,sig_z));
end

%create true edge components
s_true = 1;
angle_true = [pi/2, pi/8, pi/2]';
R_true = angle2dcm(angle_true(1),angle_true(2),angle_true(3),'XYZ');
T_true = [1 .5 1]';

for jj = 1:1000
    
%generate noisey s, R, and T
x_noise = mvnrnd([s_true angle_true' T_true'],blkdiag(sig_s,sig_R,sig_T))';

s_rand = x_noise(1);
R_rand = angle2dcm(x_noise(2),x_noise(3),x_noise(4),'XYZ');
T_rand = x_noise(5:7);

%map points to transformed frame
X_R = zeros(N,3);
for ii = 1:N
    X_R(ii,:) = (s_rand*(R_rand*X_I(ii,:)' + T_rand))';
end

%add some noise
X_R = X_R + .1*randn(size(X_R));

% figure
% scatter3(X_I(:,1),X_I(:,2),X_I(:,3))
% hold on
% scatter3(X_R(:,1),X_R(:,2),X_R(:,3))

%create function for minimization
fun2min = @(x) edge_err(x,X_I,X_R);

%LS opts
options = optimoptions('lsqnonlin','Display','none','Algorithm',...
    'levenberg-marquardt','FunctionTolerance',1e-12);

%create initial estimate of edge
x_true = [s_true; angle_true; T_true];
x0 = x_true + .1*randn(7,1);

%run nonlin LS
x_hat = lsqnonlin(fun2min,x0,[],[],options);

%calculate error
x_err(ii,:) = x_hat - x_true;

%extract parameters
s_hat = x_hat(1);
th_1_hat = x_hat(2);
th_2_hat = x_hat(3);
th_3_hat = x_hat(4);
R_hat = angle2dcm(th_1_hat,th_2_hat,th_3_hat,'XYZ');
T_hat = x_hat(5:7);

%create anonymous functions for fast calculation of each derivative of R
dR1 = @(th_1,th_2,th_3) [0, 0, 0;
    sin(th_1)*sin(th_3) + cos(th_1)*cos(th_3)*sin(th_2), cos(th_1)*sin(th_2)*sin(th_3) - cos(th_3)*sin(th_1), cos(th_1)*cos(th_2);
    cos(th_1)*sin(th_3) - cos(th_3)*sin(th_1)*sin(th_2), - cos(th_1)*cos(th_3) - sin(th_1)*sin(th_2)*sin(th_3), -cos(th_2)*sin(th_1)];
    
dR2 = @(th_1,th_2,th_3) [ -cos(th_3)*sin(th_2), -sin(th_2)*sin(th_3), -cos(th_2);
    cos(th_2)*cos(th_3)*sin(th_1), cos(th_2)*sin(th_1)*sin(th_3), -sin(th_1)*sin(th_2);
    cos(th_1)*cos(th_2)*cos(th_3), cos(th_1)*cos(th_2)*sin(th_3), -cos(th_1)*sin(th_2)];

dR3 = @(th_1,th_2,th_3) [-cos(th_2)*sin(th_3), cos(th_2)*cos(th_3), 0;
     - cos(th_1)*cos(th_3) - sin(th_1)*sin(th_2)*sin(th_3), cos(th_3)*sin(th_1)*sin(th_2) - cos(th_1)*sin(th_3), 0;
     cos(th_3)*sin(th_1) - cos(th_1)*sin(th_2)*sin(th_3), sin(th_1)*sin(th_3) + cos(th_1)*cos(th_3)*sin(th_2), 0];
    
%calculate partial h(x) / partial x evaluated at x_hat
H = zeros(3*N,7);

for ii = 1:N
    %calculate partial h(x) / partial s
    H(3*ii-2:3*ii,1) = R_hat * X_I(ii,:)';
    
    %calculate partial h(x) / partial angle for each angle
    H(3*ii-2:3*ii,2) = s_hat*dR1(th_1_hat,th_2_hat,th_3_hat)*X_I(ii,:)';
    H(3*ii-2:3*ii,3) = s_hat*dR2(th_1_hat,th_2_hat,th_3_hat)*X_I(ii,:)';
    H(3*ii-2:3*ii,4) = s_hat*dR3(th_1_hat,th_2_hat,th_3_hat)*X_I(ii,:)';
    
    %calculate partial h(x) / partial T
    H(3*ii-2:3*ii,5:7) = s_hat*eye(3);
end

%I_R covariance
sig = .1;

%create psuedo I_R covariances
R = sig*eye(3*N);

%calculate least squares estimate covariance
P(:,:,jj) = inv(H'/R*H);

end

mean(P,3)

cov(x_err)






