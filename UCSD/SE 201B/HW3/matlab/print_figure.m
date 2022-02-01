function print_figure(file_name, size, axes_font_size)
    arguments
        file_name = "temp";
        size = [6.5, 2.75];
        axes_font_size = 12;
    end
    
    % Saves the figures in a consistent manner
    set(gcf, 'Position',  [0, 0, size*100])
    set(gca,'FontSize',axes_font_size);
    orient(gcf,'landscape');
    box on;
    folder = "C:\Users\Louis Lin\Workspace\Academic\UCSD\SE 201B\HW\HW3\figures";
    name = '\Figure ' +string(file_name);
%     print(folder+name,'-dpdf','-fillpage','-PMicrosoft Print to PDF','-r600','-painters')
    print(folder+name,'-dsvg','-PMicrosoft Print to PDF','-r600','-painters')
end