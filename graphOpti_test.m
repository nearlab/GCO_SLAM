clear
close all
clc

% Test of graph optimization function

%initialize graph
G = graph();
G.Edges.s = {};
G.Edges.R = {};
G.Edges.T = {};
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
varNames_Edge = cell(1,3);
varNames_Edge{1} = 's';
varNames_Edge{2} = 'R';
varNames_Edge{3} = 'T';
EdgeProps = table(cell(1),cell(1),cell(1),'VariableNames',varNames_Edge);

%first edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = angle2dcm(0,0,pi/2,'XYZ');
EdgeProps.T{1} = [0 1 0]';
G = addedge(G,1,2,EdgeProps);

%second edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = angle2dcm(0,0,pi/2,'XYZ');
EdgeProps.T{1} = [1 0 0]';
G = addedge(G,2,3,EdgeProps);

%third edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = angle2dcm(0,0,pi/2,'XYZ');
EdgeProps.T{1} = [0 -1 0]';
G = addedge(G,3,4,EdgeProps);

%fourth edge
EdgeProps.s{1} = 1;
EdgeProps.R{1} = angle2dcm(0,0,-pi/2,'XYZ');
EdgeProps.T{1} = [1 0 0]';
G = addedge(G,1,4,EdgeProps);

plot(G)

% %call function
% G_star = graphOpti(G)
% plot(G);
% hold on
% plot(G_star)