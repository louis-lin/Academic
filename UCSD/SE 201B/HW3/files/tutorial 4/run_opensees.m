clc;
filename = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\tutorial\tutorial 4\P-M-M Interaction Analysis Example\run.tcl"
openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";


[filepath,name,ext] = fileparts(filename);
[filepath,name,ext,openseesPath] = convertStringsToChars(filepath,name,ext,openseesPath);
currpath = pwd;
cd(filepath)
system(['"',openseesPath,'" "' name, ext, '"']);
cd(currpath);