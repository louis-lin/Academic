clear all; close all; clc;

load 'AnalysisResults/PM_Results.txt';
figure(1)
plot(PM_Results(:,2),PM_Results(:,1),'b-','LineWidth',1.5);
grid on; box on;
xlabel('Moment')
ylabel('Axial load')
title('PM Interaction Diagram')
