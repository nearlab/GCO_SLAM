function [x_hat] = LM(H, z, h, x0)
% Levenberg-Marquart Nonlinear Optimization
% Based on algorithm from Humphrey's Course Notes for Estimation
% 
% Our goal is to minimize J = ||z - h(x)||^2
% INPUTS:
% 
% H - Jacobian of h with respect to x, evaluated at the current estimate...
% Does this mean it shouldn't be an input????

x_hat = h(x0);

end