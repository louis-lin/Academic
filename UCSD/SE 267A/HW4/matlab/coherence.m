%% Load Data
clear; clc;
data = readtable("Homework-2 data set-RCF-Four Specimen Test Data.xlsx");
x = data.RCF2_100_A10;
y = data.RCF2_100_A04;

fs = 200;

figure(1); clf; 
tiledlayout(1,2,"TileSpacing","compact",Padding="compact")
% Auto Correlation Function Method
nexttile(); hold on;
maxlag = 2^12;

% Autocorrelation of input
Rxx = xcorr(x, maxlag, 'unbiased'); % autocorrelation
Rxx = flip(Rxx(1:maxlag)); % Select only the relevant portion of the spectrum
Rxx(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
Sxx = abs(fft(Rxx)); % FFT to obtain auto-spectrum
% Autocorrelation of output
Ryy = xcorr(y, maxlag, 'unbiased'); % autocorrelation
Ryy = flip(Ryy(1:maxlag)); % Select only the relevant portion of the spectrum
Ryy(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
Syy = abs(fft(Ryy)); % FFT to obtain auto-spectrum
% Finding Cross Spectrum
[Rxy] = xcorr(x, y,maxlag, "unbiased");
[Ryx] = xcorr(y,x, maxlag, 'unbiased');
Rxy = flip(Rxy(1:maxlag)); % select only half of data
Ryx = flip(Ryx(1:maxlag)); %select only half of data

Rxy(maxlag/2:end) = 0; % zeros out the unreliable data
Ryx(maxlag/2:end) = 0; %select only half of data

lxy = 0.5* (Rxy+Ryx); % Co-Correlation
qxy = 0.5* (Rxy-Ryx); % Quadra-Correlation

Lxy = real(fft(lxy)); %Co-Spectrum
Qxy = imag(fft(qxy)); % Quadra-Spectrum
Sxy = Lxy-Qxy*1i; % Cross Spectrum
%     
% Rxy = xcorr(x, y, maxlag, 'unbiased'); % autocorrelation
% Rxy = flip(Rxy(1:maxlag)); % Select only the relevant portion of the spectrum
% Rxy(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
% Sxy = abs(fft(Rxy)); % FFT to obtain auto-spectrum

npt = length(Sxy);
fxy = (0:npt-1)* fs /npt; %
id = (1:npt/2);
plot(fxy(id) , abs(Sxy(id))*2/npt, DisplayName="CPSD "); %

ylabel ('Amplitude'); 
yyaxis right
gamma = abs(Sxy).^2./(Sxx.*Syy);
% % gamma(1)=1;
plot(fxy(id), gamma(id), DisplayName="Coherence"); %
xlabel ("Frequency (Hz)"); %
title('Auto Correlation Method',Interpreter='none'); %
ylim([0,1] * 1)
legend()
% yline(1,"--","Theoretical Limit","HandleVisibility","off")
xlim([0,10])
legend(Location="northeast")

%%

nexttile()
npt = 2^nextpow2(length(x));
X = fft(x,npt);
Sxx = X.*conj(X)/npt/maxlag;

npt = 2^nextpow2(length(y));
Y = fft(y,npt);
Syy = Y.*conj(Y)/npt/maxlag;

Sxy = abs(Y.*conj(X));
Sxy = Sxy/npt/maxlag;

id = (1:npt/2); % First half
f = (0:npt-1)*fs/npt;
plot(f(id), Sxy(id),DisplayName="CPSD");
ylim([0,1] * 0.0015)
xlabel ("Frequency (Hz)"); %
ylabel ('Amplitude'); %

yyaxis right
gamma = Sxy.^2./(Sxx.*Syy);
plot(f(id), gamma(id), DisplayName="Coherence"); %

% yline(1,"--","Theoretical Limit","HandleVisibility","off")
title('Finite Fourier Transform Method',Interpreter='none'); %
xlim([0,10]);
yticks(1)
legend(Location="northeast")
