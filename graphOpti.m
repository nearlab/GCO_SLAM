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

%find the edges which are no longer in the minimum spanning tree
for i=1:N
    a = G.Edges.EndNodes(i,:);
    if(~ismember(a,G_min.Edges.EndNodes,'rows'))
        f = [f; a];
    end
end

%assign output
G_star = G_min;

end

