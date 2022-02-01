%Louis Lin
% Prof. Loh
% SE 267A - HW1
% Jan. 6, 2022

%% Problem 1.
% Consider a signal made of 3 cosine functions.
% With Amplitudes
A = [1, 1.5, 0.7];
% where the frequencies of each cosine are
freq = [2.0, 2.1, 3.5];
% and the phases are 
phase = [0, pi/6, pi/4];

%% A. 
% Consider sampling rate as 100Hz and generate 1024 points. Calculate the fourier 
% amplitude spectrum (from 0.0Hz to 6.0Hz) and indentify the dominante frequencies 
% of the signal from the Fourier amplitude spectrum.
% First plot the signal.

figure(); clf;
fs = 100; % Frequncy of data
dt = 1/fs; % Time increment
L = 1024; %length of data
n = 0:L -1;
t = n* dt;
x1 = A*sin(2*pi*freq'*t + phase');
plot(t,x1,'-o','MarkerSize',3);
ylabel("Amplitude [-]");
xlabel("Time [s]");
title("Signal")

%% 
% Now to plot the fast fourier transform

figure(); clf; hold on;
x = x1;
N = 1024;
y = fft(x,N);
mag = abs(y)* 2/N;
f = (0:N-1)*fs/N;
id = (1:N/2); % First half

[pks,locs] = findpeaks(mag(id),f(id),'NPeaks',3,'MinPeakHeight',0.04);
stem(f(id), mag(id));
plot(locs, pks,'ro','MarkerFaceColor','r');
text(locs,pks,num2str(locs',4),'HorizontalAlignment','center','VerticalAlignment','bottom','Color','R'); 
xlim([0,6])
xlabel("Frequncy [Hz]");
ylabel("Magnitude [-]");
title("Ndata = 1024 NFFT = 512")

%% B. 
% Using the same sampling rate (100Hz) and with the duration of 10.24s, add 
% 1024 zeros at the end of the signal. Repeat the analysis from above.
% 
% Plot the signal.

figure(); clf;
fs = 100;
dt = 1/fs;
L = 1024; %length of data
t = (0:L -1)* dt;
f = A*sin(2*pi*freq'*t + phase');
x2 = [f, zeros(1,1024)];
L = length(x2); %length of data
t = (0:L -1)* dt;
plot(t,x2)
ylabel("Amplitude [-]");
xlabel("Time [s]");
title("Signal")
figure(); clf; hold on;
x = x2;
N = L;
y = fft(x,N);
mag = abs(y)* 2/N;
f = (0:N-1)*fs/N;
id = (1:N/2); % First half

[pks,locs] = findpeaks(mag(id),f(id),'NPeaks',3,'MinPeakHeight',0.3);
stem(f(id), mag(id));
plot(locs, pks,'ro','MarkerFaceColor','r');
text(locs,pks,num2str(locs',4),'HorizontalAlignment','center','VerticalAlignment','bottom','Color','R'); 
xlim([0,6])
xlabel("Frequncy [Hz]");
ylabel("Magnitude [-]");
title("Ndata = 2048 NFFT = 1024")
grid on
%% C. 
% Consider a sample rate of 10Hz. The duration of the signal is 12.8 second. 
% There are 128 points for the analysis. 

figure(); clf;
hold on;
fs = 10;
dt = 1/fs;
N = 128;
t = (0:N-1) * dt;
x3 = A*sin(2*pi*freq'*t + phase');
plot(t,x3,'-o');

ylabel("Amplitude [-]");
xlabel("Time [s]");
title("Signal")
figure(); clf; hold on;
x = x3;
y = fft(x,N);
mag = abs(y)* 2/N;
f = (0:N-1)*fs/N;
id = (1:N/2); % First half
[pks,locs] = findpeaks(mag(id),f(id),'NPeaks',3,'MinPeakHeight',0.3);
stem(f(id), mag(id));
plot(locs, pks,'ro','MarkerFaceColor','r');
text(locs,pks,num2str(locs',4),'HorizontalAlignment','center','VerticalAlignment','bottom','Color','R'); 
xlim([0,6])
xlabel("Frequncy [Hz]");
ylabel("Magnitude [-]");
title("Ndata = 128 NFFT = 64")
%% D.
% Consider the same condition as part c, but with zero padding of 128 points 
% at the end of the record. Repeat the same analysis.

figure(); clf; hold on;
fs = 10;ee
dt = 1/fs;
N = 128;
t = (0:N-1) * dt;
f = A*sin(2*pi*freq'*t + phase');
x4 = [f, zeros(1,128)];
L = length(x4); %length of data
t = (0:L -1)* dt;
plot(t,x4)
ylabel("Amplitude [-]");
xlabel("Time [s]");
title("Signal")
figure(); clf; hold on;
x = x4;
N = L;
y = fft(x,N);
mag = abs(y)* 2/N;
f = (0:N-1)*fs/N;
id = (1:N/2); % First half
[pks,locs] = findpeaks(mag(id),f(id),'NPeaks',3,'MinPeakHeight',0.3);
stem(f(id), mag(id));
plot(locs, pks,'ro','MarkerFaceColor','r');
text(locs,pks,num2str(locs',4),'HorizontalAlignment','center','VerticalAlignment','bottom','Color','R'); 
xlim([0,6])
xlabel("Frequncy [Hz]");
ylabel("Magnitude [-]");
title("Ndata = 256 NFFT = 128")