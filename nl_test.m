clear
close all
clc

%create K
f = 1;
K = eye(3); K(1,1) = f; K(2,2) = f;

%create node properties
node.R = eye(3);
node.T = [0 0 10]';

%create camera properties
C.R = angle2dcm(0,0,0,'XYZ');
C.pos = [0 0 0]';


%test function
m = nl(C,node,K)