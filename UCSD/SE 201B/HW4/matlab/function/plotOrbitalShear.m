function plotOrbitalShear(figName, folder)
    arguments; 
        figName = "temp"; 
        folder = "dynamic_EW";
    end
    
filename = ".\" +folder+"\Results_dynamic\Reaction.txt";
dataLines = [1, Inf];
opts = delimitedTextImportOptions("NumVariables", 13);
opts.DataLines = dataLines;
opts.Delimiter = " ";
opts.VariableNames = ["time", "Fx1", "Fy1", "Fz1", "Mx1", "My1", "Mz1", "Fx2", "Fy2", "Fz2", "Mx2", "My2", "Mz2"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
Reaction = readtable(filename, opts);

W = 21365;
plot((Reaction.Fx1+ Reaction.Fx2)/W,(Reaction.Fy1+ Reaction.Fy2)/W);

title("Total Normalized Base Shear"); 
grid on;
xlabel("EW Normalized Base Shear [kip/kip]");
ylabel("NS Normalized Base Shear [kip/kip]");
h = findobj('Type','line'); set(h,'LineWidth',2);
print_figure(figName)
end