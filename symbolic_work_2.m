clear
close all
clc

%lets take it nice and easy to figure this out

A = sym('A',[3 4],'real');


syms up vp xp yp zp u v q 'real'

z = (A*[u v q 1]')';

up = z(1)/z(3);

vp = z(2)/z(3);

%% p2up/pu2
puppu = diff(up,u);
p2uppu2 = diff(puppu,u);

p2uppu2 = subs(p2uppu2,u,0);
p2uppu2 = subs(p2uppu2,v,0);
p2uppu2 = subs(p2uppu2,q,1)

%% p2up/pv2
puppv = diff(up,v);
p2uppv2 = diff(puppv,v);

p2uppv2 = subs(p2uppv2,u,0);
p2uppv2 = subs(p2uppv2,v,0);
p2uppv2 = subs(p2uppv2,q,1)

%% p2up/pq2
puppq = diff(up,q);
p2uppq2 = diff(puppq,q);

p2uppq2 = subs(p2uppq2,u,0);
p2uppq2 = subs(p2uppq2,v,0);
p2uppq2 = subs(p2uppq2,q,1)

%% p2vp/pu2
pvppu = diff(vp,u);
p2vppu2 = diff(pvppu,u);

p2vppu2 = subs(p2vppu2,u,0);
p2vppu2 = subs(p2vppu2,v,0);
p2vppu2 = subs(p2vppu2,q,1)

