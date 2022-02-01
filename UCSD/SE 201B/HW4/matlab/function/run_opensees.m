function run_opensees(filename)
    openseesPath = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\Opensees\bin\OpenSees.exe";

    [filepath,name,ext] = fileparts(filename);
    [filepath,name,ext,openseesPath] = convertStringsToChars(filepath,name,ext,openseesPath);
    currpath = pwd;
    cd(filepath)
    system(['"',openseesPath,'" "' name, ext, '"']);
    cd(currpath);
end