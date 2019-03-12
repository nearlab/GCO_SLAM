clear
close all
clc

%analyze computational complexity of inversion

%number of features
n = 1:20;

%standard inversion
simple = (3*n+3).^3;

%schur with D bar
D_bar = 3*3^3 + ((3*n).^3); 

figure
plot(simple)
hold on
plot(D_bar)
legend('simple','shur')