function [Likli] = graphOptiFmin(x,shortPath,local_e,local_f,curr_x_Ptr)
%graphOptiFmin calculates the negative log liklihood in GCO SLAM. Function
%to be minimized with lsqnonlin
% 
% INOUTS:
% 
% x - a column vector containing elements to be minimized. These elements
% correspond to edges [e_1 e_2 ... e_N] where N+F is the total number of
% edges in the original graph. Each edge contains 7 elements, these are
% ordered according to [s R1 R2 R3 T1 T2 T3] where s is a scale, R is three
% angles in an 'XYZ' rotation, and T is a translation. These are defined
% such that a point x in one node maps along the edge according to S(x) =
% s(Rx + T)
% 
% shortPath - Fx1 cell array where F is the number of edges which have been
% removed in creating a minimum spanning tree. Each element is vector
% containing the edge (in x) index which must be taken to satisfy the cycle
% constraint. The element is negative if the edge should be taken
% backwards.
% 
% local_e - a Nx2 cell array containing the prior of each edge in the
% minimum spanning tree. The first column contains mean information
% according to mu = [s R1 R2 R3 T1 T2 T3] where s is a scale, R is three
% angles in an 'XYZ' rotation, and T is a translation. These are defined
% such that a point x in one node maps along the edge according to S(x) =
% s(Rx + T). The second column contains covariance information according to
% Sig = cov(mu,mu)
%
% local_f- a Fx2 cell array containing the prior of each edge in the
% removed in creating the minimum spanning tree. The first column contains
% mean information according to mu = [s R1 R2 R3 T1 T2 T3] where s is a
% scale, R is three angles in an 'XYZ' rotation, and T is a translation.
% These are defined such that a point x in one node maps along the edge
% according to S(x) = s(Rx + T). The second column contains covariance
% information according to Sig = cov(mu,mu)
% 
% OUTPUTS:
% 
% L: 2* -log likelihood (variable to be minimized)

%grab F
F = size(shortPath,1);

%find N
N = size(local_e,1);

%for ease of coding, bin x into a cell array. (This is definitely slow)
x_cell = cell(N,1);
for i = 1:N
    idx = (1:7) + 7*(i-1);
    x_cell{i} = x(idx);
end

%calculate the terms for L(e|local_e)
L_e_local_e = zeros(1,F);
for i = 1:N
    %extract
    curr_x = x_cell{i};
    mu = local_e{i,1};
    sig = local_e{i,2};
    
    %calculate (ignore 1/2 term)
    L_e_local_e(i) = (curr_x - mu)'/sig*(curr_x - mu);
end

%initialize curr_x_MAT
curr_x_MAT = zeros(7,F);
%calculate the terms for L(path(f)|local_f)
L_pathf = zeros(F,1);
for i = 1:F
    %extract prior
    mu = local_f{i,1};
    sig = local_f{i,2};
    
    %find the path
    path = shortPath{i};
    
    %find the length of the path
    L = length(path);
    
    %initialize cycle mapping
    s_cycle = 1;
    R_cycle = eye(3);
    T_cycle = [0 0 0]';
    
    %run through path to find cycle constraints
    for j = 1:L
        %check direction of edge
        if(path(j) > 0)
            k = path(j); %edge index
            R_cycle = angle2dcm(x_cell{k}(2),x_cell{k}(3),x_cell{k}(4),'XYZ')*R_cycle;
            T_cycle = T_cycle + [x_cell{k}(5) x_cell{k}(6) x_cell{k}(7)]';
            s_cycle = s_cycle * x_cell{k}(1);
        else
            k = -path(j); %edge index
            R_cycle = angle2dcm(x_cell{k}(2),x_cell{k}(3),x_cell{k}(4),'XYZ')'*R_cycle;
            T_cycle = T_cycle - [x_cell{k}(5) x_cell{k}(6) x_cell{k}(7)]';
            s_cycle = s_cycle / x_cell{k}(1);
        end
    end
    
    %convert R_cycle back to angles
    [R1, R2, R3] = dcm2angle(R_cycle,'XYZ');
    
    %create current x
    curr_x = [s_cycle R1 R2 R3 T_cycle']';
    
    curr_x_MAT(:,i) = curr_x;
    
    %calculate (ignore 1/2 term)
    L_pathf(i) = (curr_x - mu)'/sig*(curr_x - mu);  
end

curr_x_MAT = [curr_x_MAT, curr_x_MAT];
%export curr_x_MAT
curr_x_Ptr.Value = curr_x_MAT;
    
%finally, calculate the cost
Likli = sum(L_e_local_e) + sum(L_pathf);

end

