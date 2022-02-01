function print_figure(file_name, size, font_size)
    arguments
        file_name = "temp";
        size = [6.5, 2.75] ;
        font_size = 11;
    end
    
    % Saves the figures in a consistent manner
    h = findobj('Type','axes');
    set(h, 'FontName', 'Times','FontSize',font_size)
    set(gcf, 'Position', [800 500 size*100]);
    
    orient(gcf,'landscape');
    folder = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW4\figures";
    name = '\Figure ' +string(file_name);
    print(folder+name,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters')
end