L = 60;
A = 7.2654;
matDef = 'uniaxialMaterial Steel02 1 22.022159 30000. 0.05 2. 0.5 0.15 0. 1. 0. 1. 0.'; % Material definition from OpenSees
inputData = [1.3658, -1.4156, 1.142]/L; % vector of strain history (e.g., inputData = U_convergedPts/L)
numIncr = 100; % num of points to include between inputData(i) and inputData(i+1)
localOpenSeesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe"; % please change this !!
out = get_materialHysteresis(matDef, inputData, numIncr, localOpenSeesPath);
plot(out(:,1)*L, out(:,2)*A);