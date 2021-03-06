close all; clc;
% Steel01
% uniaxialMaterial Steel01 matTag Fy E0 b a1 a2 a3 a4 
% Fy = 68.0;
% E = 29000.0;
% b = 0.01;

% Fy = 455.0;
% E = 215000;
% b = 0.01;
% matDef = join(["uniaxialMaterial Steel01 1",Fy, E, b],' ');

% Steel02
% uniaxialMaterial Steel02 matTag Fy E b RO cR1 cR2 a1 a2 a3 a4 
% Fy = 68.0;
% E = 29000.0;
Fy = 455.0;
E = 215000;
b = 0.01;

ROm = 20.0;
cR1 = 0.925;
cR2 = 0.15;
a1 = 0;
a2 = 1;
a3 = 0;
a4 = 1;

matDef = join(["uniaxialMaterial Steel02 1",Fy, E, b, ROm cR1, cR2, a1, a2, a3, a4],' ');
Steel_strain_history = -[0:-0.001:-0.01,...
                                    -0.0099:0.001:0.01,...
                                    0.0099:-0.001:-0.02,...
                                    -0.0199:0.001:0.02,...
                                    0.0199:-0.001:-0.03,...
                                    -0.0299:0.001:0.03,...
                                    0.0299:-0.001:-0.04,...
                                    -0.0399:0.001:0.04,...
                                    0.0399:-0.001:-0.05,...
                                    -0.0499:0.001:0.05,...
                                    0.0499:-0.001:-0.06,0];


% Concrete01
% uniaxialMaterial Concrete01 matTag fpc epsc0 fpcu epsU   
% fpc = -32.5;
% epsc0 = -0.0024074074;
% fpcu = -6.5;
% epsU = -0.004;
% matDef = join(["uniaxialMaterial Concrete01 1",fpc, epsc0, fpcu, epsU],' ');
% Concrete_strain_history = [0:-0.001:-0.01,...
%                                     -0.0099:0.001:0.01,...
%                                     0.0099:-0.001:-0.02,...
%                                     -0.0199:0.001:0.02,...
%                                     0.0199:-0.001:-0.03,...
%                                     -0.0299:0.001:0.03,...
%                                     0.0299:-0.001:-0.04];
                                
% Concrete02
% uniaxialMaterial Concrete02 matTag fpc epsc0 fpcu epsU lambda ft Ets   
% fpc = -6.9473076373;
% epsc0 = -0.003548148;
% fpcu = -5.9052114917;
% epsU = -0.0276;
% lambda = 0.25;
% ft = 0.2755717017;
% Ets = 391.6018918716;
% 
% fpc = -47.9;
% epsc0 = -0.003548148;
% fpcu = -40.715;
% epsU = -0.0276;
% lambda = 0.25;
% ft = 1.9;
% Ets = 2700.0;
% matDef = join(["uniaxialMaterial Concrete02 1",fpc, epsc0, fpcu, epsU, lambda, ft, Ets],' ');
% Concrete_strain_history = -[0:-0.001:-0.01,...
%                                     -0.0099:0.001:0.01,...
%                                     0.0099:-0.001:-0.02,...
%                                     -0.0199:0.001:0.02,...
%                                     0.0199:-0.001:-0.03,...
%                                     -0.0299:0.001:0.03,...
%                                     0.0299:-0.001:-0.04,...
%                                     -0.0399:0.001:0.04,...
%                                     0.0399:-0.001:-0.05,...
%                                     -0.0499:0.001:0.05,...
%                                     0.0499:-0.001:-0.06];

% inputData = Concrete_strain_history;
inputData = Steel_strain_history;
% inputData = [0, 0.002, -0.002, 0.01, -0.01, 0.02, -0.02, 0.06, -0.06, 0];
% inputData = [0, 0.001, -0.001,  0.003, -0.003, 0.005, -0.005, 0.01, -0.01, 0.02, -0.02, 0.06, -0.06, 0];
numIncr = 100;
localOpenSeesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";

figure();
out = get_materialHysteresis(matDef, inputData, numIncr, localOpenSeesPath);
plot(out(:,1), out(:,2), 'k', 'linewidth', 1.5); grid on;
xline(0);
yline(0);
% set(gca,'xlim',[-0.06, 0.01])
% set(gca,'ylim',[-40, 10])
inputs = strsplit(matDef);
title(inputs(2));
ylabel('Stress [MPa]'); xlabel('Strain');



function  [ out ] = get_materialHysteresis( matDef, inputData, numIncr, localOpenSeesPath )
% SE 201B 
% Material tester for OpenSees
% Angshuman Deb
%% INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matDef              : material definition string from OpenSees
% inputData           : a vector of input deformation/strain time history
% numIncr             : num of points to include between inputData(i) and inputData(i+1)
% localOpenSeesPath   : full path to OpenSees executable

% OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% out                 : [deformation force] or [strain stress]

%% Function
[matDef, localOpenSeesPath] = convertStringsToChars(matDef, localOpenSeesPath);
inputData = arrayfun(@(x) num2str(x), inputData, 'UniformOutput', 0);
temp = strsplit(matDef);
matTag = temp{3};

materialTesterFid = fopen('matTest.tcl','w+');
fprintf(materialTesterFid,['wipe;\n']);
fprintf(materialTesterFid,['model testUniaxial;\n']);
fprintf(materialTesterFid,['set matTag ', num2str(matTag,'%u'), ';\n']);
fprintf(materialTesterFid,['set strainHistory {', strjoin(inputData), '};\n']);
fprintf(materialTesterFid,['set fileOut "hysteresis_matTag_$matTag.txt";\n']);
fprintf(materialTesterFid,['set out [open $fileOut w];\n']);
fprintf(materialTesterFid,[matDef '\n']);
fprintf(materialTesterFid,...
    ['uniaxialTest $matTag;\n',...
    'set strain 0.0;\n',...
    'set count 1;\n',...
    'set iTime 0;\n',...
    'set strain [expr $strain];\n',...
    'strainUniaxialTest $strain;\n',...
    'set stress [stressUniaxialTest];\n',...
    'set tangent [tangUniaxialTest];\n',...
    'set iTime [expr $iTime+1];\n',...
    'puts $out "$strain $stress";\n',...
    'foreach {strainExtremeVal} $strainHistory {\n',...
    '		set numIncr ' num2str(numIncr,'%u') ';\n',...
    '		set strainIncr [expr ($strainExtremeVal - $strain)/$numIncr];\n',...
    '		for {set i 0} {$i < $numIncr} {incr i 1} {\n',...
    '			set strain [expr $strain+$strainIncr];\n',...
    '			strainUniaxialTest $strain;\n',...
    '			set stress [stressUniaxialTest];\n',...
    '			set tangent [tangUniaxialTest];\n',...
    '			set iTime [expr $iTime+1];\n',...
    '			puts $out "$strain $stress";\n',...
    '		}\n',...
    '}\n',...
    'close $out;\n',...
    'puts "MATERIAL TESTER RAN SUCCESSFULLY!";\n',...
    'wipe;\n'...
    ]);
fclose(materialTesterFid);

[~, ~] = system(['"',localOpenSeesPath,'" "matTest.tcl"']);

fid = fopen(['hysteresis_matTag_' num2str(matTag,'%u') '.txt'],'r');
dataRead = textscan(fid, repmat('%f ',1,2), 'CollectOutput',true);
out = dataRead{1};
fclose(fid);
delete(['hysteresis_matTag_' num2str(matTag,'%u') '.txt']);
delete('matTest.tcl');

end