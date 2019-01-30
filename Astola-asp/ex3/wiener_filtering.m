% SNG-20016 Advanced Signal Processing
% Exercise 3 Optimal Wiener filters
%

clear
close all

% load the audio sample that is treated as the input signal
[d, fs, nbits] = wavread('Tamara_Laurel_-_Sweet_extract.wav', 'native');
d = double(d);

% simulate the channel output
[u, w_true] = simulate_channel(d, Inf);

% extract a segment from both signals
s_start = 8;
d = d(s_start*fs+1:(s_start+1)*fs);
u = u(s_start*fs+1:(s_start+1)*fs);

% write your Wiener filter implementation here using d and u.
