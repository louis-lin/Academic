close all; clc;
filename = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW3\files\tutorial 4\MK Analysis Example\run.tcl";
openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";
FileName = 'loadControlStaticAnalysis.tcl';
i = 1;
for axial_Load = [0.0, 0.1, 0.2, 0.4, 0.6, 0.7]
    [filepath,name,ext] = fileparts(filename);
    [filepath,name,ext,openseesPath] = convertStringsToChars(filepath,name,ext,openseesPath);
    currpath = pwd;
    cd(filepath)

    original = fileread(FileName);
    modified = ['set axialLoadRatio ' , num2str(axial_Load,'%1.2f'),newline, original];
    FID = fopen(FileName, 'w');
    if FID == -1, error('Cannot open file %s', modified); end
    fwrite(FID, modified, 'char');
    fclose(FID);
    system(['"',openseesPath,'" "' name, ext, '"']);
    cd(currpath);

    FID = fopen(FileName, 'w');
    if FID == -1, error('Cannot open file %s', modified); end
    fwrite(FID, original, 'char');
    fclose(FID);
    
    figure(3)
    hold on;
    fy = 65.9;
    ecu = -0.003;
    load('AnalysisResults/ConcFib2_SS.txt')
    load('AnalysisResults/SteelFib1_SS.txt')
    [~, yield] = min(abs(SteelFib1_SS(:,2) - fy));
    [~, crush] = min(abs(ConcFib2_SS(:,3) - ecu));
    load('AnalysisResults/MK.txt')
    plot(MK(:,3),MK(:,1),'LineWidth',1.5,"DisplayName","Axial Load Ratio: " + sprintf('%1.1f',axial_Load)); hold on;
    scat_crush = plot(MK(crush,3), MK(crush,1),'ko','MarkerSize',10, 'LineWidth', 1.5,"HandleVisibility",'off');
    scat_yeild = plot(MK(yield,3), MK(yield,1),'kd','MarkerSize',10,'LineWidth',1.5,"HandleVisibility",'off');
    hold on; grid on; box on
    grid on; box on; title("Moment Curvature")
    ylabel('Moment [kip-in]'); xlabel('Curvature[-]');
    legend("Location","Southeast",'FontSize',12); xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');

    
    figure(4)
    sgtitle("Strains at Various Curvatures for Axial Load Ratio = "+axial_Load); 
    H = 16;
    K = [0.0013, 0.004, 0.008, 0.0130 0.0200]/H;
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
        title(["K =  "+num2str(K(i)) ," depth NA = " + num2str(depthNA,3)])
        set(gca,'FontSize',12);
    end
    figure(4)
    for i = 1:length(K)
        subplot(1,length(K),i)
        set(gca,'yLim',plotYLim)
        xline(0);
    end
    print_figure("Part E iv Strain Diagram of Axial Load Ratio "+ num2str(axial_Load*10,'%i') ,[13,5])
    close(4)
    i = i+1;
end
figure(3);
scat_crush.HandleVisibility = "on";
scat_yeild.HandleVisibility = "on";
scat_crush.DisplayName = "Concrete Crushing";
scat_yeild.DisplayName = "Steel Yeilding";
print_figure("Part E Moment Curvature Varying Axial Load",[13,5],18)