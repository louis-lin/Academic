addpath(".\function");
%  close all;
% modelDefFilePath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW4\tutorial\opensees\Model\modelData.txt";
% nDim = 3;
% crdTransfMatrix = [1,0,0;0,1,0;0,0,1]';
% lineWidth = 1;
% figNum = 1;
% plotLineModel(modelDefFilePath, nDim, crdTransfMatrix, lineWidth, figNum)
% h = findobj('Type','line'); set(h,'LineWidth',1,'MarkerSize',1,'MarkerFaceColor','none');
%     set(gca,'xtick',[],'ytick',[],'ztick',[])
%     set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])

%% Static EW Force based Elements
clc; close all;
figName = "temp";
folder = "static_EW_force";
direction = "EW";

% plotSection("Core Wall Discretization",folder,1)
% ylim([-50,170]); zlim([-100,75]);
% line([0,0], [0,0], 2*zlim, 'LineStyle','-.','LineWidth', 1, 'Color', 'k');
% print_figure("Core Wall Discretization",[3.25,3.5])
% plotSection("Coupling Beam Discretization",folder,2)

plotBaseShear("A I a",folder) % Part A Part I Part as

% plotMomentCurvature("A I b", folder, "EW")

% plotAxialStrain("A I c i", folder, direction)

% plotNA("A I c ii", folder, direction)

% plotShearDeformation("A I d" , folder)

% plotHorDisp("A I e", folder, 1, direction,"Force Based")

% plotElementAxialMoment(figName, folder, direction)
% plotSectionAxialMoment("A I f", folder, direction)

%%  Static EW Disp. based Elements
clc; close all;
figName = "temp";
folder = "static_EW_disp";
direction = "EW";

% plotHorDisp(figName, folder, 2, direction,"Disp. Based")

% plotHorDisp("A I g i", "static_EW_force", 1, direction,"Force Based")

% plotElementAxialMoment("A I g ii", folder, direction,'dispBeamColumn',2)
% plotSectionAxialMoment("A I g ii", folder, direction,'dispBeamColumn',2)
%% Static EW Linear Material
clc; close all;
figName = "temp";
folder = "static_EW_lin";
direction = "EW";
% plotBaseShear("A I h i",folder) % Part A Part I Part a

% plotAxialStrain("A I h ii", folder, direction)

% plotHorDisp(figName, folder, 1, direction,"Linear Material")
% plotHorDisp("A I h iii", "static_EW_force", 1, direction,"Nonlinear Material")

plotElementAxialMoment("A I h iv", "static_EW_lin", direction,'forceBeamColumn', 1,-1,"Linear Material")
plotElementAxialMoment("A I h iv", "static_EW_force", direction,'forceBeamColumn', 1,-1,"Nonlinear Material")

%% Static NS
clc; close all;
figName = "temp";
folder = "static_NS_force";
direction = "NS";
% plotBaseShear("A II a","static_NS_force") % Part A Part I Part a

% plotMomentCurvature("A II b", "static_NS_force", "NS")

% plotAxialStrain("A II c i", folder, direction)

% plotNA("A II c ii", folder, direction)

% plotHorDisp("A II e", folder, 1, direction,"Force Based")

% plotElementAxialMoment("A II f", folder, direction)

%% Dynamic EW
clc; close all;
figName = "temp";
folder = "dynamic_EW";
direction = "EW";

% plotModeShapeAll(folder)
% plotDamping("B I a4", folder, [1,4])
% print_figure("B I a4");

% plotRecord(folder + "\NORTHR_SYL360.txt")
% plotRecord(folder + "\NORTHR_SYL090.txt")

% plotOTM("B I c1", folder, direction)

% plotAccelerationDisplacement("B I c2", folder, direction)

% plotNormBaseShear("B I c (2ii)", folder, direction)

% plotMomentCurvature("B I c(3)", folder, direction)

% plotAxialStrain("B I c(4)", folder, direction)

% plotShearDeformation(figName , folder)

%% Dynamic EW Linear 
clc; close all;
figName = "temp";
folder = "dynamic_EW_lin";
direction = "EW";

% plotOTM("B I d0", folder, direction)

% plotAccelerationDisplacement("temp", folder, direction)

% plotNormBaseShear("B I d (2ii)", folder, direction)

% plotMomentCurvature("B I d(3)", folder, direction)

% plotAxialStrain("B I d(4)", folder, direction)

% plotShearDeformation("B I d(5)" , folder)

%% Dynamic EW 2 Dt 
clc; close all;
figName = "temp";
folder = "dynamic_EW_dt";
direction = "EW";

% plotOTM("B I e0", folder, direction)

% plotNormBaseShear(figName, folder, direction)
% plotNormBaseShear(figName, "dynamic_EW", direction)
% legend("\DeltaT = 0.1s", "\DeltaT = 0.2s");
% print_figure("B I e (2ii)")

% plotAccelerationDisplacement("B I e2", folder, direction,"\DeltaT = 0.1s");
% plotAccelerationDisplacement("B I e2", "dynamic_EW", direction,"\DeltaT = 0.2s",false)

%% Dynamic EW Damping!
clc; close all;
figName = "temp";
folder = "dynamic_EW_kcommit";
direction = "EW";

% plotOTM("B I e0", folder, direction)

% plotNormBaseShear(figName, folder, direction)
% plotNormBaseShear(figName, "dynamic_EW", direction)
% legend();
% print_figure("B I f(1)")

% plotAccelerationDisplacement("B I f2", folder, direction,"K_{committed}");
% figure(1); hold on; figure(2); hold on; 
% plotAccelerationDisplacement("B I f(2)", "dynamic_EW", direction,"K_{Initial}",false)

%% Dynamic EWNS 
clc; close all;
figName = "temp";
folder = "dynamic_EWNS";
direction = "EW";

plotDamping("B II a4", folder, [1,2])
% print_figure("B II a4");

% plotOTM("B II ai", folder, "EW")
% plotOTM("B II aii", folder, "NS")
% legend("Location","Southwest");
% print_figure("B II aii");

% plotAccelerationDisplacement("B II b(i)1", folder, "EW");

% plotAccelerationDisplacement("B II b(i)2", folder, "NS");

% plotOrbitalDisplacement("B II b(i)3", folder)

% plotNormBaseShear("B II b(ii)1", folder, "EW")

% plotNormBaseShear("B II b(ii)2", folder, "NS")

% plotOrbitalShear("B II b(ii)3", folder)

% plotMomentCurvature("B II c1", folder, "EW")

% plotMomentCurvature("B II c2", folder, "NS")