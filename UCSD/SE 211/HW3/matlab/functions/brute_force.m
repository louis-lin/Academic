function[de,e]=brute_force(error,tol,de,e)
% Bisection method to update value of strain at centroid
%% Input
% error is the current value of the error
% tol is the tolerance value
% de is the current strain change
% e is the strain at the centroid at the current step (just one value, not
% the complete vector)
%% Output
% de is the updated value of strain change
% e is the updated value of strain at the centroid
if abs(error)>tol
    if (error<0 && de<0 || error>0 && de>0)
        de=de*-0.5;
        e=e+de;
    else
        e=e+de;
    end
end
end