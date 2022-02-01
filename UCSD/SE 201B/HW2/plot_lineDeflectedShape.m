function [ fig, undefPlot, defPlot ] = plot_lineDeflectedShape(modelDataDirPath, deflectedShapeDirPath, nDim, loadStep, defScale, crdTransfMatrix, undefColor, undefLineWidth, defColor, defLineWidth, figNum)
%% DESCRIPTION

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modelDataDirPath         : full path to folder containing modelData.txt
%                            (see note)
% deflectedShapeDirPath    : full path to directory containing
%                            dispNode_$nodeTag.txt files (see note)
% nDim                     : number of dimensions (2 or 3)
% loadStep                 : vector of loadStep numbers for plotting
% defScale                 : scale factor for deflected shape
% crdTransfMatrix          : coordinate transformation matrix (see note)
% undefColor               : color for undeformed shape
% undefLineWidth           : line width for undeformed shape
% defColor                 : color for deformed shape
% defLineWidth             : line width for deformed shape
% figNum                   : Matlab figure number
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note about modelData.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For using this plotter, generate a text output 'modelData.txt' of
% your model as you write the .tcl input file. This text output should at
% least have all the nodal and element information. As you go on adding
% nodes and elements in the .tcl input file, it is required to write the
% command lines for adding nodes and elements to the text file
% 'modelData.txt'.
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note about dispNode_$nodeTag.txt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save dispNode_$nodeTag.txt for all nodes in the model. These files should
% have columns 1 and 2 as X and Y displacements of all nodes for nDim = 2.
% They should have columns 1, 2 and 3 as X, Y and Z displacements of all
% nodes for nDim = 3.
%--------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note about crdTransfMatrix (= R):
% m: MATLAB
% o: OpenSees
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [oX;oY;oZ] = R*[mX;mY;mZ]
% [mX;mY;mZ] = R'*[oX;oY;oZ]
% Assume (mX, mY, mZ) as basis
% 1st row of R = oX in (mX, mY, mZ)
% 2nd row of R = oY in (mX, mY, mZ)
% 3rd row of R = oZ in (mX, mY, mZ)
%--------------------------------------------------------------------------
%% READ MODEL DATA

if ~ismember(nDim,[2,3])
    error('Incorrect dimension! Should be 2 or 3.')
end

modelDataFile_fid = fopen(fullfile(modelDataDirPath,'modelData.txt'),'r');
str = textscan(modelDataFile_fid,'%s');
nodeCount = sum(ismember(str{:},'node'));
eleCount = sum(ismember(str{:},'element')) + sum(ismember(str{:},'rigidLink'));
nodeData = zeros(nodeCount, nDim + 1);
eleData = zeros(eleCount, 3);
eleTypes = cell(eleCount, 1);
nodeCtr = 0;
eleCtr = 0;
frewind(modelDataFile_fid);

while ~feof(modelDataFile_fid)
    currLine = fgetl(modelDataFile_fid);
    currLine = strtrim(strtok(currLine,';'));
    currLine = strsplit(currLine);
    
    if size(currLine,2) > 1 && strcmp(currLine{1},'node') == 1
        nodeCtr = nodeCtr + 1;
        nodeNum = str2double(currLine{2});
        coordinates = arrayfun(@(x) str2double(currLine{x}), 3:length(currLine), 'UniformOutput', 1);
        nodeData(nodeCtr,:) = [nodeNum coordinates];
    end
    
    if (size(currLine,2) > 1 && strcmp(currLine{1},'element') == 1) || (size(currLine,2) > 1 && strcmp(currLine{1},'rigidLink') == 1)
        eleCtr = eleCtr + 1;
        if strcmp(currLine{1},'rigidLink') == 1
            eleNum = 0;
            connectingNodes = [str2double(currLine{4}),str2double(currLine{3})];
            eleType = currLine{1};
        else
            eleNum = str2double(currLine{3});
            connectingNodes = [str2double(currLine{4}),str2double(currLine{5})];
            eleType = currLine{2};
        end
        eleData(eleCtr,:) = [eleNum connectingNodes];
        eleTypes{eleCtr} = eleType;
    end
end
fclose(modelDataFile_fid);

nodeData(:,2:size(nodeData,2)) = (crdTransfMatrix'*nodeData(:,2:size(nodeData,2))')';

%% PLOT UNDEFORMED SHAPE
fig = figure(figNum);
axis equal
hold on
grid on
box on
[~,element_iNode] = ismember(eleData(:,2),nodeData(:,1));
[~,element_jNode] = ismember(eleData(:,3),nodeData(:,1));

if nDim == 3
    for i = 1:size(eleData,1)
        undefPlot = ...
            plot3([nodeData(element_iNode(i),2) nodeData(element_jNode(i),2)],...
            [nodeData(element_iNode(i),3) nodeData(element_jNode(i),3)],...
            [nodeData(element_iNode(i),4) nodeData(element_jNode(i),4)],...
            '--','Color',undefColor,'LineWidth',undefLineWidth,'HandleVisibility','off');hold on
    end
elseif nDim == 2
    for i = 1:size(eleData,1)
        undefPlot = ...
            plot([nodeData(element_iNode(i),2) nodeData(element_jNode(i),2)],...
            [nodeData(element_iNode(i),3) nodeData(element_jNode(i),3)],...
            '--','Color',undefColor,'LineWidth',undefLineWidth,'HandleVisibility','off');hold on
    end
end

%% PLOT DEFORMED SHAPE
for i_ls = 1:length(loadStep)
    %% READ DEFLECTED SHAPE INFORMATION
    nodeDataDeformed = zeros(size(nodeData));
    for i = 1:size(nodeData,1)
        dispNode = load(fullfile(deflectedShapeDirPath,['dispNode_' num2str(nodeData(i,1)) '.txt']));
        dispNode = defScale*dispNode(loadStep(i_ls), :);
        dispNode = (crdTransfMatrix' * dispNode')';
        nodeDataDeformed(i,:) = [nodeData(i,1), nodeData(i,2:size(nodeData,2))+dispNode];
    end
    %% PLOT DEFLECTED SHAPE
    figure(figNum)
    if nDim == 3
        for i = 1:size(eleData,1)
            defPlot = ...
                plot3([nodeDataDeformed(element_iNode(i),2) nodeDataDeformed(element_jNode(i),2)],...
                [nodeDataDeformed(element_iNode(i),3) nodeDataDeformed(element_jNode(i),3)],...
                [nodeDataDeformed(element_iNode(i),4) nodeDataDeformed(element_jNode(i),4)],...
                'LineStyle','-','Color',defColor,'LineWidth',defLineWidth,'HandleVisibility','off');
        end
        plot3(nodeDataDeformed(:,2),nodeDataDeformed(:,3),nodeDataDeformed(:,4),'ks','LineWidth',1,'MarkerFaceColor',[0.5 0.5 0.5])
    elseif nDim == 2
        for i = 1:size(eleData,1)
            defPlot = ...
                plot([nodeDataDeformed(element_iNode(i),2) nodeDataDeformed(element_jNode(i),2)],...
                [nodeDataDeformed(element_iNode(i),3) nodeDataDeformed(element_jNode(i),3)],...
                'LineStyle','-','Color',defColor,'LineWidth',defLineWidth,'HandleVisibility','off');
        end
        plot(nodeDataDeformed(:,2),nodeDataDeformed(:,3),'ks','LineWidth',1,'MarkerFaceColor',[0.5 0.5 0.5],'HandleVisibility','off')
    end
end

end