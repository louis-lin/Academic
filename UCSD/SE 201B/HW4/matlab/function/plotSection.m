function plotSection(figName, folder, secTag, size)
arguments
    figName = "temp"
    folder = "static_EW_force"
    secTag = 1;
    size = [3.25,2.5];
end

secDefFilePath = folder +"/Model/modelData.txt";
grid off;
figNum = 1;

fibColor = [1 0 0.85 0.5 0.5; 
                2 1 0 0 0.5;
                3 .75 .75 .75 0.5
                4 0 0 1 0.5
                5 .0 0 1 0.5];
plotFiberSection(secDefFilePath, secTag, figNum, fibColor)
camroll(90)
title(figName);
ylabel('Y [in]');
zlabel('X [in]');
print_figure(figName,size)
end