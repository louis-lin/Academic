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
    load('AnalysisResults/MK.txt')
    plot(MK(:,3),MK(:,1),'LineWidth',1.5,"DisplayName","Axial Load Ratio: " + sprintf('%1.1f',axial_Load)); hold on;
    grid on; box on; title("Moment Curvature")
    ylabel('Moment [kip-in]'); xlabel('Curvature[-]');
    legend("Location","Southeast",'FontSize',12); xline(0,"HandleVisibility",'off'); yline(0,"HandleVisibility",'off');
    print_figure("Part F i Cyclic Moment Curvature"+ num2str(axial_Load*10,'%i'),[13,5],18)
    close(3)
    
    figure(4); 
    plot(MK(:,3),MK(:,2),'LineWidth',1.5,"DisplayName","Centroid Strain"); 
    title(["Axial Strain Reponse","With Axial Load Ratio = "+ num2str(axial_Load,'%1.1f')] ); grid on; box on; 
    xlabel('Curvature [1/in]'); ylabel('Strain [-]');
    print_figure("Part F ii Axial Strain Axial Load Ratio "+ num2str(axial_Load*10,'%i') ,[5,5])
    close(4)
end
