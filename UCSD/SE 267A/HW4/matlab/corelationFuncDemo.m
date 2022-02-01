%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");

fs = 200;
ts = 1/fs;

%% Plot the Auto Power Spectrum Desntiy Function

figure(1); clf;
tiledlayout(4,2,Padding="compact",TileSpacing="compact");
ii = 1;

for channels = "RCF2_100_A10"
    signal = data.(channels);

    % Auto Correlation Function Method
    nexttile()
    maxlag = 2^10;
    Rxx = xcorr(signal, maxlag, 'unbiased'); % autocorrelation
    Rxx = flip(Rxx(1:maxlag)); % Select only the relevant portion of the spectrum
    plot(Rxx)
    ylabel("N=2^{10}=1024")
    title("Autocorrelation Function")

    nexttile()
    Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
    npt = length(Sxx);
    fxx = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxx(id) ,Sxx(id)*2/npt); %
    xlim([0,10])
    title("FFT of Autocorrelation Function")

    nexttile()
    Rxx(maxlag/2:end) = 0;
    plot(Rxx)
    xline(2^9,"--")
    ylabel("N=2^{10}=1024")

    nexttile()
    Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
    npt = length(Sxx);
    fxx = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxx(id) ,Sxx(id)*2/npt); %
    xlim([0,10])


    maxlag = 2^15;
    Rxx = xcorr(signal, maxlag, 'unbiased'); % autocorrelation
    Rxx = flip(Rxx(1:maxlag)); % Select only the relevant portion of the spectrum
    nexttile()
    plot(Rxx)
    ylabel("N=2^{15}=32768")

    nexttile()
    Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
    npt = length(Sxx);
    fxx = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxx(id) ,Sxx(id)*2/npt); %
    xlim([0,10])


    nexttile()
    Rxx(maxlag/2:end) = 0;
    plot(Rxx)
    xline(2^14,"--")
    ylabel("N=2^{15}=32768")

    nexttile()
    Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
    npt = length(Sxx);
    fxx = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxx(id) ,Sxx(id)*2/npt); %
    xlim([0,10])
end

print_figure(1,"./","Correlation Functions",5,6.5)

