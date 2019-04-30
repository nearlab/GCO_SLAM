% test of edge generation algorithm
% corey marcus
% UT Austin: ASE
% GCO SLAM


clear
close all
clc

for jj = 1:1000

%number of points
N = 100;

%point statistical parameters
mu_x = 1;
mu_y = 1;
mu_z = 1;
sig_x = .1;
sig_y = .1;
sig_z = .1;

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

%map points to transformed frame
X_R = zeros(N,3);
for ii = 1:N
    X_R(ii,:) = (s_true*(R_true*X_I(ii,:)' + T_true))';
end

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
x_err(:,jj) = x_hat - x_true;

end

mean(x_err,2)