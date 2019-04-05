function [G_star] = graphOpti(G)
%graphOpti Optimizes the graph according to sectioon 4 of the source
%document
%   Input: G - graph
%   Output: G_star - optimized graph

%calculate the minimum spanning tree
G_min = minspantree(G);

%number of edges in G
N = height(G.Edges);

%number of egdes in G_min
N_min = height(G_min.Edges);

%check to see if loops are present
if(N == N_min)
    disp('Error: G already minimum span')
    return
end

%initialize list of edges not in minspantree, f
f = [];
f_idx = [];

%find the edges which are no longer in the minimum spanning tree
for i=1:N
    a = G.Edges.EndNodes(i,:);
    if(~ismember(a,G_min.Edges.EndNodes,'rows'))
        f = [f; a];
        f_idx = [f_idx; i];
    end
end

%number of trimmed edges
F = N-N_min;

%intialize shortest path trees
shortPath = cell(F,2);

%calculate shortest path tree for each trimmed edge
for i = 1:F
    shortPath{i,1} = shortestpathtree(G_min,f(i,1),f(i,2));
    shortPath{i,2} = shortestpath(G_min,f(i,1),f(i,2));
end

%initialize shortest path cycle constraints
cycleConts = cell(F,3);

%calculate cycle constraint
for i = 1:F
    %find number of edges to complete path of i trimmed edge
    L = height(shortPath{i}.Edges);
    
    %initialize s, R, and T for the cycle
    s_cycle = 1;
    R_cycle = eye(3);
    T_cycle = [0 0 0]';
    
    %shortest path info for this edge
    s = shortPath{i,1}.Edges.s;
    endNodes = shortPath{i,1}.Edges.EndNodes;
    R = shortPath{i,1}.Edges.R;
    T = shortPath{i,1}.Edges.T;
    
    %run through path to find cycle constraints
    for j = L:-1:1
        %check direction of edge
        if(endNodes(j,1) < endNodes(j,2))
            R_cycle = angle2dcm(R{j}(1),R{j}(2),R{j}(3),'XYZ')*R_cycle;
            T_cycle = T_cycle + T{j};
            s_cycle = s_cycle * s{j};
        else
            R_cycle = angle2dcm(R{j}(1),R{j}(2),R{j}(3),'XYZ')'*R_cycle;
            T_cycle = T_cycle - T{j};
            s_cycle = s_cycle / s{j};
        end
    end
    
end
%assign output
G_star = shortPath{1,1};
shortPath{1,2}

end

