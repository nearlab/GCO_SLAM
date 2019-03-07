clear
close all
clc

%max iterations
maxIter = 200;

%tolerance
tol = 1E-6;

%symbolic variables
syms x1 x2 x3 'real'
x = [x1 x2 x3]';

%create function
h = [sin(x1); cos(x2) + x3^2];

%create truth
x_true = [1 2 3]';

%create measurement
z = double(subs(h,x,x_true));

%create weighting function
Q = eye(length(z));

%create initial guess
x0 = x_true + .01*randn(3,1);

%call function
[x_hat, ii] = LM(z, h, x0, Q, tol, maxIter);

disp('LM Performance')
norm(x_hat - x_true)

disp('Initial Performance')
norm(x0 - x_true)

%look at matlab default performance
fun = @(y)(z-[sin(y(1)); cos(y(2)) + y(3)^2]);
X = lsqnonlin(fun,x0);

disp('Default Performance')
norm(X - x_true)

