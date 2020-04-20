%ECE 4271 Project 4 - Experiments
%Angad Daryani, Lillian Anderson

%import single audio file
[y, Fs] = audioread("EBB (1).WAV");

%create a shorter file to see specific components where audible automobile
%noise is present 

% T = n/Fs 
% n = T*Fs 
n = [(20*48000):(24*48000)];
identifiedNoise = y(n);
timeVec = [n./48000];

in_fft = abs(fft(identifiedNoise));
freqHz = (0:1:length(in_fft)-1)*Fs/(length(in_fft));
plot(freqHz,in_fft)
title('Magnitude of FFT for Clipped audio file for EB(1) v/s Freq(Hz)')
xlabel ('Freq(Hz)')
ylabel ('Mangitude of FFT')

%feature 1: Short Term Energy
windowLength = Fs*1;
feature = (sum(buffer(identifiedNoise.^2, windowLength)))';
figure
plot(1:length(feature), feature)
title('Feature 1:Short term energy')
xlabel('Time (s)')
ylabel('Short Term Energy')

%feature 2: PITCH
[f0,idx] = pitch(identifiedNoise,Fs);
figure 
plot(idx,f0)
title ('Feature 2: Pitch of shortened clip')
ylabel('Pitch (Hz)')
xlabel('Sample Number (n)')

%feature 3: Wavelet Packet Transform
level = 6;
wpt = wpdec(identifiedNoise,level,'sym6');
figure;
[S,T,F] = wpspectrum(wpt,Fs,'plot');

%feature 4: Time domain Spectral Flux
flux = spectralFlux(identifiedNoise,Fs);
taxis = linspace(0,size(identifiedNoise,1)/Fs,size(flux,1));
plot(taxis,flux)
xlabel('Time (s)')
ylabel('Flux')
title ('Time domain Spectral Flux')


%OTHER EXPERIMENTS WITH DIFFERENT FILES -----------------------------------

%here, we use T = n/Fs to get n = T*Fs --> since the first instance of car
%noise was present from 0.16 to 0.24, the samples exist between 768000 to
%1152000
%shortfile1 = y(768000:1152000); %16s to 24s
%shortfile2 = y(1728000:2208000);%36s to 46s
%shortfile3 = y(2688000:2880000); %56s to 1m

%create time vector for the first shortfile for plotting
%x1_samples = [768000:1152000];
%x1_time = [x1_samples./48000];


%create time vector for the second shortfile for plotting
%x2_samples = [1728000:2208000];
%x2_time = [x2_samples./48000];

%create time vector for the third shortfile for plotting
%x3_samples = [2688000:2880000];
%x3_time = [x3_samples./48000];

%take FFT of the shorter file to see what the frequency components look
%like with respect to samples
%shortFFT1 = abs(fft(shortfile1));
%shortFFT2 = abs(fft(shortfile2));
%shortFFT3 = abs(fft(shortfile3));
%figure
% subplot(3,1,1)
% plot(shortFFT1)
% title('First instance of auto noises')
% subplot(3,1,2)
% plot(shortFFT2)
% title('Second instance of auto noises')
% subplot(3,1,3)
% plot(shortFFT3)
% title('Third instance of auto noises')


% figure
% %just plotting the second shortfile
% plot(x2_time,shortFFT2);
% title('Second file with respect to time');
% 
% %try to view spectrogram to understand frequency changes with respect to
% %time 
% 
% 
% 
% %fast fourier transform
% y_fft = fft(y);
% 
% 
% % figure 
% % plot (y_fft)
% % title ('first FFT');
% 
% %abs value
% 
% 
% y_fftmag = abs(y_fft);
% N = length(y_fft);
% 
% %plot of FFT vs samples
% figure 
% plot(y_fftmag)
% title ('FFT with respect to samples')
% xlabel ('Samples(n)')
% ylabel ('Magnitude of Frequency')
% 
% %frequency in Hz
% freqHz = (0:1:length(y_fftmag)-1)*Fs/N;
% 
% %plot fft
% figure
% plot(freqHz,y_fftmag);
% xlabel('Frequency(Hz)')
% ylabel ('Magnitude of FFT')
% title ('Mag of FFT v/s Freq for AW(2) plot 2')
% 
% 
% %plot power spectral density estimate 
% figure
% plot(psd(spectrum.periodogram,y,'Fs',Fs,'NFFT',length(y)));
% 
% 
