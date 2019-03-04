clear
close all
clc

% Symbolic work for detirmining hessians during schlur complement reduction
% of state update.

%initialize measurement
syms x y 'real'
z = [x y]';

%measurment noise (inverse)
R = eye(2); %sym('R',[2 2],'real');

%information matrix
I = eye(3); %sym('I',[3 3],'real');

%Camera pose
R_C = eye(3); % sym('R',[3 3],'real');
T_C = [0 0 0]'; % sym('T',[3 1],'real');

%inhomogenous world coordinates
syms X Y Z 'real'
X_W = [X Y Z 1]';

%change in inhomogenous world coordinates
syms dX dY dZ 'real'
dX_W = [dX dY dZ 0]';

%change in camera pose
dT_C = sym('dT',[3 1],'real');
dR_C = sym('dR',[3 3],'real');

%camera calibration matrix
syms f px py 'real'
K = [f 0 px;
    0 f py;
    0 0 1];

%calculate g
g = K*[R_C*dR_C, T_C + dT_C]*(X_W + dX_W);
g = g(1:2)/g(3);

%create homogenous world coordinates
syms u v q 'real'
p = [u v q]';

%create change in homogenous world coordinates
syms du dv dq 'real'
dp = [du dv dq]';

%substitute homogenous world coordinates into g
g = subs(g,X,u*Z);
g = subs(g,Y,v*Z);
g = subs(g,Z,1/q);

%sub change in homogenous world coordinates for g
g = subs(g,dX,du*dZ);
g = subs(g,dY,dv*dZ);
g = subs(g,dZ,1/dq);

%compute vector V
V = z - g;

%compute cost function E
E = V'*R*V + dp'*I*dp;

%calculate some hessians
H_ss = hessian(E,dp);

%substitute real values into hessian
H_ss = subs(H_ss,f,1000);
H_ss = subs(H_ss,px,960);
H_ss = subs(H_ss,py,480);

[u_num, v_num, q_num] = cart2invdept(1,1,1);
H_ss = subs(H_ss,u,u_num);
H_ss = subs(H_ss,v,v_num);
H_ss = subs(H_ss,q,q_num);