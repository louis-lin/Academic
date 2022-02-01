%% Import Data
clear; clc;
addpath("Case-8\")
addpath("Case-1\")

fs = 200;
dt = 1/fs;
nFloors = 6;
ii = 65:76;
caseName = "Case-1";

for fl = 1:nFloors
    x_a = readvars(caseName+"\WN_50gal _SPECIMEN1_"+ ii(2*fl-1)+ "_A"+fl+"a__.TXT");
    x_b = readvars(caseName+"\WN_50gal _SPECIMEN1_"+ ii(2*fl)+ "_A"+fl+"b__.TXT");
    signals.("FL"+fl) = 0.5*(x_a +x_b);
end

% Plot the data
figure(1); clf;
tiledlayout(nFloors,2,"TileSpacing","compact","Padding","compact")

for fl = 1:nFloors
    signal = signals.("FL"+fl);
    nexttile()
    plot((1:length(signal))*dt, signal)
    ylabel("Floor " + fl + " Acc. [g]")

    nexttile()
    npt = length(signal);
    npt = 2^nextpow2(npt);
    y = fft(signal,npt);
    power = abs(y)* 2/npt;
    f = (0:npt-1)*fs/npt;
    id = (1:npt/2);
    plot(f(id), power(id));
    xlim([0,20]);
    xlabel ("Frequency [Hz]"); %
end

sgtitle(caseName,'fontname','times')
print_figure(1,".\figure",caseName+" Unfiltered Data",8,6.5);
%% Data Preprocessing
clc;
Fs = 200; % Current sampling rate
% fs = 80; % Resampling rate
n = 4;
% Wn = [0.1,20]/(fs/2);
Wn = 20/(0.5*fs);
% ftype = 'bandpass';
ftype = 'low';
[b,a] = butter(n,Wn,ftype);

figure(2); clf;
tiledlayout(nFloors,2,"TileSpacing","compact","Padding","compact")
for fl = 1:nFloors
    signal = signals.("FL"+fl);

%     signal = resample(signal, fs, Fs); % Resample the data to be 80Hz
    signal = detrend(signal);
    signal = filtfilt(b,a,signal);

    nexttile()
    plot((1:length(signal))*dt, signal)
    ylabel("Floor " + fl + " Acc. [g]")

    nexttile()
    npt = length(signal);
    npt = 2^nextpow2(npt);
    y = fft(signal,npt);
    power = abs(y)* 2/npt;
    f = (0:npt-1)*fs/npt;
    id = (1:npt/2);
    plot(f(id), power(id));

    xlim([0,20]);
end
sgtitle(caseName,'fontname','times')
print_figure(2,".\figure",caseName+" Fltered Data",8,6.5);
%% Cross Correlation Function Matrix
clc;
maxlag = 2^13;
Ryy = zeros(nFloors,nFloors,maxlag);
Gyy = zeros(nFloors,nFloors,maxlag);

% Calculate the correlation between signals
for ii = 1:nFloors
    for jj = 1:nFloors
        R_ii_jj = xcorr(signals.("FL"+ii),signals.("FL"+jj),maxlag, "unbiased");
        R_ii_jj = flip(R_ii_jj(1:maxlag));
        R_ii_jj(maxlag/2:end) = 0;
        Ryy(ii,jj,:) = R_ii_jj;
    end
end

% Calculate the correlation spectrums
for ii = 1:nFloors
    for jj = 1:nFloors
        lxy = 0.5* (Ryy(ii,jj,:)+Ryy(jj,ii,:)); % Co-Correlation
        qxy = 0.5* (Ryy(ii,jj,:)-Ryy(jj,ii,:)); % Quadra-Correlation    
        Lxy = real(fft(lxy)); %Co-Spectrum
        Qxy = imag(fft(qxy)); % Quadra-Spectrum
        Gyy(ii,jj,:) = Lxy-Qxy*1i; % Cross Spectrum
    end
end

npt = maxlag;
fxy = (0:npt-1)* fs /npt; %
id = (1:npt/2);

figure(3); clf;
tiledlayout(nFloors,nFloors,"TileSpacing","compact","Padding","compact")

for ii = 1:nFloors
    for jj = 1:nFloors
        nexttile()
        spectrum = abs(Gyy(ii,jj,id))*2/maxlag;
        spectrum = reshape(spectrum,[],1);
        semilogy(fxy(id) ,spectrum); 
        title("R_{"+ii +"" + jj+"}");
        xlim([0,10])
        xticks([])
        yticks([])
    end
end

sgtitle(caseName,'fontname','times')
print_figure(3,".\figure",caseName+" Cross Correlation",4.5,6.5);
%%  Singular Value plots
clc;
singularValues = zeros([nFloors,maxlag]);
modeshapes = zeros([nFloors,1,maxlag]);

for ff = 1:maxlag
    [U,S,V] = svd(Gyy(:,:,ff),'econ');
    singularValues(:,ff) = diag(S);
    modeshapes(:,:,ff) = U(:,1);
end

figure(4); clf; clc;
hold on;
fxy = (0:npt-1)* fs /npt; %
id = (1:npt/2);
p = plot(fxy(id), singularValues(1:3,id)',LineWidth=1.5);
xlim([0,20]);

nPks = 6;
[pk, loc] = findpeaks(singularValues(1,id),NPeaks=nPks,MinPeakHeight=max(singularValues(1,:))*0.01,MinPeakDistance=50);

plot(fxy(loc), pk,'r.')
for nn = 1:nPks
    text(fxy(loc(nn)), pk(nn),sprintf("%.2f Hz", fxy(loc(nn))))
end

set(gca,"yscale","log")
ylabel ('Singular Value Value'); 
xlabel ("Frequency (Hz)"); %
legend("1^{st} \Sigma Value", "2^{nd} \Sigma Value","3^{rd} \Sigma Value")
grid
xlim([0,20])
title(caseName)
print_figure(4,".\figure",caseName+" Singular Value",4,6.5);
%% Polar Plots
figure(5); clf; clc;
tiledlayout(2,nFloors,"TileSpacing","compact","Padding","compact","TileIndexing","columnmajor")

for ss = 1:6
    nexttile; 
    hold on;
    shape = [0; real(modeshapes(:,:,loc(ss)))];
    shape = shape./norm(shape);
    plot(shape,0:6, "-o");
    title(sprintf("f = %.2f Hz", fxy(loc(ss))))
    xline(0,'--');
    grid;
%     pbaspect([1,1,1])
    xlim([-1 1]*1)

    nexttile; 
    theta = angle(modeshapes(:,:,loc(ss)));
    rho = abs(modeshapes(:,:,loc(ss)));
    polarplot(theta, rho,'x');
    title(sprintf("f = %.2f Hz", fxy(loc(ss))))
    Ax = gca;
    Ax.RTickLabel = [];
    Ax.ThetaTickLabel = [];

end
sgtitle(caseName,'fontname','times')
print_figure(5,".\figure",caseName+" Mode Shape + Polar Plot",4,6.5);
