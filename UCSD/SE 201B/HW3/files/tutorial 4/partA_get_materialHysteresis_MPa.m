%% Define Constitutive Properties
% Steel01
% uniaxialMaterial Steel01 matTag Fy E0 b a1 a2 a3 a4 
Fy = 455.0;
E = 215000;
b = 0.01;
matDef_Steel01 = join(["uniaxialMaterial Steel01 1",Fy, E, b],' ');

% Steel02
% uniaxialMaterial Steel02 matTag Fy E b RO cR1 cR2 a1 a2 a3 a4 
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
matDef_Steel02 = join(["uniaxialMaterial Steel02 1",Fy, E, b, ROm cR1, cR2, a1, a2, a3, a4],' ');

% Concrete01
% uniaxialMaterial Concrete01 matTag fpc epsc0 fpcu epsU   
fpc = -32.5;
epsc0 = -0.0024074074;
fpcu = -6.5;
epsU = -0.004;
matDef_Concrete01 = join(["uniaxialMaterial Concrete01 1",fpc, epsc0, fpcu, epsU],' ');
                               
% Concrete02
% uniaxialMaterial Concrete02 matTag fpc epsc0 fpcu epsU lambda ft Ets   
fpc = -47.9;
epsc0 = -0.003548148;
fpcu = -40.715;
epsU = -0.0276;
lambda = 0.25;
ft = 1.9;
Ets = 2700.0;
matDef_Concrete02 = join(["uniaxialMaterial Concrete02 1",fpc, epsc0, fpcu, epsU, lambda, ft, Ets],' ');

%% Define strain histories
Steel_strain_history = [0, 0.002, -0.002, -0.01, 0.01,-0.02,0.02,-0.03,0.03,-0.04,0.04,-0.05,0.05,-0.06,0];                   
Concrete_strain_history = [0, 0.002, -0.002, -0.01, 0.01,-0.02,0.02,-0.03,0.03,-0.04,0.04,-0.05,0.05,-0.06,0];
% Concrete_strain_history = -[0,0.002, -0.002, 0.01, -0.01, 0.02, -0.02, 0.06, -0.06,0.1,-0.1, 0];
%%
close all; clc;
localOpenSeesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";
i = 1;
numIncr = 1000;
    
%%    
for matDef = [matDef_Steel01, matDef_Steel02]
    inputData = Steel_strain_history;
    figure(i); i = i+1;
    out = get_materialHysteresis(matDef, inputData, numIncr, localOpenSeesPath);
    plot(out(:,1), out(:,2), 'r', 'linewidth', 1.5); grid on; xline(0); yline(0);
    inputs = strsplit(matDef); title(inputs(2));
    ylabel('Stress [MPa]'); xlabel('Strain [-]');
    xlim([-0.07, 0.07]);
    print_figure("Part A Steel" +inputs(2), [6.5, 3.5], 14)
end
%%
for matDef = [matDef_Concrete01, matDef_Concrete02]
    inputData = Concrete_strain_history;
    figure(i); i = i+1;
    out = get_materialHysteresis(matDef, inputData, numIncr, localOpenSeesPath);
    plot(out(:,1), out(:,2), 'r', 'linewidth', 1.5); grid on; xline(0); yline(0);
    inputs = strsplit(matDef); title(inputs(2));
    ylabel('Stress [MPa]'); xlabel('Strain [-]');
    xlim([-0.07, 0.01]);
    print_figure("Part A Concrete"+inputs(2), [6.5, 3.5], 14)
end

function  [ out ] = get_materialHysteresis( matDef, inputData, numIncr, localOpenSeesPath )

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