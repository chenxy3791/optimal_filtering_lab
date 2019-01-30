clc; close all; clear;
echo off;

fig_idx = 1;
%% Signal Generation
N  = 1e4;                 % Number of signal points.
fs = 2000;                % 100Hz.
t  = linspace(0, (N-1)/fs, N);
n = linspace(0, 1200, N);
M = 50;                   % Filter order, corresponding to (M+1)-taps filter

s = 2 * sin(2 * pi * t + pi / 3);
s = s(:);  % Transform to column vector

% Add the additive noise.
SNR = 0; % dB
Y = awgn(s,SNR,'measured');
SNR_esti = 10*log10((s'*s)/((Y - s)'*(Y - s)))

figure(fig_idx); fig_idx = fig_idx + 1;
plot(t,Y,'g-'); hold on;
plot(t,s,'r-','LineWidth',4); 
legend('Noise corrupted signal','Orignal signal');
title('Original signal vs Noise corrupted signal');
xlabel('time(sec)');ylabel('signal value');

%% Wiener Filtering
tic
y = wiener_filter(Y, s, M);

% error
err = s - y;

% Result
figure(fig_idx); fig_idx = fig_idx + 1;
plot(t, s, 'r-', t, y, 'b-');
legend('Original signal (Desired)','Filtered Output'); title('Wiener Filtering: Original signal (Desired), Filtered output');
xlabel('time(sec)');ylabel('signal value');

figure(fig_idx); fig_idx = fig_idx + 1;
plot(t, err);
title('Error');
xlabel('time(sec)');ylabel('error value');
toc

%% SNR after filtering
SNR_after_filtering = 10*log10((s'*s)/(err'*err))

echo off;
