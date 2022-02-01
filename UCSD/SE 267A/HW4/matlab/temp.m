%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");

x = data.RCF2_100_A10;
y = data.RCF2_100_A04;

fs = 200;
ts = 1/fs;
cor_1 = 1024;

% input (x) auto-spectrum density function
figure(1);clf;
tiledlayout(4,1)
nexttile
Rxx = xcorr(x,cor_1, 'unbiased'); % autocorrelation
plot(Rxx);

nexttile
pt = round ( (size (Rxx,1)/2));
Rxx = Rxx(1:pt); %select only half of data
plot(Rxx);

nexttile
Rxx = Rxx(end:-1:1); % reverse data
pt = round((size(Rxx,1)/2)); %
plot(Rxx);

nexttile
Rxx = Rxx(1:pt); % select only half of data
plot(Rxx);

figure(2); clf;
Sxx = abs (fft(Rxx)); % FFT to obtain auto-spectrum
fxx = (0:pt-1)* fs /pt; %
% subplot (3, 1,1); %
plot(fxx(1:pt/2) ,Sxx(1:pt/2)*2/pt); %
xlabel ("Frequency (Hz)"); %
ylabel ('Amplitude'); %
title('via Correlation Function','\bf Auto-spectrum Density Function (Sxx)'); %
xlim([0,20]);
legend