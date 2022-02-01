function [ fig, undefPlot, defPlot, sc] = Plot_ANY_Deflected_Shape(U_glob, scale, ID, XY, lsPlot, undefColor, undefLineWidth, defColor, defLineWidth, figNum, name)
%% Plot Deflected Shape for ANY 2-D Frame Structure
% Angshuman Deb
% Please read the document 'Plotting_Deflected_Shapes_README.pdf' before
% using this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nlsPlot = length(lsPlot);
ndf = size(ID,1);
n_ele = size(ID,2);
U_ele = zeros(ndf,nlsPlot,n_ele);

for ls = 1:nlsPlot
    for i = 1:n_ele
        for m = 1:ndf
            if ID(m,i) ~= 0
                U_ele(m,ls,i) = scale*U_glob(ID(m,i),lsPlot(ls));
            end
        end
    end
end

fig = figure(figNum); 

hold on;
grid on;
box on;
% Undeformed Shape
for i = 1:n_ele
    undefPlot = ...
        plot([XY(i,1) XY(i,3)], [XY(i,2) XY(i,4)], 'LineStyle' ,'--',...
        'LineWidth', undefLineWidth, 'Color', undefColor,'HandleVisibility','off');
end
% Deformed Shape
for ls = 1:nlsPlot
    figure(figNum)
    for i = 1:n_ele
        sc = scatter([XY(i,1)+U_ele(1,ls,i) XY(i,3)+U_ele(4,ls,i)],...
            [XY(i,2)+U_ele(2,ls,i) XY(i,4)+U_ele(5,ls,i)],...
            'ks','MarkerFaceColor',[0.5 0.5 0.5],'HandleVisibility','off');
        defPlot = ...
            plot([XY(i,1)+U_ele(1,ls,i) XY(i,3)+U_ele(4,ls,i)],...
            [XY(i,2)+U_ele(2,ls,i) XY(i,4)+U_ele(5,ls,i)],...
            'LineStyle', '-', 'LineWidth', defLineWidth, 'Color', defColor,'HandleVisibility','off');
%         defPlot.Color(4) = 0.4;
    end
end
axis equal
defPlot.HandleVisibility ='on';
defPlot.DisplayName = name;
legend();
end