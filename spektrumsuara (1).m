% Sound Noise Filter
% Date    : 28 November 2021


%% Initial
clc; 
clear; 
close all;

[y_asli,fs_1]=audioread('voice.wav');
[y_noise,fs_2]=audioread('traffic.mp3');

fs = max(fs_1,fs_2);

%% Menyamakan panjang y_asli dan y_noise
if length(y_noise) < length(y_asli)
    a = fix(length(y_asli)/length(y_noise)) + 1;                             
    i = 0;                                                         
    while i <= a;
        y_noise = [y_noise;y_noise];
        i = i+1;
    end
    y_noise = y_noise(1:length(y_asli));
else
    y_noise = y_noise(1:length(y_asli));
end

ts = 1/fs;                                                   
dt = 0:ts:(length(y_asli)*ts)-ts; 
%% Suara Asli

figure(1)
[H_asli,w_asli]=freqz(y_asli(:,1),1,10000,fs);
subplot(2,1,1); plot(w_asli,abs(H_asli)); title ('Spektrum Suara Asli'); ylabel('Magnitude'); xlabel('Frequency (Hz)'); xlim([0, max(w_asli)])
subplot (2,1,2) ; plot(w_asli/pi,angle(H_asli)); title('Respon Fasa'); xlabel('frekuensi'); ylabel('Fasa');
figure(2)
plot(dt,y_asli(:,1)); xlabel('time (s)'); ylabel('Amplitude');title('Original Audio');

%% Suara noise

figure(3)
[H_noise,w_noise]=freqz(y_noise(:,1),1,10000,fs); 
subplot(2,1,1); plot(w_noise,abs(H_noise)); title ('Spektrum Suara Noise'); ylabel('Magnitude'); xlabel('Frequency (Hz)'); xlim([0, max(w_noise)])
subplot (2,1,2) ; plot(w_noise/pi,angle(H_noise)); title('Respon Fasa'); xlabel('frekuensi'); ylabel('Fasa');
figure(4)
plot(dt,y_noise(:,1)); xlabel('time (s)'); ylabel('Amplitude');title('Noise Audio');

%% Penggabungan sinyal noise dengan sinyal asli
figure (5)
y_noised = y_asli+y_noise ;
[H_noised,w_noised]=freqz(y_noised(:,1),1,10000,fs);
subplot(2,1,1); plot(w_noised,abs(H_noised)); title ('Spektrum Sinyal Asli+Noise'); ylabel('Magnitude'); xlabel('Frequency (Hz)'); xlim([0, max(w_noised)])
subplot (2,1,2) ; plot(w_noised/pi,angle(H_noised)); title('Respon Fasa'); xlabel('frekuensi'); ylabel('Fasa');
figure(6)
plot(dt,y_noised(:,1)); xlabel('time (s)'); ylabel('Amplitude');title('Noised Audio');
%% Filter dan Suara hasil filter
figure(7)
%FIR
if(0)
lpf = fir1(147, 5000/(fs/2), 'low', bartlett(148));
[H_filter,w_filter]=freqz(lpf(1,:),1,10000,fs); 
subplot(2,1,1); plot(w_filter,mag2db(abs(H_filter))); title ('Spektrum Filter'); ylabel('Magnitude (db)'); xlabel('Frequency (Hz)'); xlim([0, max(w_filter)])
subplot (2,1,2) ; plot(w_filter/pi,angle(H_filter)); title('Respon Fasa'); xlabel('frekuensi'); ylabel('Fasa');
end

%IIR
if(1)
Rp=3;
As=24;
wp=4500/(fs/2);
ws=5500/(fs/2);
[n,wn]=buttord(wp,ws,Rp,As);
[b,a] = butter (n,wn,'low');
[H_filter,w_filter]=freqz(b,a,10000,fs); 
subplot(2,1,1); plot(w_filter,mag2db(abs(H_filter))); title ('Spektrum Filter'); ylabel('Magnitude (db)'); xlabel('Frequency (Hz)'); xlim([0, max(w_filter)])
subplot (2,1,2) ; plot(w_filter/pi,angle(H_filter)); title('Respon Fasa'); xlabel('frekuensi'); ylabel('Fasa');
end

%% Hasil filter

%FIR
if(0)
y_filter = filter(lpf,1,y_noised);
end

%IIR
if(1)
y_filter = filter(b,a,y_noised);
end

figure(8)
[H_hasil,w_hasil]=freqz(y_filter(:,1),1,10000,fs); 
subplot(2,1,1); plot(w_hasil,abs(H_hasil)); title ('Spektrum Hasil Filtering'); ylabel('Magnitude'); xlabel('Frequency (Hz)'); xlim([0, max(w_hasil)])
subplot (2,1,2) ; plot(w_hasil/pi,angle(H_hasil)); title('Respon Fasa'); xlabel('frekuensi'); ylabel('Fasa');
figure(9)
plot(dt,y_filter(:,1)); xlabel('time (s)'); ylabel('Amplitude');title('Filtered Audio');
%% Output Audio
%audiowrite('noised.wav',y_noised,fs);
%audiowrite('noise.wav',y_noise,fs);
%audiowrite('asli.wav',y_asli,fs);

