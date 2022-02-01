figure(1); clf;
tiledlayout(2,2,"TileSpacing","compact",Padding="compact")
for pow = [10, 11, 12, 13]
    maxlag = 2^pow;
    nexttile(); hold on;
    Rxy = xcorr(x, y, maxlag, 'unbiased'); % autocorrelation
    Rxy = flip(Rxy(1:maxlag)); % Select only the relevant portion of the spectrum
    Rxy(maxlag/2:end) = 0; % Increase frequency resolution while also trimming unreliable data
    Sxy = abs(fft(Rxy)); % FFT to obtain auto-spectrum
    npt = length(Sxy);
    fxy = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxy(id) ,abs(Sxy(id))*2/npt, DisplayName="S_{xy}=FFT(R_{xy}) "); %


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

    npt = length(Sxy);
    fxy = (0:npt-1)* fs /npt; %
    id = (1:npt/2);
    plot(fxy(id) ,abs(Sxy(id))*2/npt, DisplayName="S_{xy}=L-iQ"); %

    ylabel(sprintf("N = 2^{%i}",pow),Interpreter="tex")
    xlim([0,10]);
    
    legend
end

sgtitle("Comparing Cross Spectrum Using Correlation Function Method")