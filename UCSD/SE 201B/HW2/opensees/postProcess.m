close all
modelDataDirPath = './Model';
deflectedShapeDirPath = './DeflectedShape';
nDim = 2;
loadStep = [10:10:100];
defScale = 1;
crdTransfMatrix = eye(2);
figNum = 999;
undefColor = [0.5 0.5 0.5];
undefLineWidth = 1.5;
defColor = 'g';
defLineWidth = 1.5;
% plot_lineModel(modelDataDirPath, nDim, crdTransfMatrix, undefLineWidth, figNum)
% plot_lineDeflectedShape(modelDataDirPath, deflectedShapeDirPath, nDim, loadStep, defScale, crdTransfMatrix, undefColor, undefLineWidth, defColor, defLineWidth, figNum)
% axis off
% grid off