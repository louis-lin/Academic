clc; 
filename ="C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW2\opensees\run.tcl";
openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";

[filepath,name,ext] = fileparts(filename);
[filepath,name,ext,openseesPath] = convertStringsToChars(filepath,name,ext,openseesPath);
currpath = pwd;
cd(filepath)
system(['"',openseesPath,'" "' name, ext, '"']);
cd(currpath);

%%
close all; clc;
list = ["Corotational","Linear","PDelta"]; 
i =1;
color = ["#0072BD", "#D95319", "#7E2F8E","#4DBEEE"];
set(groot,'DefaultAxesFontSize', 18)
for analysistype = list
    modelDataDirPath = './opensees/'+analysistype+'/Model';
    deflectedShapeDirPath = './opensees/'+analysistype+'/DeflectedShape';
    nDim = 2;
    loadStep = 25:25:100;
    defScale = 1;
    crdTransfMatrix = eye(2);
    defColor = color(i);
    figNum = 1; i = i+1;
    undefColor = [0.5 0.5 0.5];
    undefLineWidth = 1.5;
    defLineWidth = 1.5;
%     plot_lineModel(modelDataDirPath, nDim, crdTransfMatrix, undefLineWidth, figNum);
    [~, ~, plots] = plot_lineDeflectedShape(modelDataDirPath, deflectedShapeDirPath, nDim, loadStep, defScale, crdTransfMatrix, undefColor, undefLineWidth, defColor, defLineWidth, figNum);
    plots.HandleVisibility = 'on';
    plots.DisplayName = analysistype;
    title("Opensees Results");
    xlabel("Deformation [in]"); ylabel("Deformation [in]"); 
    legend('Location','south');
     set(gcf, 'position', [1400 0 1000 800])
end
%%
[DOF35_Linear, DOF36_Linear] = readvars("./opensees/Linear/DeflectedShape/dispNode_13.txt");
[DOF35_Cor, DOF36_Cor] = readvars("./opensees/Corotational/DeflectedShape/dispNode_13.txt");
[DOF35_PDelta,  DOF36_PDelta] = readvars("./opensees/PDelta/DeflectedShape/dispNode_13.txt");
force = [-180,-360,-540,-720,-900,-1080,-1260,-1440,-1620,-1800,-1980,-2160,-2340,-2520,-2700,-2880,-3060,-3240,-3420,-3600,-3780,-3960,-4140,-4320,-4500,-4680,-4860,-5040,-5220,-5400,-5580,-5760,-5940,-6120,-6300,-6480,-6660,-6840,-7020,-7200,-7380,-7560,-7740,-7920,-8100,-8280,-8460,-8640,-8820,-9000,-9180,-9360,-9540,-9720,-9900,-10080,-10260,-10440,-10620,-10800,-10980,-11160,-11340,-11520,-11700,-11880,-12060,-12240,-12420,-12600,-12780,-12960,-13140,-13320,-13500,-13680,-13860,-14040,-14220,-14400,-14580,-14760,-14940,-15120,-15300,-15480,-15660,-15840,-16020,-16200,-16380,-16560,-16740,-16920,-17100,-17280,-17460,-17640,-17820,-18000];

close all;
figure(1);  
sgtitle('Opensees Results','FontWeight','bold', 'Fontsize',36)
subplot(1,2,1);hold on; 

title("Force-Displacement Curve of DOF 35");
set(gca,'DefaultLineLineWidth',4)
p = plot(-abs(DOF35_Linear), -force(1:numel(DOF35_Linear)),'DisplayName','Linear'); 
p = plot(-abs(DOF35_Cor), -force(1:numel(DOF35_Cor)),'DisplayName','Corotational');
p = plot(-abs(DOF35_PDelta), -force(1:numel(DOF35_PDelta)),'DisplayName','P\Delta Nonconsistent');
set(gca,'DefaultLineLineWidth',3)
xlabel('Horizontal Displacement [in]'); ylabel('Force [N]');
grid on; grid minor; legend('Location','Best');

subplot(1,2,2); hold on;
title("Force-Displacement Curve of DOF 36");
set(gca,'DefaultLineLineWidth',4)
p = plot(-abs(DOF36_Linear), -force(1:numel(DOF35_Linear)),'DisplayName','Linear');
p = plot(-abs(DOF36_Cor), -force(1:numel(DOF35_Cor)),'DisplayName','Corotational'); 
p = plot(-abs(DOF36_PDelta), -force(1:numel(DOF35_PDelta)),'DisplayName','P\Delta Nonconsistent');
set(gca,'DefaultLineLineWidth',3)
xlabel('Vertical Displacement [in]'); ylabel('Force [N]');
grid on; grid minor; legend('Location','Best');

set(gcf,'Position',[0,0,2000,800]);