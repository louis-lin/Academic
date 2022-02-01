%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");

fs = 200;

%% Plot the Auto Power Spectrum Desntiy Function

figure(1); clf; tiledlayout(1,2);
ii = 1;

for channels = ["RCF2_100_A10","RCF2_100_A04"]
    figure(1); nexttile(ii); hold on;  ii = ii+1;
    signal = data.(channels);

    % Auto Correlation Function Method
    maxlag = 2^10;
    Rxx = xcorr(signal, maxlag, 'unbiased'); % autocorrelation
    Rxx = flip(Rxx(1:maxlag)); % Select only the relevant portion of the spectrum
    Rxx(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
%         Rxx(maxlag/2:2^15) = 0; % Increase frequency resolution while also trimming unreliable data
    Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
    npt = length(Sxx);
    fxx = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxx(id) ,Sxx(id)*2/npt, DisplayName=["Auto Correlation Method N="+npt], LineWidth=2); %

    % Finite Fourier Transformation Method
%     yyaxis right
    npt = length(signal);
    npt = 2^nextpow2(npt);
    X = fft(signal,npt);
    Sxx = X.*conj(X)/npt;
    Sxx = Sxx/maxlag;
    f = (0:npt-1)*fs/npt;
    id = (1:npt/2); % First half
    plot(f(id), Sxx(id),DisplayName="Finite Fourier Transform Method  N="+npt);
    xlabel ("Frequency (Hz)"); %
    ylabel ('Amplitude'); %
    title('Auto Power Spectrum Density Function',channels,Interpreter='none'); %
    xlim([0,10]);
    legend(Location="southoutside")
end

%% Cross Power Spectrum Density Function

% Plot the Auto Power Spectrums
figure(2); clf;  hold on;
x = data.RCF2_100_A10;
y = data.RCF2_100_A04;

% Auto Correlation Function Method
maxlag = 2^10;
Rxy = xcorr(x, y, maxlag, 'unbiased'); % autocorrelation
Rxy = flip(Rxy(1:maxlag)); % Select only the relevant portion of the spectrum
Rxy(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
Sxy = abs(fft(Rxy)); % FFT to obtain auto-spectrum
npt = length(Sxy);
fxy = (0:npt-1)* fs /npt; %
id = (1:npt/2);
plot(fxy(id) ,Sxy(id)*2/npt, DisplayName="Auto Correlation Method"); %

% Finite Fourier Transformation Method
npt = length(x);
npt = 2^nextpow2(npt);
X = fft(x,npt);
Y = fft(y,npt);
Sxy = abs(Y.*conj(X));
Sxy = Sxy/npt;
Sxy = Sxy/maxlag;
f = (0:npt-1)*fs/npt;
id = (1:npt/2); % First half
plot(f(id), Sxy(id),DisplayName="Finite Fourier Transform Method");

xlabel ("Frequency (Hz)"); %
ylabel ('Amplitude'); %
title('Cross Power Spectrum Density Function',Interpreter='none'); %
xlim([0,10]);
legend()