function [G_star] = graphOpti(G)
%graphOpti Optimizes the graph according to sectioon 4 of the source
%document
%   Input: G - graph
%   Output: G_star - optimized graph

%calculate the minimum spanning tree
G_min = minspantree(G);

%number of edges in G
N_total = height(G.Edges);

%number of egdes in G_min
N = height(G_min.Edges);

%check to see if loops are present
if(N_total == N)
    disp('Error: G already minimum span')
    return
end

%initialize list of edges not in minspantree, f
f = [];
e = [];
f_idx = [];
e_idx = [];

%find the edges which are and arent in the minimum spanning tree
for i=1:N_total
    a = G.Edges.EndNodes(i,:);
    if(~ismember(a,G_min.Edges.EndNodes,'rows'))
        f = [f; a];
        f_idx = [f_idx; i];
    else
        e = [e; a];
        e_idx = [e_idx; i];
    end
end

%number of trimmed edges
F = N_total-N;

%intialize shortest path trees
shortPath_nodes = cell(F,1);

%calculate shortest path tree for each trimmed edge
for i = 1:F
    shortPath_nodes{i} = shortestpath(G_min,f(i,1),f(i,2));
end

%initialize the shortPath
shortPath = cell(F,1);

%we need to convert from a node path to a edge path
for i = 1:F
    %find number of edges in cycle path for ith trimmed edge
    Num_Cycle = length(shortPath_nodes{i})-1;
    
    %run through all the edges
    for j = 1:Num_Cycle
        %grab the endnodes for the jth edge
        a = [shortPath_nodes{i}(j), shortPath_nodes{i}(j+1)];
        
        %look for a in e
        ismember(a,e,'rows');
        idx = find(ismember(e,a,'rows'));
        
        %check to see if the row was found
        if(~isempty(idx)) %it was found
            shortPath{i}(j) = idx;
        else %not found, redo the search for the reverse
            a = [a(2), a(1)];
            idx = find(ismember(e,a,'rows'));
            shortPath{i}(j) = -idx; %negative to signify edge in reverse
        end
    end
end

%initialize local_e
local_e = cell(N,2);

%initialize x
x0 = [];

%populate
for i = 1:N
    idx = e_idx(i);
    s = G.Edges.s{idx};
    R = G.Edges.R{idx};
    T = G.Edges.T{idx};
    sig = G.Edges.Sig{idx};
    local_e{i,1} = [s R' T']';
    local_e{i,2} = sig;
    
    %also initialize x
    x0 = [x0' s R' T']';
    
end

% initialize local_f
local_f = cell(F,2);
for i = 1:F
    idx = f_idx(i);
    s = G.Edges.s{idx};
    R = G.Edges.R{idx};
    T = G.Edges.T{idx};
    sig = G.Edges.Sig{idx};
    local_f{i,1} = [s R' T']';
    local_f{i,2} = sig;
end

%create current x dummy data
curr_x = zeros(7,1);

curr_x_Ptr = libpointer('doublePtr',curr_x);
%run minimization
fun4min = @(x) graphOptiFmin(x,shortPath,local_e,local_f,curr_x_Ptr);
options = optimoptions('lsqnonlin','Display','none','Algorithm','levenberg-marquardt',...
    'FunctionTolerance',1e-12);
x_hat = lsqnonlin(fun4min,x0,[],[],options);

%grab current x for last side
curr_x = curr_x_Ptr.Value;

%output
G_star = G;

%place x_hat into G_star
for i = 1:N
    idx = (1:7) + 7*(i-1);
    edge_idx = e_idx(i);
    G_star.Edges.s{edge_idx} = x_hat(idx(1));
    G_star.Edges.R{edge_idx} = x_hat(idx(2:4));
    G_star.Edges.T{edge_idx} = x_hat(idx(5:7));
end

%place curr_x into G_star
for i = 1:F
    idx = (1:7) + 7*(i-1);
    edge_idx = f_idx(i);
    G_star.Edges.s{edge_idx} = curr_x(idx(1));
    G_star.Edges.R{edge_idx} = curr_x(idx(2:4));
    G_star.Edges.T{edge_idx} = curr_x(idx(5:7));
end

end

