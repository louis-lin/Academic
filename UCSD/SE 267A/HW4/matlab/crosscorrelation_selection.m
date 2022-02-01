% Plot the Auto Power Spectrums
figure(2); clf;  hold on;
x = data.RCF2_100_A10;
y = data.RCF2_100_A04;

% Auto Correlation Function Method
maxlag = 2^10;
[Rxy,tau] = xcorr(x, y, maxlag, 'unbiased'); % autocorrelation

% plot(tau, Rxy)

id1 = (1:maxlag/2);
id2 = (maxlag/2:maxlag+1);
id3 = (maxlag +1: 1.5*maxlag);
id4 = (1.5*maxlag:2*maxlag);

plot(tau(id1),Rxy(id1), color="k",LineWidth=2)
plot(tau(id2),Rxy(id2), color="r",LineWidth=2)
plot(tau(id3),Rxy(id3), color="b",LineWidth=2)
plot(tau(id4),Rxy(id4), color="k",LineWidth=2)


xlim([-1 1] * maxlag)
grid
xlabel("Time lag [\tau]")
title("Cross Correlation Function Between Input and Output Signal")


clf
nexttile(2)
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
p = plot(f(id), Sxy(id),DisplayName="Finite Fourier Transform Method",LineWidth=2);
p.Color(4) = .5;

nexttile(1); hold on;
Rxy = flip(Rxy(id2)); % Select only the relevant portion of the spectrum
Rxy(maxlag/2:maxlag) = 0; % Increase frequency resolution while also trimming unreliable data
plot(Rxy,Color='r',LineWidth=2)

Sxy = abs(fft(Rxy)); % FFT to obtain auto-spectrum
npt = length(Sxy);
fxy = (0:npt-1)* fs /npt; %
id = (1:npt/2);

nexttile(2); hold on;
plot(fxy(id) ,Sxy(id)*2/npt, DisplayName="Auto Correlation Method",Color='r',LineWidth=2); %
xlim([0,10])


[Rxy,tau] = xcorr(x, y, maxlag, 'unbiased'); % autocorrelation
nexttile(1)
Rxy = Rxy(id3); % Select only the relevant portion of the spectrum
Rxy(maxlag/2:maxlag) = 0; % Increase frequency resolution while also trimming unreliable data
plot(Rxy,Color='b',LineWidth=2)
xlabel("Time Lag [\tau]")
title("Cross Correlation Function")

Sxy = abs(fft(Rxy)); % FFT to obtain auto-spectrum
npt = length(Sxy);
fxy = (0:npt-1)* fs /npt; %
id = (1:npt/2);
nexttile(2)
plot(fxy(id) ,Sxy(id)*2/npt, DisplayName="Auto Correlation Method",Color='b',LineWidth=2); %

xlim([0,10])
xlabel("Frequency [Hz]")
ylabel("Amplitude")
title("Cross Power Spectral Density Function")


