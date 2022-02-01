function plotNormBaseShear(figName, folder, direction, legendName)
    arguments; 
        figName = "temp"; 
        folder = "dynamic_EW";
        direction = "EW"
        legendName = ""
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

figure(1); hold on;
if direction =="EW"
    plt = plot(Reaction.time,(Reaction.Fx1+ Reaction.Fx2)/W);
elseif direction =="NS"
    plt = plot(Reaction.time,(Reaction.Fy1+ Reaction.Fy2)/W);
end

if legendName ~= ""; plt.DisplayName = legendName; legend(); end;

title("Total Normalized Base Shear in the " + direction +" Direction"); 
grid on;
xlabel("Time (sec)");
ylabel("Normalized Base Shear [kip/kip]");
h = findobj('Type','line'); set(h,'LineWidth',2);
xlim([0,20]);
print_figure(figName)
end