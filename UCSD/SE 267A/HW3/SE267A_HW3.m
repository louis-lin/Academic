clear; clc; 
%%  Problem 3
clear;
[t, acc_base, acc_roof] = readvars("HW3- building seismic response data.txt");

%% Plot the signals
figure(1); clf; clc; hold on;

nexttile
X = t;
Y = acc_base;
plot(X, Y )
xlabel("Time [s]")
ylabel("Acceleration [g]")
grid
title("Base Acceleration",Interpreter="none")

nexttile
X = t;
Y = acc_roof;
plot(X, Y )
xlabel("Time [s]")
ylabel("Acceleration [g]")
grid
title("Roof Acceleration",Interpreter="none")
print_figure(1, '.\', "Signals",4)

%% Auto Correlation Of Roof Acceleration
fs = 200;

figure(2); clf; clc;
maxlag = fs*10;

nexttile
y = acc_base;
[c,lags] = xcorr(y,y,maxlag ,'normalized');
plot(lags, c)
title("Base Acceleration Autocorrelation")
xlabel("Time Lag [\tau]")
grid

nexttile
y = acc_roof;
[c,lags] = xcorr(y,y,maxlag ,'normalized');
plot(lags, c)
title("Roof Acceleration Autocorrelation")
xlabel("Time Lag [\tau]")
grid

print_figure(2, '.\', "AutoCorrelation",4)

%% Cross correlation
fs = 200;
maxlag = fs*5;

figure(3); clf; clc; 
hold on;

y = acc_roof;
[c,lags] = xcorr(acc_base,acc_roof, maxlag ,'normalized');
% [c,lags] = xcorr(acc_roof,acc_base, maxlag ,'normalized');
plot(lags, c)
title("Cross Correlation of Base and Roof Acceleration")
xlabel("Time Lag [\tau]")
grid

[pk, loc] = findpeaks(c,'npeaks',1,'MinPeakHeight',0.3);
text(lags(loc), pk,"\tau = " +abs(lags(loc)),"horizontalalignment","right")
plot(lags(loc), pk,"r.")
print_figure(3, '.\', "Cross Correlation",2.5)

%%
inputFiles = {'SE267A_HW3.pdf','HW3.pdf'};

outputFileName = 'SE267A_HW3_Lin.pdf';
mergePdfs(inputFiles, outputFileName);

function mergePdfs(fileNames, outputFile)
    memSet = org.apache.pdfbox.io.MemoryUsageSetting.setupMainMemoryOnly();
    merger = org.apache.pdfbox.multipdf.PDFMergerUtility;
    cellfun(@(f) merger.addSource(f), fileNames)
    merger.setDestinationFileName(outputFile)
    merger.mergeDocuments(memSet)
end


%%
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