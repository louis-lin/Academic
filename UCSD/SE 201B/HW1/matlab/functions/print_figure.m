function print_figure(U, P, U_record, P_record, name, MatData, MatState)
    title(name); hold on; set(gca,'FontSize',18); set(gcf, 'Position',  [0, 0, 1000,700 ]); grid on; grid minor;
    ylim([-400,400])
    xlabel("Horizontal Displacement (in)"); ylabel("Force (Kip)")
    plot(U,P,'b-x',"DisplayName","Push Over Curve","LineWidth",2,"MarkerEdgeColor","red");
    plot(U_record,P_record,'Color','#A2142F',"DisplayName","Unbalance Force Path");   
    [MP_U, MP_Force] = Menegotto_Pinto(U,MatData, MatState);
    a = plot(MP_U , MP_Force,'r','LineWidth',4, "DisplayName"," Menegotto-Pinto Uniaxial Model" ); 
    a.Color(4) = 0.3;  
    legend("Location","southeast",'FontSize',10)
    print("figures\"+strjoin(name),'-dsvg','-PMicrosoft Print to PDF','-r600','-painters')
end
