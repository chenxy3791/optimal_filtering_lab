function [filtered, Wopt] = wiener_filter(x, d, M)
%WIENER_FILTER Wiener filtering
%   x: Measured signal, column vector
%   d: Desired signal, column vector with the same length as x
%   M: Filter order

% auto-correlation of the measured signal
[C, ~] = xcorr(x, M, 'biased');
% auto-correlation matrix.
Rxx = toeplitz( C(M + 1 : end) );
% cross-correlation between d and x--the following two lines are
% equivalent.
%Rxd = xcorr(d, x, M, 'biased');
Rxd = xcorr(x, d, M, 'biased');
Rxd = Rxd(M + 1 : end);
% Wiener-Hopf equation to calculate the optimal filter coefficients
Wopt = inv(Rxx) * Rxd; % Becuase x and d are column vector, so Rxd is also colomn vector.

% Wiener filtering.
filtered = filter(Wopt, 1, x);

end