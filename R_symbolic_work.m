%symbolic work for rotation matrices
clear
close all
clc

%initialize three variables
syms th_1 th_2 th_3 'real'

%declare 3 principle axes
x = [1 0 0]';
y = [0 1 0]';
z = [0 0 1]';

%create 3 dcms
R1 = rotationMatrix(x,th_1);
R2 = rotationMatrix(y,th_2);
R3 = rotationMatrix(z,th_3);

%create R
R = R1*R2*R3;

%calculate the three derivatives
dR1 = diff(R,th_1)
dR2 = diff(R,th_2)
dR3 = diff(R,th_3)