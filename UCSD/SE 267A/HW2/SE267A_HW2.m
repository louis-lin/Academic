%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");
%% Plot Input
figure(1); clf; clc;
nexttile
X = data.Time;
Y = data.RCF6_060_A04;
plot(X, Y )
xlabel("Time [s]")
ylabel("Acceleration [g]")
grid
title("RCF6_060_A04",Interpreter="none")

nexttile
X = data.Time;
Y = data.RCF4_110_A04;
plot(X, Y )
xlabel("Time [s]")
ylabel("Acceleration [g]")
grid
title("RCF4_110_A04",Interpreter="none")
print_figure(1, '.\', "Signals",4)


%% Plot the windowing function
figure(2); clf; clc;
hold on;
t =  -15:0.1:15;

for sigma = [0.2, 1.0 4.0]
    wFunction = sqrt(2/sqrt(2*pi) * sigma) .* exp(-t.^2 /sigma^2);
    plot(t, wFunction,"DisplayName","\sigma = "+sigma,LineWidth=2);
end
title("Considered Gaussian Windows")
xlabel("Time [s]")
% ylabel("$$(\frac{2}{\sqrt{(2*\pi}\sigma}^{0.5})\cdot e^{\frac{-t.^2} {\sigma^2}}$$", Interpreter="latex")
ylabel("w(t)")
legend()
grid on
print_figure(2, '.\', "Windows",2.25)
%% Perform windowning for various sigma into the windowing function
figure(3); clf; clc;
tiledlayout(3,1,"TileSpacing","compact","Padding","compact")

% Get inputs
name = "RCF6_060_A04";
% name = "RCF4_110_A04";
signal = data.(name);
npt = length(signal);
fs = 200;
dt = 1/fs;

% Prepare weighing function 
t =  -10:dt:10; % Time domain windowing length

for sigma = [0.2, 1.0, 4.0] ; % Variance
wFunction = sqrt(2/sqrt(2*pi) * sigma) .* exp(-t.^2 /sigma^2); % weighing function
wNpt = length(wFunction); % length of weighing function

% Calculate the Spectrogram
physical_spectrum = zeros(wNpt, npt); % Spectrogram 
mirroredSignal = [flip(signal); signal; flip(signal)]; % Accounts for the boundary 
for ii = npt+1: 2*npt -1
    weightedF = wFunction' .* mirroredSignal(ii: ii + wNpt-1);
    physical_spectrum(:,ii - npt) = abs(fft(weightedF))./wNpt*2;
end

% Plotting the Results
nexttile()
X = data.Time; % Plot for the entire length of the signal
fps = fs*((1:wNpt)'-1)/wNpt; % Frequency Spectrum Domain (Y-direction)
freqBand = [0, 10]; % Frequency band of interest
idx = (fps >= freqBand(1) & fps <= freqBand(2)); % Plot only relevant portion of spectrogram
Y = fps(idx); % Gets the proper frequencies for plot (SAVES TIME)
mag = physical_spectrum(idx,:); % Gets FFT Magnitude

surf(X,Y,mag,'LineStyle','none','FaceLighting','phong');
view(0,90),colormap('jet'),ylabel('Frequency (Hz)');
xlim([0,90]);ylim(freqBand);title("\sigma = "+sigma);
colorbar;set(gcf,'Position',[50,50,1024,768])
xticks([])
end
xticks()
xlabel('Time (sec)')
sgtitle(["Synthetic Time Series Physical Spectrum",name],fontname="times",Interpreter="none")
% Print Picture
h = findobj('Type','axes');
set(h, 'FontName', 'Times');
set(gcf, 'Position', [8 5 6.5 4.25]*100,"Color",'w' );
print(name,'-djpeg')

%%
figure(4); clf; clc;
hold on;
plot(mirroredSignal);
xticks([]);
xline(npt,'--')
xline(2*npt,'--')
plot(npt+1:2*npt, signal)
ylabel("Acceleration [g]");
print_figure(4, '.\', "Mirrored Signal",2.25)

%%
figure(5); clf; clc;
hold on;

% Get inputs
name = "RCF6_060_A04";
signal = data.(name);
npt = length(signal);
fs = 200;
dt = 1/fs;

% Prepare weighing function 
wNpt = 4096; % I want this many points in the weighin function
t =  -(wNpt/fs/2) - 1:dt: (wNpt/fs/2); % Time domain windowing length

for sigma = [0.2, 1.0, 4.0] % Variance
    wFunction = sqrt(2/sqrt(2*pi) * sigma) .* exp(-t.^2 /sigma^2); % weighing function
    wNpt = length(wFunction); % length of weighing function
    
    % Calculate the Spectrogram
    ii = 6000; % Somewhere in the middle of the signal w/o edge issues
    weightedF = wFunction' .*signal(ii: ii + wNpt-1);
    x = weightedF;
    N = wNpt;
    y = fft(x,N);
    mag = abs(y)* 2/N;
    f = (0:N-1)*fs/N;
    id = (1:N/2); % First half
%     mag = 20*log10(mag);
    plot(f(id), mag(id),"linewidth",2,DisplayName="\sigma = "+ sigma);
end
legend()
grid
xlim([0,10]);
xlabel("Frequncy [Hz]");
ylabel("Power [-]");

print_figure(5, '.\', "Weighed Spectrum",3)

%%

inputFiles = {'SE267A_HW2.pdf','HW2.pdf'};

outputFileName = 'SE267A_HW2_Lin.pdf';
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