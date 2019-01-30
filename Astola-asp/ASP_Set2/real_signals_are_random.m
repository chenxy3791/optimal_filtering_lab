%% Exercise 4: 
% Are real signals random? Does probabilistic description make any sense?
%% Input the data from a .wav file and check its significance.

clear;
clc;
close all;
play_sounds = 1;

[Y1,FS] = audioread('BeeGees.wav', 'native');

% Question: What is the length of the signal, its sampling frequency and the
% number of bits?

Y = double(Y1); % 为什么需要这个类型转换呢？

% Play in audioplayer the waveform in Y.
if(play_sounds)
    player = audioplayer(Y1(1:15*FS),FS);
    playblocking(player);
end

%% Find the empirical distribution of values within the whole file
format shortg

% How much is used from the available range of values.
data_range = [min(Y) max(Y) -2^15 2^15]  % Seems unused.

% Try to see if the audio data has a normal distribution.
disp('normal distribution test by calling real_signals_are_random_normal()...');
real_signals_are_random_normal(Y, 7, [15 15], 6);

% Y has a lot of zeros:
figure(2), clf
plot(Y1==0);
title('The position of zeros in the signal');
xlabel('index in the signal vector');
ylabel('Q: Y(index) = 0? R: 1(Yes); 0(No)');

% What if the value Y=0 is taken out of the signal values, and all
% histogram fitting is repeated?
Y(Y1==0) = [];

% Question: Repeat the execution of the above module. What is different?
% Why?
% 中心为0的区间的统计个数变少了，直方图的中间那根线变短了，使得总的分布更接近正态分布了
disp('normal distribution test again after removing all zeros...');
real_signals_are_random_normal(Y, 7, [15 15], 6);

% Repeat the fitting for the absolute values |Y|, assuming an
% exponential distribution. Is the fit better in this case than for the
% Gaussian distribution? (Hint: use the real_signals_are_random_normal
% function as basis and replace the parameter estimations and cdf
% computation with similar functions for exponential distribution)

%% Select a small segment containing only one second of audio.

clc;
close all;

Tbase = 1000000;
Ya = Y(Tbase+(1:44100));
real_signals_are_random_plot_one_sec;

% Task: Zoom in various parts of the signal to check possible
% periodicities.


% Play in audioplayer only the selected segment:
player = audioplayer(Y1(Tbase+(1:44100)),FS);
playblocking(player);

% Repeat the evaluations for this shorter signal.
disp('normal distribution test for the one second segment...');
real_signals_are_random_normal(Ya, 7, [15 15], 6);

% Question: Is the normal distribution still describing the data?


%% Analyze now the first difference signal Y(t)-Y(t-1)
clc;
close all;

disp('normal distribution test for the first difference signal Y(t)-Y(t-1)...');
Yd = double(Y(2:end)-Y(1:(end-1)));
real_signals_are_random_normal(Yd, 7, [15 15], 6);


%% Signal quatization
clc;
close all;

disp('Quantization noise distribution analysis...');

% Uniform quantizer with step size Delta = 2^9.
Delta = 2^9;
% Assume the centers to be:
Xcenters = -2^15:2^9:2^15;

% The quantizer is uniform, the reconstructed value is
% round(Y(i)/Delta)*Delta, for example 1:10000 is quantized to:
true_y = -10000:10000;
quantized_y = round(true_y/Delta) * Delta;
figure(1); plot(true_y,quantized_y,'o-r')
grid on


% Let's quantize now the audio signal:
quantized_Y = round(Y/Delta)*Delta;
quant_error = Y-quantized_Y;
figure(2); hist(quant_error, min(quant_error):max(quant_error));

% Taking out the "abnormal" Y=0 values:
Y(Y==0)=[];
quantized_Y = round(Y/Delta)*Delta;
quant_error = Y-quantized_Y;
figure(3); hist(quant_error, min(quant_error):max(quant_error));

% Q: The usual hypothesis is "QUANTIZATION ERRORS ARE UNIFORMLY
% DISTRIBUTED". Does the hypothesis hold?


%% Now let's read an image
close all;
clc;

A = imread('Barbara.tif');
figure(1); imshow(A);
pause
Y = double(A(:));

% Find the empirical distribution of values within the whole file
format shortg
disp('normal distribution test for the image data...');
real_signals_are_random_normal(Y, -1, [0 8], 4);

%% 
close all;
clc;
 
%------------------------------------------------------------------
% Represent differently the matrix A, by means of the matrix B and the
% first row of matrix A:--这个注释不知所以。貌似列间差分运算？
A1 = double(A);
B = A1(:,2:end)-A1(:,1:(end-1));
Y = double(B(:));

% Find the empirical distribution of values within the whole file:
disp('normal distribution test for the first horizontal difference of image data...');
real_signals_are_random_normal(Y, -1, [8 8], 4);

%%

close all;
clc;

%------------------------------------------------------------------
% Find the empirical distribution of values for abs(Y) within the whole
% file:
format shortg
Y = double(B(:));
Y = abs(Y);

% Find the empirical distribution of values within the whole file:
disp('normal distribution test for absolute of the first horizontal difference of image data...');
real_signals_are_random_normal(Y, -1, [8 8], 4);

% Question: Comment the results for the image data.

