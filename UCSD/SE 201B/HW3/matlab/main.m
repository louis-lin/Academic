openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";

%% Monotonic with Single Axial Load
clc; close all;
RunName = '.\run.tcl';
loadControlName = 'loadControlStaticAnalysis.tcl';
analysisName = 'dispControlAnalysis.tcl';
modelName = 'model02.tcl';
curvatures = 0.03;
axialLoad = 0.0;

setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures)
runTCLfile(RunName)
plotMK("Case (a.3) Cross Section"); grid minor;
[s1, s2] = addYield(); 
s1.HandleVisibility = 'on'; s1.DisplayName = 'Concrete Crushing';
s2.HandleVisibility = 'on'; s2.DisplayName = 'Steel Yielding';
print_figure("Part B MK", [13, 6], 18)

%% Monotonic with Varying Axial Load
clc; close all;
RunName = '.\run.tcl';
loadControlName = 'loadControlStaticAnalysis.tcl';
analysisName = 'dispControlAnalysis.tcl';
modelName = 'model01.tcl';
curvatures = 0.03;

for axialLoad = [0.0, 0.1, 0.2, 0.4, 0.6, 0.7]
    close all;
    setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures)
    runTCLfile(RunName)
    plotMK("Axial Load Ratio = "+sprintf('%1.1f',axialLoad) );
    addYield();
    H = 15.748;
    K = [0.0013, 0.004, 0.008, 0.0130 0.0200]/H;
    plotStrainProfile(H, K)
    sgtitle("Strain Diagram of Axial Load Ratio "+num2str(axialLoad,'%1.1f'),'FontSize',18);
    print_figure("Part E iv Strain Diagram of Axial Load Ratio "+num2str(10*axialLoad), [13, 2.75], 10)
end
figure(1);
print_figure("Part E Moment Curvature Varying Axial Load", [13, 6], 18)
%% Monotonic & Cyclic Envelope
clc; close all;
RunName = '.\run.tcl';
loadControlName = 'loadControlStaticAnalysis.tcl';
analysisName = 'dispControlAnalysis.tcl';
modelName = 'model02.tcl';

for axialLoad = [0.0, 0.1, 0.2, 0.4, 0.6, 0.7]
    curvatures = [0.0, 0.005, -0.005, 0.01, -0.01, 0.02, -0.02, 0.03, -0.03, 0.0];
    setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures, 0.001)
    runTCLfile(RunName)
    
    plotMK('Cyclic Moment Curvature', "Axial Load Ratio = "+sprintf('%1.1f',axialLoad) );
    addYield();
    hold on;
    curvatures = 0.03;
    setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures, 0.001)
    runTCLfile(RunName)
    plotMK('Monotonic Moment Curvature',"Axial Load Ratio = "+sprintf('%1.1f',axialLoad) );
    addYield();
   
    figure(1);
    print_figure("Part L Moment Curvature Envelope Axial Load Ratio = "+10*axialLoad , [13,5], 18)
    close all;
end

%% Cyclic Moment Curvautre With Material 02
clc; close all;
RunName = '.\run.tcl';
loadControlName = 'loadControlStaticAnalysis.tcl';
analysisName = 'dispControlAnalysis.tcl';
modelName = 'model02.tcl';
curvatures = [0.0, 0.005, -0.005, 0.01, -0.01, 0.02, -0.02, 0.03, -0.03, 0.0];

for axialLoad = [0.0, 0.1, 0.2, 0.4, 0.6, 0.7]
    setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures, 0.001)
    runTCLfile(RunName)
    close all;
    plotMK("Axial Load Ratio = "+sprintf('%1.1f',axialLoad) );
    print_figure("Part F i Cyclic Moment Curvature"+num2str(10*axialLoad), [13, 5], 18)
    
    plotEoK("Axial Load Ratio = "+sprintf('%1.1f',axialLoad),"Axial Strain Response");
    figure(2); print_figure("Part F ii Axial Strain Axial Load Ratio "+num2str(10*axialLoad), [7,5], 15)
end


%% Cyclic Moment Curvautre With Material 01
clc; close all;
RunName = '.\run.tcl';
loadControlName = 'loadControlStaticAnalysis.tcl';
analysisName = 'dispControlAnalysis.tcl';
% modelName = 'model01.tcl';
curvatures = [0.0, 0.005, -0.005, 0.01, -0.01, 0.02, -0.02, 0.03, -0.03, 0.0];
tic 
for axialLoad = [0.0]
        close all;
        modelName = 'model01.tcl';
        setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures, 0.00001)
        runTCLfile(RunName)
        plotMK('Concrete01 & Steel01',["Moment Curvature", "With Axial Load Ratio = "+sprintf('%1.1f',axialLoad)]);
        plotEoK('Mat01',["Axial Strain Response","With Axial Load Ratio = "+num2str(axialLoad,'%1.1f')]);
        
        modelName = 'model02.tcl';
        setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures, 0.001)
        runTCLfile(RunName)
        plotMK('Concrete02 & Steel02',["Moment Curvature", "With Axial Load Ratio = "+sprintf('%1.1f',axialLoad)]);
        plotEoK('Mat02',["Axial Strain Response","With Axial Load Ratio = "+num2str(axialLoad,'%1.1f')]);
        
        figure(1); print_figure("Part G Cyclic MK Axial Load Ratio "+num2str(10*axialLoad), [13,5], 18);
        savefig(1,"../figures/"+"Part G Cyclic MK Axial Load Ratio "+num2str(10*axialLoad),'compact')
        figure(2); print_figure("Part G Axial Strain Axial Load "+num2str(10*axialLoad), [7,5], 18)
        savefig(2,"../figures/"+"Part G Axial Strain Axial Load "+num2str(10*axialLoad),'compact')
end
toc
%% X. Li Test 1
clc; close all;
[K1, M1] = getXLisheet('Response U1', "B10:F64");

RunName = '.\run.tcl';
loadControlName = 'loadControlStaticAnalysis.tcl';
analysisName = 'dispControlAnalysis.tcl';
modelName = 'modelLI1.tcl';

curvatures1 = [0.0, 0.0210457, -0.019193, 0.0205331];
for axialLoad = .2953
    setupRun(RunName, loadControlName, analysisName, modelName, axialLoad, curvatures1,0.001)
    runTCLfile(RunName);
    plt = plotMK("4 Step Curvatures"); plt.LineWidth =2;
end

plot(K1/15.748,M1*12,'DisplayName','Test U1','LineWidth',2);
[s1, s2] = addYield(); 
s1.HandleVisibility = 'on'; s1.DisplayName = 'Concrete Crushing';
s2.HandleVisibility = 'on'; s2.DisplayName = 'Steel Yielding';
set(gcf,'Position',[0,0,1300,500])
figure(1); print_figure("Part H X Li Test 1", [13,5], 18);
%% Curvature of X. Li 
clc; close;

figure(5); hold on; box on;
K = K1;
yyaxis left; 
plot(K,1:length(K),'LineWidth',2,'DisplayName','Experimential'); 
ylabel('Measurement Steps'); xlabel('Curvature [1/in]');
yyaxis right; ylabel('Model Steps'); yticks(0:1:length(curvatures1));
plot(curvatures1,1:length(curvatures1),'LineWidth',2,'DisplayName','Model');
title('Experiment U1'); legend('Location','southeast');
set(gca,'FontSize',18);

print_figure("Part H Curvature", [13,5], 18);
%% PM Diagrams for Concrete01 and Steel01
close all; clc;

runTCLfile('.\runPM_NZ_01.tcl');
PlotPM(6, 'NZ Criterion = -0.004' );
runTCLfile('.\runPM_ACI_01.tcl');
PlotPM(6, 'ACI Criterion = -0.003' );
grid minor
print_figure("Part I i PM Mat01", [6.5,5], 18);
%% PM Diagrams for Concrete02 and Steel02
close all; clc;
runTCLfile('.\runPM_NZ_02.tcl');
PlotPM(7, 'NZ Criterion = -0.004' );
runTCLfile('.\runPM_ACI_02.tcl');
PlotPM(7, 'ACI Criterion = -0.003' );
grid minor
print_figure("Part I i PM Mat02", [6.5,5], 18);
%% PMM Diagram
close all; clc;
hold on;
runTCLfile('.\runPMM.tcl')
plotPMM(8)
print_figure("Part I ii PMM", [8,7], 18);

%% FUNCTION Runs a TCL File
function runTCLfile(filename)
    openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";
    [filepath,name,ext] = fileparts(filename);
    [filepath,name,ext,openseesPath] = convertStringsToChars(filepath,name,ext,openseesPath);
    currpath = pwd;
    cd(filepath)
    system(['"',openseesPath,'" "' name, ext, '"']);
    cd(currpath);
end
%% FUNCTION Plot Moment Curvature 
function plt = plotMK(legName, titleName)
    arguments
        legName = 'Moment Curvature';
        titleName = 'Moment Curvature'
    end
    figure(1); hold on;
    load('./AnalysisResults/MK.txt'); 
    plt = plot(MK(:,3),MK(:,1),'LineWidth',2,"DisplayName",legName); 
    grid on; box on;
    title(titleName); ylabel('Moment [kip-in]'); xlabel('Curvature [1/in]');
    legend("Location","Southeast"); xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
end

%%  FUNCTION Adds in Crushing and Yielding of Steel
function [scat1, scat2] = addYield(~)
    fy = 65.9;
    ecu = -0.003;
    load('./AnalysisResults/ConcFib2_SS.txt');
    load('./AnalysisResults/SteelFib1_SS.txt');
    load('./AnalysisResults/MK.txt'); 
    [~, yield] = min(abs(SteelFib1_SS(:,2) - fy));
    [~, crush] = min(abs(ConcFib2_SS(:,3) - ecu));

    scat1 = plot(MK(crush,3), MK(crush,1),'ko','MarkerSize',10, 'LineWidth', 1.5,'HandleVisibility','off');
    scat2 = plot(MK(yield,3), MK(yield,1),'kd','MarkerSize',10,'LineWidth',1.5,'HandleVisibility','off');
end

%% FUNCTION  Plot Strain Profile
function [] = plotStrainProfile(H, K)
    close;
    figure(4); set(gcf,'DefaultAxesFontSize', 10)
    load('./AnalysisResults/MK.txt'); 
    sectionCoord = linspace(-H/2,H/2,100);
    plotYLim = [0,0];
    for i = 1:length(K)
        subplot(1,length(K),i); hold on; box on
        [~, indK] = min(abs(MK(:,3) - K(i)));
        eps = MK(indK,2) - sectionCoord*K(i);
        plot(sectionCoord,eps,'LineWidth',1.,'Color','k')
        plot(sectionCoord,zeros(size(sectionCoord)),'b-','LineWidth',2);
        plot([sectionCoord(1),sectionCoord(1)], [0, eps(1)], 'LineWidth',1.,'Color','k')
        plot([sectionCoord(end),sectionCoord(end)], [0, eps(end)], 'LineWidth',1.,'Color','k')
        yLim = get(gca,'yLim');
        if yLim(1) < plotYLim(1)
            plotYLim(1) = yLim(1);
        end
        if yLim(2) > plotYLim(2)
            plotYLim(2) = yLim(2);
        end
        [~,indNA] = min(abs(eps - 0));
        depthNA = H/2 - sectionCoord(indNA);
        plot([sectionCoord(indNA),sectionCoord(end)],[0,0],'r-','LineWidth',2);
        title(["NA = " + num2str(depthNA,3)],'FontSize',12)
    end
    figure(4)
    for i = 1:length(K)
        subplot(1,length(K),i)
        set(gca,'yLim',plotYLim)
        xline(0);
    end
end

%% FUNCTION Plot Axial Strain Curvature
function plt = plotEoK(displayName, titleName)
    arguments
        displayName = 'Axial Strain Response';
        titleName = 'Axial Strain Response';
    end
    figure(2); hold on;
    load('./AnalysisResults/MK.txt'); 
    plt = plot(MK(:,3),MK(:,2),'LineWidth',2,'DisplayName',displayName); 
    grid on; box on;
    title(titleName); ylabel('Strain [-]'); xlabel('Curvature [1/in]'); legend('Location','southeast');
     xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
end
%% FUNCTION Get X. Li's 
function [K,M] = getXLisheet(sheet, range)
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = sheet;
    opts.DataRange = range;
    opts.VariableNames = ["K", " "," "," ", "M"];
    opts.SelectedVariableNames = ["K", "M"];
    opts.VariableTypes = ["double", "char", "char", "char", "double"];
    tbl = readtable("C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW3\files\XLi Units 1 and 2.xlsx", opts, "UseExcel", false);
    K = tbl.K;
    M = tbl.M;
end
%% FUNCTION Plot PM Diagram
function plt = PlotPM(figNum, displayName)
    load 'AnalysisResults/PM_Results.txt';
    figure(figNum);  hold on;
    plt = plot(PM_Results(:,2),PM_Results(:,1),'LineWidth',2,'DisplayName',displayName);
    grid on; box on; legend();
    xlabel('Moment [kip-in]')
    ylabel('Axial load [lbf]')
    title('PM Interaction Diagram')
    set(gcf,'Position',[0,0,600,500])
end
%% FUNCTION Plot PMM Diagram
function plotPMM(figNum)
    name='AnalysisResults/PM';

    numFiles = 21;
    for iFile = 1:numFiles
        fileLoad = [name num2str(iFile) '.txt'];
        mp{iFile} = load(fileLoad);
    end

    figure(figNum)
    for iFile = 1:21
        if iFile == 1
            h1 = plot3(mp{iFile}(:,11),mp{iFile}(:,12),mp{iFile}(:,1),'b','LineWidth',2);hold on
        else
            plot3(mp{iFile}(:,11),mp{iFile}(:,12),mp{iFile}(:,1),'b','LineWidth',2);hold on
        end    
    end
    for ii = 1:size(mp{iFile}(:,11),1)
        for iFile = 1:20
            plot3(...
                [mp{iFile}(ii,11) mp{iFile+1}(ii,11)], ...
                [mp{iFile}(ii,12) mp{iFile+1}(ii,12)],...
                [mp{iFile}(ii,1) mp{iFile+1}(ii,1)],...
                'r','LineWidth',0.5);hold on
        end
    end

    grid on
    box on

    title('PMM Interaction Diagram')
    xlabel('My [kip-in]')
    ylabel('Mz [kip-in]')
    zlabel('Axial Load [lbf]')
    view([120 15]);
end
%% FUNCTION Print Section
function printSectionTag(tag, name)
    secDefFilePath = "./Model/modelData.txt";
    grid off;
    figNum = 3;
    secTag = tag;
    camroll(90)
    fibColor = [1 0 0 1 0.5; 2 1 0 0 0.5; 3 0 0 0 1];
    plot_fiberSection(secDefFilePath, secTag, figNum, fibColor)
    camroll(90)
    title(["Case (a." + secTag+")"]);
    ylabel('Y [in]');
    zlabel('Z [in]');
end