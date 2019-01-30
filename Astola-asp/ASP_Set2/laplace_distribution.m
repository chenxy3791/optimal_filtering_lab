%% Exercise 3: 
% How do generate data according to different distributions in Matlab?
clear;
clc;
close all;

%% Laplace distribution using the inverse transform method.

% u is a vector containing 1000000 pseudorandom variables from an uniform
% distribution.
u = rand(1000000, 1);
M = 1000;

% We use the inverse CDF to generate values from a laplace distribution
% with parameters mu and b.
% The inverse CDF is F_inv(l) = mu - b * sign(p - 0.5) * log(1 - 2*abs(p-0.5))
% from this it results that.

mu = 0;
b = 1;
l = mu - b * sign(u-0.5) .* log(1-2*abs(u-0.5));

% To view the value distribution we use the hist function:
subplot(3, 1, 1); 
hist(l, M);
ylabel('Value count'); 
xlabel('Values');
axis([-40 40 0 2*10^4]);

%----------------------------------
% Lets choose different parameters:
mu = 0;
b = 4;
l = mu - b * sign(u-0.5) .* log(1-2*abs(u-0.5));

% To view the value distribution we use the hist function:
subplot(3, 1, 2); 
hist(l, M);
ylabel('Value count'); 
xlabel('Values');
axis([-40 40 0 2*10^4]);

%----------------------------------
% Lets choose different parameters
mu = 10;
b = 4;
l = mu - b * sign(u-0.5) .* log(1-2*abs(u-0.5));

% To view the value distribution we use the hist function:
subplot(3, 1, 3); 
hist(l, M);
ylabel('Value count'); 
xlabel('Values');
axis([-40 40 0 2*10^4]);

% Question: What does the variables mu and b control?

