clear
close all
clc

%random number seed
rng(1);

%max iterations
maxIter = 200;

%tolerance
tol = 1E-8;

%symbolic variables
syms x1 x2 x3 x4 x5 'real'
x = [x1 x2 x3 x4 x5]';

%create function
h = [x1 + x2 + x5; 2*x3 - x1; x3*x4];

% %blow up the size of h
% h = [h' h' h' h' h' h' h' h']';

%create truth
x_true = [1 2 3 4 5]';

%create covariance function
Q1 = eye(length(h));
Q1(1,3) = 1.5;
Q1(2,3) = 2;
Q = Q1'*Q1;

%create measurement
z = double(subs(h,x,x_true))+ mvnrnd(zeros(length(h),1),inv(Q))';

%create initial guess
x0 = x_true + .001*randn(length(x_true),1);

%call function
[x_hat, ii, J_out, pChange] = LM(z, h, x0, Q, tol, maxIter);

% disp('LM Performance')
% norm(x_hat - x_true)
% 
% disp('Initial Performance')
% norm(x0 - x_true)


%look at matlab default performance

%decompose weighting function
[V, D] = eig(Q);

%create function
fun = @(y) Q1'*(z-[y(1) + y(2) + y(5); 2*y(3) - y(1); y(3)*y(4)]);
options = optimoptions('lsqnonlin','Display','iter','Algorithm','levenberg-marquardt',...
    'FunctionTolerance',1e-8);
X = lsqnonlin(fun,x0,[],[],options);

% %solve again without weighting
% fun = @(y) z-[y(1) + y(2) + y(5); 2*y(3) - y(1); y(3)*y(4)];
% options = optimoptions('lsqnonlin','Display','iter','Algorithm','levenberg-marquardt',...
%     'FunctionTolerance',1e-8);
% X = lsqnonlin(fun,x0,[],[],options);

% 
% disp('Default Performance')
% norm(X - x_true)


