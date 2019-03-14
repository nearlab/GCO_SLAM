clear
close all
clc

%create K
f = 1000;
K = eye(3); K(1,1) = f; K(2,2) = f;

%create node properties
node.R = eye(3);
node.T = [0 0 0]';

%create camera properties
C.R = eye(3);
C.pos = [0 0 0]';


%test function
m = nl(C,node,K)