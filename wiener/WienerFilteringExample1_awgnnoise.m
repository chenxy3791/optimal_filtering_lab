clc; close all; clear;
echo off;

fig_idx = 1;
%% Signal Generation
N  = 1e4;                 % Number of signal points.
fs = 2000;                % Sampling rate.
f0 = 10;                  % Sine signal frequency.
t  = linspace(0, (N-1)/fs, N);
M  = 50;                  % Filter order, corresponding to (M+1)-taps filter

s = 2 * sin(2 * pi * f0 * t + pi / 3);
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
[y_wiener,Wopt] = wiener_filter(Y, s, M);

% error
err_wiener = s - y_wiener;

% Result
% figure(fig_idx); fig_idx = fig_idx + 1;
% plot(t, s, 'r-', t, y, 'b-');
% legend('Original signal (Desired)','Filtered Output'); title('Wiener Filtering: Original signal (Desired), Filtered output');
% xlabel('time(sec)');ylabel('signal value');

% figure(fig_idx); fig_idx = fig_idx + 1;
% plot(t, err_wiener);
% title('Error');
% xlabel('time(sec)');ylabel('error value');
toc

%% SNR after filtering
SNR_after_filtering = 10*log10((s'*s)/(err_wiener'*err_wiener))

%% LMS algorithm
tic
% err_buf stores the error history, err_buf(k) is the error after the k-th iteration
err_lms = zeros(N, 1);
% W initialization. W is the adaptive filter coefficients. NOTE, it should
% be (M+1) taps, to be in consistent with the above wiener fiter.
Wlms = zeros(M+1, 1);
% Calculate the maximum eigenvalue of the input auto-correlation matrix,
% and decide the step-size based on the max eigenvalue.
% 0 < mu < 1/rho
% But in practical engineering problem, it is usually decided emprically or
% by simulation.
Rho_max = max(eig(Y * Y.'));
%mu = rand * (1 / Rho_max);  
mu = 0.25 * (1 / Rho_max);  

% y stores the filtered output from adaptive filter.
y_lms = zeros(size(Y));
for k = M + 1 : N % Iteration
    % Input vector for adaptive filter
    x = Y(k : -1 : k - M);
    % Adaptive filter output
    y_lms(k) = Wlms.' * x;
    % error of the k-th step iteration.
    err_lms(k) = s(k) - y_lms(k);
    % Filter coefficients update
    Wlms = Wlms + 2 * mu * err_lms(k) * x;
end
% Result.
figure(fig_idx); fig_idx = fig_idx + 1; plot(t, s, 'r-', t, y_wiener, 'b-',t, y_lms, 'k-');
legend('True desired signal','Wiener Filter output', 'LMS Filter output');
title('Comparison between true signal and Wiener filtered output, LMS filtered output');
xlabel('time(sec)');ylabel('signal value');
% figure(fig_idx); fig_idx = fig_idx + 1; plot(t , err_lms);
% title('Error of LMS');xlabel('time(sec)');ylabel('error value');
toc

%% Comparison between wiener-hopf solution and LMS filter coeffients after convergence
figure(fig_idx); fig_idx = fig_idx + 1;
plot([1:1:M+1], Wopt, 'ro-', [1:1:M+1], Wlms, 'kd-');
legend('Wiener filter', 'LMS filter');
title('Wiener filter vs LMS filter: filter coefficients');

figure(fig_idx); fig_idx = fig_idx + 1;
plot(t , err_wiener, 'r-', t , err_lms, 'k-');
legend('Wiener filter', 'LMS filter');
title('Wiener filter vs LMS filter: error curve');

echo off;
