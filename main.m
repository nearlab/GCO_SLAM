% Corey Marcus
% SLAM as a Graph of Coalesced Observations (Eade, Drummond)
% Rudimentary Replication

clear
close all
clc


%% Setup

%Camera properties
%Resolution = 1280x960
f = 1000; %camera focal length
p1 = 640; %principal point x
p2 = 480; %principal point y
s = 0; %skew

K = [f s p1;
    0 f p2;
    0 0 1]; %camera calibration matrix

%create experiment
Nx = 30;
Ny = 10;
N = Nx*Ny; %total number of points
obj_x = [linspace(-.5,.5,Nx)];% linspace(0,3,Nx/2)];
obj_y = [linspace(-.75,.75,Ny)];% linspace(0,.1,Ny/2)];
obj_z = 10;

%initialize 3D structure
X = zeros(3,N);
kk = 1;

for ii = 1:Nx
    for jj = 1:Ny
        X(:,kk) = [obj_x(ii) obj_y(jj) obj_z]';
        kk = kk + 1;
    end
end

%number of camera images
M = 4*60;

%frame rate (hZ)
fr = 4*30;
ts = 1/fr;

%motion model parameters
F = [0*ones(1,M);
    0*ones(1,M);
    0*ones(1,M)];

T = [0*ones(1,M);
    0*ones(1,M);
    0*ones(1,M)];

Mod.m = 1;
Mod.J = eye(3);

%initialize estimated state
x_hat = zeros(18,M);

%position
x_hat(1:3,1) = [0 0 0]';

%velocity
x_hat(4:6,1) = [.2 0 0]';

%attitude
x_hat(7:15,1) = reshape(eye(3),9,1);

%angular velocity
x_hat(16:18,1) = [0 0 0]';

%initialize error vectors
e_reproj = zeros(1,M);
e_pos = zeros(1,M);
e_map = zeros(1,M);
e_quat = zeros(M,4);
e_eul = zeros(M,3);
e_R = zeros(3,3,M);

%initialize truth model
sig_F = 0;
sig_T = 0;

x = x_hat;
x(1:6,1) = x(1:6,1);% + sqrt(0.001)*randn(6,1); %uncertainty in initial position and velocity
x(16:18,1) = x(16:18,1);% + sqrt(0.001)*randn(3,1); %uncertainty in initial angular velocity

%add uncertainty in attitude
R = reshape(x(7:15,1),3,3);
%R = R*angle2dcm(sqrt(0.001), sqrt(0.001), sqrt(0.001), 'XYZ');
x(7:15,1) = reshape(R,9,1);

%initialize graph
G = digraph;
G.Edges.s = {};
G.Edges.R = {};
G.Edges.T = {};
G.Nodes.R = {};
G.Nodes.T = {};
G.Nodes.X = {};

varNames = cell(1,3);
varNames{1} = 'R';
varNames{2} = 'T';
varNames{3} = 'X';

NodeProps = table(cell(1),cell(1),cell(1),'VariableNames',varNames);
G = addnode(G,NodeProps);

G.Nodes.R = {eye(3)};
G.Nodes.T = {[0 0 0]'};


%% Simulaiton Initialization

%% Main loop
for i = 1:M
    
    %Propogate Motion Model
    
    %Grab New Image
    
    %Calculate 
end

