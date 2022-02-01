function plotModeShapeAll(folder)
    modelDefFilePath = ".\"+folder+"\Model";
    modeShapeDirPath = ".\"+folder+"\ModalAnalysis\Pre-gravity\";
for i = 1:6
    mode = i;
    scale = 500;
    nDim = 3;
    loadStep = 2;
    defScale = 10;
    crdTransfMatrix = eye(3); 
    undefColor = 'b';
    undefLineWidth = 1.5; 
    defColor = 'r';
    defLineWidth = 1.5; 
    figNum = i;
    plotModeShape(modelDefFilePath, modeShapeDirPath, mode, scale, nDim, crdTransfMatrix, undefColor, undefLineWidth, defColor, defLineWidth, figNum);
    grid off;
    h = findobj('Type','line'); set(h,'LineWidth',1,'MarkerSize',1,'MarkerFaceColor','none');
    
    xlabel("EW");
    ylabel("NS");
    title("Mode " +i);
    
    set(gca,'xtick',[],'ytick',[],'ztick',[])
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[])
    
%     view(30,45)
%     print_figure("Mode "+i + " 3D View",[2,4]);

%     axis([-200 500 -200 500 0 2400])
%     view(0,0)
%     print_figure("Mode "+i+ " EW View",[2,4]);
    axis([-200 500 -400 300 0 2400])
    print_figure("Mode "+i+ " Top View",[2,2]);
end