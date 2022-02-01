function print_figure(figNum, folder, file_name, height, width, font_size)
arguments
    figNum
    folder = ".\"
    file_name = "temp";
    height = 2.75;
    width = 6.5;
    font_size = 11;
end

% Saves the figures in a consistent manner
figure(figNum);
h = findobj('Type','axes');
set(h, 'FontName', 'Times')
%     set(h,'FontSize',font_size)
set(gcf, 'Position', [8 5 width height]*100,"Color",'w' );

%     orient(gcf,'landscape');
%     folder = ".\figures";
name = '\Figure ' +string(file_name);
print(folder+name,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters')
end