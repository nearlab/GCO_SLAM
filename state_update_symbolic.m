clear
close all
clc

% Symbolic work for detirmining jacobians during schlur complement
% reduction of state update.

%initialize measurement
syms x y 'real'
z = [x y]';

%measurment noise (inverse)
R = eye(2); %sym('R',[2 2],'real');

%information matrix
I = eye(3); %sym('I',[3 3],'real');

%Camera pose
R_C = sym('R',[3 3],'real');
T_C = sym('T',[3 1],'real');

%inhomogenous world coordinates
syms X Y Z 'real'
X_W = [X Y Z 1]';

%change in inhomogenous world coordinates
syms dX dY dZ 'real'
dX_W = [dX dY dZ 0]';

%camera calibration matrix
syms f px py 'real'
K = [f 0 px;
    0 f py;
    0 0 1];

%calculate g
g = K*[eye(3), T_C]*(X_W);
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

%save g
save('cameraMap','g')

%compute h_prime (onedrive notes)
h_p = [g; -dp]