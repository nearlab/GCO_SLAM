function [x_hat] = LM(z, h, x0, Q, tol, maxIter)
% Levenberg-Marquart Nonlinear Optimization
% Based on algorithm from Humphrey's Course Notes for Estimation
% 
% Our goal is to minimize J = (z - h(x))'*Q*(z - h(x))
% 
% INPUTS:
% 
% z - nx1 measurement vector
% h - nonlinear function of x
% x0 - initial guess for x
% Q - weighting matrix 
% tol - tolerance for convergence of J
% maxIter - maximum number of iterations in case of operator error
% 
% OUTPUTS:
% 
% x_hat - estimated x values


%Compute J
J = (z - h(x0))'*Q*(z - h(x0));

%initialize loop counter
ii = 1;

%begin loop
while(J >= tol && ii <= maxIter)
    
end



end