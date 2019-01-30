function [u, w] = simulate_channel(y, SNR_dB)
% Simulates a channel using an IIR filter and adding white noise
%
% IN:
%   y - the input signal of the channel
%   SNR_dB - signal to noise ratio for the additive white noise
%
% OUT:
%   u - the output of the channel
%   w_true - the true coefficients needed for an FIR filter to invert the channel


% simulate the effect of the channel by the IIR filter with coeffs
w = [1.0000    2.4156    2.2226    0.9578    0.1884    0.0130];

u = filter(1, w, y);

% add white noise
Pmeas = var(y);
SNR = 10^(SNR_dB/10);
P_noise = Pmeas/SNR;
additive_white_noise = sqrt(P_noise)*(randn(size(u)));


u = round(u + additive_white_noise);

