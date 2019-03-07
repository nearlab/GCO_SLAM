clear
close all
clc

%lets take it nice and easy to figure this out

%create real point X
syms x y z 'real'

X = [x y z]';

%camera attitude R
R = eye(3);

%camera position T
syms t1 t2 t3 'real'
T = [t1 t2 t3]';

%create camera calibration matrix
syms f px py 'real'
K = [f 0 px;
    0 f py;
    0 0 1];

%create Measured Image
I_meas = imageGen(X, T, R, K)

%we are going to convert X from inverse depth to cartesian and back
syms u v q 'real'
[u, v, q] = cart2invdept(x,y,z);