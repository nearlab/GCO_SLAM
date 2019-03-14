clear
close all
clc

%this function generates the symbolic expression for nonlinearity analysis
%which must be evaluated in order to detirmine
syms x y z u v q 'real'
[x, y, z] = invdept2cart(u,v,q);

R = sym('R',[3 3],'real');
pos = sym('T',[3 1],'real');

K = sym('K',[3 3],'real');

I = imageGen([x y z]', pos, R, K);

u_p = I(1);
v_p = I(2);

%take partials
d2updu2 = diff(diff(u_p,u),u);
d2updv2 = diff(diff(u_p,v),v);
d2updq2 = diff(diff(u_p,q),q);

d2vpdu2 = diff(diff(v_p,u),u);
d2vpdv2 = diff(diff(v_p,v),v);
d2vpdq2 = diff(diff(v_p,q),q);

%calcuate nonlinear function
sum1 = d2updu2 + d2updv2 + d2updq2;
sum2 = d2vpdu2 + d2vpdv2 + d2vpdq2;
nl = sqrt(sum1^2 + sum2^2);

%substitute test point
nl = subs(nl,u,0);
nl = subs(nl,v,0);
nl = subs(nl,q,1);

save('nonlinEval','nl')