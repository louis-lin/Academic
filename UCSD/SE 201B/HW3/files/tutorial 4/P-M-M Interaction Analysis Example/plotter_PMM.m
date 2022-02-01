clear all; close all; clc;
 
name='AnalysisResults/PM';

numFiles = 21;
for iFile = 1:numFiles
    fileLoad = [name num2str(iFile) '.txt'];
    mp{iFile} = load(fileLoad);
end

figure(1)
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
xlabel('Moment My')
ylabel('Moment Mz')
zlabel('Axial Load')
view([120 15]);
