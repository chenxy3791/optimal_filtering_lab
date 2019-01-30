%% Exercise 2: 
% How do generate data according to different distributions in Matlab?

clear;
clc;
close all;

%% Normal distribution.

% n1 is a vector containing 100000 pseudorandom variables from an normal
% distribution; the similar with that of rand:
n1 = randn(100000, 1);


% The function hist can be used to count the number of values that fit in
% M=50 bins.
M = 50;

figure(1); 
hist(n1, M);
ylabel('Value count'); 
xlabel('Values');

% Question: When looking on the histogram, can you find an estimate for the
% average value from n? Variance? How?


%---------------------------------------
% n2 is given by the same randn function
m = 4.23;
s = 3.123;
n2 = m + s * randn(100000, 1);

figure(2); 
hist(n2, M);
ylabel('Value count');
xlabel('Values');

% Question: What are the values of m and s such that the vector n2 contains
% values from a normal distribution with mean 2 and variance 2.
