function [G_star] = graphOpti(G)
%graphOpti Optimizes the graph according to sectioon 4 of the source
%document
%   Input: G - graph
%   Output: G_star - optimized graph
v = bfsearch(G,1)

%number of edges
N = length(v) - 1;

%initialize graph
T = graph();

%loop to build new graph
for i = 1:N
    T = addedge(T,v(i),v(i+1));
end

G_star = T;

end

