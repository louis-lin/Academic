function [y, Ac, Acc] = areas_circle(D,ds,t,n)
% Obtains fiber discretization geometry for circular section
%% Input
% D is the diameter of the section
% ds is the confined diameter of the section
% t is the width of the concrete fiber
% n is the total number of fibers
%% Output
% y is the distance from the bottom of the section to the centroid of each
% fiber (vector)
% Ac is the area of unconfined concrete of each fiber (vector)
% Acc is the area of confined concrete of each fiber (vector)
%%
R = D/2;    r = ds/2;
y_coverb = (D - ds)/2;
y_covert = D - y_coverb;
y = zeros(n,1);
Ac = zeros(n,1);    Acc = zeros(n,1);

for ff = 1:n
    y(ff) = t*(ff-0.5);   
    if (y(ff) > y_coverb) && (y(ff) < y_covert)
        xcc = sqrt(r^2 - (y(ff)-R)^2);
        Acc(ff) = 2*xcc*t;   
    else, xcc = 0; 
    end
    xc = sqrt(R^2 - (y(ff)-R)^2);
    bc = xc - xcc;
    Ac(ff) = 2*bc*t;    
end
end