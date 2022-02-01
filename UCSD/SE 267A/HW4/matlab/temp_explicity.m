%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");

signal.x = data.RCF2_100_A10;
signal.y = data.RCF2_100_A04;

fs = 200;
ts = 1/fs;

% input (x) auto-spectrum density function
maxlag = 1024;

Rxx = xcorr(x, maxlag, 'unbiased'); % autocorrelation
Rxx = flip(Rxx(1:maxlag));
Rxx(maxlag/2:end) = 0;

Ryy = xcorr(y, maxlag, 'unbiased'); % autocorrelation
Ryy = flip(Ryy(1:maxlag));
Ryy(maxlag/2:end) = 0;


figure(2); clf;
tiledlayout(2,1);
Sxx = abs (fft(Rxx)); % FFT to obtain auto-spectrum
npt = length(Sxx); 
fxx = (0:npt-1)* fs /npt; %
id = (1:npt/2);

nexttile;
plot(fxx(id) ,Sxx(id)*2/npt); %
xlabel ("Frequency (Hz)"); %
ylabel ('Amplitude'); %
title('\bf Auto Power Spectrum Density Function (Sxx)'); %
xlim([0,20]);
legend


Syy = abs (fft(Ryy)); % FFT to obtain auto-spectrum
npt = length(Syy); 
fyy = (0:npt-1)* fs /npt; %
id = (1:npt/2);

nexttile;
plot(fyy(id) ,Syy(id)*2/npt); %
xlabel ("Frequency (Hz)"); %
ylabel ('Amplitude'); %
title('\bf Auto Power Spectrum Density Function (Syy)'); %
xlim([0,20]);
legend