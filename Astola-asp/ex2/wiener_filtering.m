% SNG-20016 Advanced Signal Processing
% Exercise 3 Optimal Wiener filters
%
clc;
clear;
close all;
addpath('..\..\wiener\');

% load the audio sample that is treated as the input signal
[d, fs] = audioread('Tamara_Laurel_-_Sweet_extract.wav', 'native');
d = double(d);

% simulate the channel output
[u, w_true] = simulate_channel(d, Inf);

% extract a segment from both signals
s_start = 8;
d = d(s_start*fs+1:(s_start+1)*fs); 
u = u(s_start*fs+1:(s_start+1)*fs);

fig_idx = 1;

% write your Wiener filter implementation here using d and u.
snr_buf = [];
delay_buf = [];
for maxlag = 1:10

    [u_acorr,lag_uu]    = xcorr(u, maxlag,'biased');
    [ud_xcorr,lag_ud]   = xcorr(u, d, maxlag,'biased');

    
%     figure(fig_idx); fig_idx = fig_idx + 1;
%     plot(lag_uu, 20*log10(abs(u_acorr)), 'r-',lag_ud, 20*log10(abs(ud_xcorr)), 'y-'); title('Auto-correlation and Cross-correlation');
%     legend('Auto-correlation','Cross-correlation');
%     ylabel('dB'); xlabel('lag');

    % Forming the auto-correlation matrix Ruu. Note, Ruu is a toeplitz matrix.
    [WienerFiltered, Wopt] = wiener_filter(u, d, maxlag);

    % For Wiener filtering.
    [mse_wiener, snr_wiener, delay_wiener] = mse_estimation(d, WienerFiltered, maxlag);
    
    snr_buf = [snr_buf, snr_wiener];
    delay_buf = [delay_buf, delay_wiener];
end
figure(fig_idx); fig_idx = fig_idx + 1;

subplot(2,1,1); plot(snr_buf,'rd-','LineWidth',3); title('SNR of filtered signal vs maxlag setting'); grid;
subplot(2,1,2); plot(delay_buf,'bd-'); title('delay of filtered signal vs maxlag setting'); grid;

%% Calculate the MSE.
% For ideal equalization.
ideal_eq = filter(w_true,1,u);
[mse_ideal_eq, snr_ideal_eq, delay_ideal_eq] = mse_estimation(d, ideal_eq, maxlag);
mse_ideal_eq
snr_ideal_eq
delay_ideal_eq


function [mse, snr, delay] = mse_estimation(d, filtered, maxlag)
    [C, lags] = xcorr(d, filtered, maxlag, 'biased');
    [~,maxidx]= max(abs(C));
    delay  = lags(maxidx);
    err    = d(delay+1:end) - filtered(1:length(d)-delay);
    mse    = mean(err.*err);
    
    signal = mean(d.*d);
    snr    = 10*log10(signal/mse);
end