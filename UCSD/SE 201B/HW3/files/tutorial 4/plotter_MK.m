%% 
% clear all;close all;clc
figure(1)
load('AnalysisResults/ConcFib1_SS.txt')
load('AnalysisResults/ConcFib2_SS.txt')
hold on
plot(ConcFib1_SS(:,3),ConcFib1_SS(:,2),'b-','LineWidth',1.5,'DisplayName',"Extreme Tensile Fiber")
plot(ConcFib2_SS(:,3),ConcFib2_SS(:,2),'r-','LineWidth',1.5,'DisplayName',"Extreme CompressiveFiber")
grid on; box on; title("Stress-Strain Time History of Concrete Extreme Fibers")
ylabel('Stress [ksi]'); xlabel('Strain [-]');
legend("Location","Southeast"); xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
 
figure(2)
load('AnalysisResults/SteelFib1_SS.txt')
load('AnalysisResults/SteelFib2_SS.txt')
hold on
plot(SteelFib1_SS(:,3),SteelFib1_SS(:,2),'b-','LineWidth',1.5,'DisplayName',"Extreme Tensile Fiber")
plot(SteelFib2_SS(:,3),SteelFib2_SS(:,2),'r-','LineWidth',1.5,'DisplayName',"Extreme CompressiveFiber Fiber")
grid on; box on;
title("Stress-Strain Time History of Steel Extreme Fibers")
ylabel('Stress [ksi]'); xlabel('Strain [-]');
legend("Location","Southeast"); xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
%% Moment Curvature
figure(3)
hold on;
fy = 65.9;
ecu = -0.003;
load('AnalysisResults/ConcFib2_SS.txt')
load('AnalysisResults/SteelFib1_SS.txt')
[~, yield] = min(abs(SteelFib1_SS(:,2) - fy));
[~, crush] = min(abs(ConcFib2_SS(:,3) - ecu));
load('AnalysisResults/MK.txt')
plot(MK(:,3),MK(:,1),'LineWidth',1.5,"DisplayName","Moment Curvature"); hold on;
scat_crush = plot(MK(crush,3), MK(crush,1),'ko','MarkerSize',10, 'LineWidth', 1.5);
scat_yeild = plot(MK(yield,3), MK(yield,1),'kd','MarkerSize',10,'LineWidth',1.5);

scat_crush.DisplayName = "Concrete Crushing";
scat_yeild.DisplayName = "Steel Yeilding";

hold on; grid on; box on
grid on; box on; title("Moment Curvature")
ylabel('Moment [kip-in]'); xlabel('Curvature[-]');
legend("Location","Southeast"); xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
% print_figure("Part B Section a3")

%%
figure(5); 
plot(MK(:,3),MK(:,2),'LineWidth',1.5,"DisplayName","Centroid Strain"); 
title(["Axial Strain Reponse","With Axial Load Ratio = 0.1"]); grid on; box on; 
xlabel('Curvature [1/in]'); ylabel('Strain [-]');
%%
clc; close;
figure(4)
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
end
figure(4)
for i = 1:length(K)
    subplot(1,length(K),i)
    set(gca,'yLim',plotYLim)
    xline(0);
end
