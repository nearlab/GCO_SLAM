function [m] = nl(C,node,K)
%nl evaluates the nonlinearity of a given node and camera pose
% INPUTS:
% 
% C - structure with following elements
% 
% C.R - 3x3 dcm mapping from the inertial frame to the camera frame
% 
% C.pos - 3x1 position vector of the camera within the inertial frame
% 
% node - structure with the following elements
% 
% node.R - 3x3 dcm mapping from the inertial frame to the node frame
% 
% node.X - 3xN array containing inverse depth coordinates of each element
% within the node
% 
% node.T - 3x1 position vector of the node origin in the inertial frame
% 
% K - Camera Calibration Matrix
% 
% 
% OUTPUTS
% 
% m - scalar measure of nonlinearity

%map camera into node frame
R_NC = C.R'*node.R;

pos_C = C.pos - node.T;

%load nonlinearity function
load('nonlinEval.mat','nl')

%initialize symbolic variables for some reason
R = sym('R',[3 3],'real');
T = sym('T',[3 1],'real');
K = sym('K',[3 3],'real');

%substitute position
nl = subs(nl,T1,pos_C(1));
nl = subs(nl,T2,pos_C(2));
nl = subs(nl,T3,pos_C(3));

%substitute K
nl = subs(nl,K1_1,K(1,1));
nl = subs(nl,K2_1,K(2,1));
nl = subs(nl,K3_1,K(3,1));
nl = subs(nl,K1_2,K(1,2));
nl = subs(nl,K2_2,K(2,2));
nl = subs(nl,K3_2,K(3,2));
nl = subs(nl,K1_3,K(1,3));
nl = subs(nl,K2_3,K(2,3));
nl = subs(nl,K3_3,K(3,3));

%substitute R
nl = subs(nl,R1_1,R_NC(1,1));
nl = subs(nl,R2_1,R_NC(2,1));
nl = subs(nl,R3_1,R_NC(3,1));
nl = subs(nl,R1_2,R_NC(1,2));
nl = subs(nl,R2_2,R_NC(2,2));
nl = subs(nl,R3_2,R_NC(3,2));
nl = subs(nl,R1_3,R_NC(1,3));
nl = subs(nl,R2_3,R_NC(2,3));
nl = subs(nl,R3_3,R_NC(3,3));

%evaluate function
m = double(nl);



end

