clc;
% filename = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW3\files\tutorial 4\MK Analysis Example\run.tcl";
openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";
RunName = '.\Run01.tcl';
loadControlName = '.\loadControlStaticAnalysis01.tcl';

setRun(RunName, loadControlName, 'model2', 0.0)

[filepath,name,ext] = fileparts(RunName);
[filepath,name,ext,openseesPath] = convertStringsToChars(filepath,name,ext,openseesPath);
currpath = pwd;
cd(filepath)
system(['"',openseesPath,'" "' name, ext, '"']);
cd(currpath);
%%
figure(3);
load('AnalysisResults/MK.txt')
plot(MK(:,3),MK(:,1),'LineWidth',1.5,"DisplayName","Moment Curvature"); 
hold on; grid on; box on; title("Moment Curvature")
ylabel('Moment [kip-in]'); xlabel('Curvature[-]');
xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
axis([-2*10^-3,2*10^-3, -4000,4000]);
%%
figure(4); hold on;
plot(MK(:,3),MK(:,2),'LineWidth',1.5,"DisplayName","Centroid Strain"); 
title(["Axial Strain Reponse","With Axial Load Ratio = "+ num2str(axial_Load,'%1.1f')] ); grid on; box on; 
xlabel('Curvature [1/in]'); ylabel('Strain [-]');