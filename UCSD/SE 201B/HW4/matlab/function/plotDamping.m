function plotDamping(figName, folder, mode)
    arguments; 
        figName = "temp"; 
        folder = "static_EW_force";
        mode = [1, 4];
    end

%     T_pre = load(".\"+folder+"\ModalAnalysis\Pre-gravity\periods.txt");
    T_post = load(".\"+folder+"\ModalAnalysis\Post-gravity\periods.txt");

    wn_post = 2* pi()./T_post;
    alpha_matrix_post = [1/wn_post(mode(1)) wn_post(mode(1))
                    1/wn_post(mode(2)) wn_post(mode(2))];
    alpha_damping_ratio = [0.02; 0.02];

    alphas_post = 2*inv(alpha_matrix_post)*alpha_damping_ratio;
    disp(alphas_post)
    damp_post = @(w) alphas_post(1)/2./w + alphas_post(2)/2*w;
    damping_ratios = damp_post(wn_post);

    w_post = linspace(0,60,100);
    d_post = damp_post(w_post);

    figure(1)
    hold on
    plot(w_post,d_post)
    
    for i = 1:6
%             wn_post(i)
            damping_ratios(i)
            plt = plot(wn_post(i),damping_ratios(i),"o");
            datatip(plt, 'DataIndex', i);  
%             plt.DataTipTemplate.DataTipRows(1).Label = "\omega_" +i;
%             plt.DataTipTemplate.DataTipRows(1).Value = "";
%             plt.DataTipTemplate.DataTipRows(2) = [];   
    end

%     ylim([0,0.05]);
    xlim([0,61]);
    h = findobj('Type','line'); set(h,'LineWidth',2,'MarkerSize',2,'MarkerFaceColor','none');
    grid on; grid minor;
    xlabel("Frequency (\omega)")
    ylabel("Damping Ratio (\zeta)")
    title("Rayleigh Damping Ratio")
end