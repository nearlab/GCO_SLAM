clear
close all
clc

% Test of graph optimization function

%initialize graph
G = graph();
G.Edges.s = {}; %scale
G.Edges.R = {}; %XYZ euler angles for 123 rotation (inertial to node)
G.Edges.T = {}; %translation (inertial frame)
G.Edges.Sig = {}; %covariance matrix
G.Nodes.X = {};

varNames_Node = cell(1,1);
varNames_Node{1} = 'X';

NodeProps = table(cell(1),'VariableNames',varNames_Node);

%add 4 nodes
G = addnode(G,NodeProps);
G = addnode(G,NodeProps);
G = addnode(G,NodeProps);
G = addnode(G,NodeProps);

%add 4 edges
varNames_Edge = cell(1,4);
varNames_Edge{1} = 's';
varNames_Edge{2} = 'R';
varNames_Edge{3} = 'T';
varNames_Edge{4} = 'Sig';
EdgeProps = table(cell(1),cell(1),cell(1),cell(1),'VariableNames',varNames_Edge);

%Create True Graph
%first edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = [0 0 -pi/2]';
EdgeProps.T{1} = [0 1 0]';
EdgeProps.Sig{1} = 1*eye(7);
G = addedge(G,1,2,EdgeProps);

%second edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = [0 0 -pi/2]';
EdgeProps.T{1} = [1 0 0]';
EdgeProps.Sig{1} = 1*eye(7);
G = addedge(G,2,3,EdgeProps);

%third edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = [0 0 -pi/2]';
EdgeProps.T{1} = [0 -1 0]';
EdgeProps.Sig{1} = 1*eye(7);
G = addedge(G,3,4,EdgeProps);

%fourth edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = [0 0 pi/2]';
EdgeProps.T{1} = [1 0 0]';
EdgeProps.Sig{1} = 1*eye(7);
G = addedge(G,1,4,EdgeProps);

%Add some noise to the graph
N = size(G.Edges,1);
G_nsy = G;
for i = 1:N
    G_nsy.Edges.R{i} = G_nsy.Edges.R{i} + mvnrnd(zeros(3,1),.001*eye(3))';
    G_nsy.Edges.T{i} = G_nsy.Edges.T{i} + mvnrnd(zeros(3,1),.001*eye(3))';
end

%optimize graph
G_star = graphOpti(G_nsy);

%plot true graph
X = zeros(3,N);
T = zeros(3,N);
startPnt = zeros(3,N);

for i = 1:N
    a = G.Edges.EndNodes(i,:);
    T(:,i) = G.Edges.T{i};
    X(:,a(2)) = X(:,a(1)) + T(:,i);
    startPnt(:,i) = X(:,a(1));
end

figure
quiver(startPnt(1,:),startPnt(2,:),T(1,:),T(2,:),0)
hold on

%plot noisy graph
X = zeros(3,N);
T = zeros(3,N);
startPnt = zeros(3,N);

for i = 1:N
    a = G_nsy.Edges.EndNodes(i,:);
    T(:,i) = G_nsy.Edges.T{i};
    X(:,a(2)) = X(:,a(1)) + T(:,i);
    startPnt(:,i) = X(:,a(1));
end

quiver(startPnt(1,:),startPnt(2,:),T(1,:),T(2,:),0)

%plot optimized graph
X = zeros(3,N);
T = zeros(3,N);
startPnt = zeros(3,N);

for i = 1:N
    a = G_star.Edges.EndNodes(i,:);
    T(:,i) = G_star.Edges.T{i};
    X(:,a(2)) = X(:,a(1)) + T(:,i);
    startPnt(:,i) = X(:,a(1));
end

quiver(startPnt(1,:),startPnt(2,:),T(1,:),T(2,:),0)
legend('True','Noisy','Optimized')

%do the same thing for the rotations

%true roation
R0 = zeros(1,N);
R = zeros(1,N);
startPnt = zeros(1,N);

for i = 1:N
    a = G.Edges.EndNodes(i,:);
    R(i) = G.Edges.R{i}(3);
    R0(a(2)) = R0(a(1)) + R(i);
    startPnt(i) = R0(a(1));
end

figure
rho = ones(1,100);
range = linspace(0,.25,4);
for i = 1:N
    theta = linspace(startPnt(i),startPnt(i)+R(i),100);
    polarplot(theta,range(i)+rho,'k')
    hold on
end

%initial estimate of rotation
R0 = zeros(1,N);
R = zeros(1,N);
startPnt = zeros(1,N);

for i = 1:N
    a = G_nsy.Edges.EndNodes(i,:);
    R(i) = G_nsy.Edges.R{i}(3);
    R0(a(2)) = R0(a(1)) + R(i);
    startPnt(i) = R0(a(1));
end

rho = ones(1,100);
range = linspace(.5,.75,4);
for i = 1:N
    theta = linspace(startPnt(i),startPnt(i)+R(i),100);
    polarplot(theta,range(i)+rho,'r')
    hold on
end

%optimized estimate of rotation
R0 = zeros(1,N);
R = zeros(1,N);
startPnt = zeros(1,N);

for i = 1:N
    a = G_star.Edges.EndNodes(i,:);
    R(i) = G_star.Edges.R{i}(3);
    R0(a(2)) = R0(a(1)) + R(i);
    startPnt(i) = R0(a(1));
end

rho = ones(1,100);
range = linspace(1,1.25,4);
for i = 1:N
    theta = linspace(startPnt(i),startPnt(i)+R(i),100);
    polarplot(theta,range(i)+rho,'b')
    hold on
end

legend('True','','','','Noisy','','','','Optimized','','','')
