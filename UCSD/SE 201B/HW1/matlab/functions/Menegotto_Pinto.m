function [Displacement, Force] = Menegotto_Pinto(U_conv, MatData, MatState)
% Runs the Menegotto Pinto Model with given converged displacements
spacing = 100; % Linearly interpolates 100 points between each converged displacement
length_of_U = numel(U_conv); % Amount of displacements
Displacement = zeros(1,length_of_U*spacing-spacing); % zero vector for newly interpolated points 
Force = Displacement; % zero vector

for i = 1:length(U_conv)-1
    Displacement(i*spacing - spacing +1 : i*spacing) = linspace(U_conv(i),U_conv(i+1),spacing); % Interpolateion with linspace
end
eps = Displacement/MatData.L; % Converts to strain history

for n = 1:numel(eps)
    MatState.eps(1,1) = eps(n);
    if n == 1
        MatState.eps(1,2) = 0.;
    else
        MatState.eps(1,2) = eps(n)-eps(n-1); % Change in strain is change in strain
    end
    MatState = Mate25n(MatData,MatState); % Runs the Menegotto
    Force(n) = MatState.Pres.sig * MatData.A; % Calculates the force for the iteration
    MatState.Past = MatState.Pres; %Updates the state
end
end 