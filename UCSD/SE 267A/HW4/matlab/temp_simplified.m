%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");

fs = 200;
ts = 1/fs;
maxlag = 2^15;

figure(2); clf;
tiledlayout(2,1);

% Plot the Auto Power Spectrums
for channels = ["RCF2_100_A10","RCF2_100_A04"]
    signal = data.(channels);
    Rxx = xcorr(signal, maxlag, 'unbiased'); % autocorrelation
    Rxx = flip(Rxx(1:maxlag)); % Select only the relevant portion of the spectrum
    Rxx(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
    
    Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
    npt = length(Sxx); 
    fxx = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    
    figure(2); nexttile;
    plot(fxx(id) ,Sxx(id)*2/npt); %
    xlabel ("Frequency (Hz)"); %
    ylabel ('Amplitude'); %
    title('Auto Power Spectrum Density Function',channels,Interpreter='none'); %
    xlim([0,20]);
end

sgtitle("Cross Correlation Method")

%%

figure(3); clf;
tiledlayout(2,1);

for channels = ["RCF2_100_A10","RCF2_100_A04"]
    signal = data.(channels);
    
    npt = length(signal);
    npt = 2^nextpow2(npt);
    X = fft(signal,npt);
    Sxx = X.*conj(X)/npt;
    Sxx = 2*Sxx/npt;
    f = (0:npt-1)*fs/npt;
    id = (1:npt/2); % First half

    figure(3); nexttile;
    plot(f(id), Sxx(id),DisplayName="Finite Fourier Transform Method");
    xlabel ("Frequency (Hz)"); %
    ylabel ('Amplitude'); %
    title('Auto Power Spectrum Density Function',channels,Interpreter='none'); %
    xlim([0,20]);
end

sgtitle("Finite Fourier Transform Method")