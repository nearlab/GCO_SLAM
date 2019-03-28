clear
close all
% clc

%random number seed
rng(1);

%max iterations
maxIter = 200;

%tolerance
tol = 1E-8;

%symbolic variables
syms x1 x2 x3 'real'
x = [x1 x2 x3]';

%create function
h = [x1 + x2; 2*x3 - x1; x3];

% %blow up the size of h
% h = [h' h' h' h' h' h' h' h']';

%create truth
x_true = [1 2 3]';

%create covariance function
Q1 = 10*[1 5 10;0 1 1; 0 0 1];
Q = Q1'*Q1;

%create measurement
z = double(subs(h,x,x_true))+ mvnrnd(zeros(3,1),inv(Q))';

%create initial guess
x0 = x_true + .1*randn(length(x_true),1);

%call function
% [x_hat, ii, J_out, pChange] = LM(z, h, x0, Q, tol, maxIter);

% disp('LM Performance')
% norm(x_hat - x_true)
% 
% disp('Initial Performance')
% norm(x0 - x_true)


%look at matlab default performance

%decompose weighting function
[V, D] = eig(Q);

%create function
fun = @(y) Q1*(z-[y(1) + y(2); 2*y(3) - y(1); y(3)]);
options = optimoptions('lsqnonlin','Display','iter','Algorithm','levenberg-marquardt',...
    'FunctionTolerance',1e-8);
X = lsqnonlin(fun,x0,[],[],options);

X

%solve again without weighting
fun = @(y) z-[y(1) + y(2); 2*y(3) - y(1); y(3)];
options = optimoptions('lsqnonlin','Display','iter','Algorithm','levenberg-marquardt',...
    'FunctionTolerance',1e-8);
X = lsqnonlin(fun,x0,[],[],options);

X
% 
% disp('Default Performance')
% norm(X - x_true)

H = [1 1 0;-1 0 2; 0 0 1];

x_ls = (H'*Q*H)^(-1)*H'*Q*z

