function [x_hat, ii, J_out, pChange] = LM(z, h, x0, Q, tol, maxIter)
% Levenberg-Marquart Nonlinear Optimization
% Based on algorithm from Humphrey's Course Notes for Estimation
% 
% Our goal is to minimize J = (z - h(x))'*Q*(z - h(x))
% 
% INPUTS:
% 
% z - nx1 measurement vector
% h - nx1 (non)linear, symbolic function of x = [x1 x2 ... xM]
% x0 - mx1 initial guess for x
% Q - weighting matrix 
% tol - residual tolerance for convergence of J
% maxIter - maximum number of iterations in case of operator error
% 
% OUTPUTS:
% 
% x_hat - mx1 estimated x values
% ii - iterations required for convergence
% J - cost at each iteration
% pChange - percent change of the final output

%initialize x_hat
x_hat = x0;

%create local symbolic x vector
m = length(x0);
x = sym('x',[m,1],'real');

%Compute J
J = (z - double(subs(h,x,x_hat)))'*Q*(z - double(subs(h,x,x_hat)));

J_out = J;

%initialize loop counter
ii = 1;

%compute jacobian of h
H_sym = jacobian(h);

pChange = tol + 1;
    
%begin loop
while(pChange >= tol && ii <= maxIter)
    
    tic
    %evaluate jacobian at current x estimate
    H = double(subs(H_sym,x,x_hat));
    toc
    %initialize lambda
    lamb = 0;
    
    %check to see if H'*H is psd
    HTH = H'*H;
    eigH = eig(HTH);
    test = min(eigH > 0.01);
    
    %change lambda if H'*H is NOT psd
    if ~test
        lamb = norm(H,'fro')*.001;
    end
    
 
    %compute dX
    dX = (HTH + lamb*eye(m))\H'*(z - double(subs(h,x,x_hat)));

    
    %Compute J
    J = (z - double(subs(h,x,x_hat)))'*Q*(z - double(subs(h,x,x_hat)));
    
    %Compute J_new
    J_new = (z - double(subs(h,x,x_hat+dX)))'*Q*(z - double(subs(h,x,x_hat+dX)));
    
    %Begin sub loop
    while(J_new > J && ii <= maxIter)
        
        %compute new lambda
        lamb = max([2*lamb, norm(H,'fro')*.001]);
        

        %compute dX
        dX = (HTH + lamb*eye(m))\H'*(z - double(subs(h,x,x_hat)));
    
        
        %Compute J_new
        J_new = (z - double(subs(h,x,x_hat+dX)))'*Q*(z - double(subs(h,x,x_hat+dX)));
        
        %increment ii
        ii = ii + 1;
        
    end
    
    %calculate percent change
    pChange = norm((x_hat - dX)./x_hat);
    
    %accept new x value
    x_hat = x_hat + dX;
    
    %increment ii
    ii = ii + 1;
    
    %add J_out
    J_out = [J_out J_new];
end

end