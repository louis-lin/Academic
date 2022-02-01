function plotRecord(record)

data = load(record);  % Loads in time and acceleration
iter = data(1); 
du = data(2);
time = (du:du:iter*du);
acc= data(3:iter+2);
A = acc;
[~, idx] = min(max(abs(A))-abs(A));
plot(time(idx),A(idx),'ro','MarkerFaceColor','r','HandleVisibility','off')
text(time(idx),A(idx),sprintf('  A_{abs, max} = %1.3fg',abs(A(idx))),'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',12,'FontWeight','Bold');

plot(time,acc); grid on;
title(record); xlabel("Time [sec]");ylabel("Acceleration [g]");
print_figure("temp",[6.5, 2.25])
end