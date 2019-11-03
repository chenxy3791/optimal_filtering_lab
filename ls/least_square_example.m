%========= 最小二乘法( least square method ) demonstration ==========
%Created by chenxy, 2019-11-03
%Run the program repeatedly, different fit result(parameters) will be
%produced due to the random noise added to the data samples.
clc;
clear;
close all;
 
%=============== generate data ====================
x = (-5:1:5)';
y = x.^3 - 2 * x.^2 + 1.5 * x + 1 + randn(length(x),1) * 5;
n = 3;                      % 拟合多项式的阶数, should be not less than the known order of y.
 
%================= start design ===================
% y = f(x1,x2,...; w1,...,wn,w0)=w1*x^1 + ... + wn*x^n + w0*x^0 = X * W, W = [w0, w1, ..., wn]'
num = length(y);              % the number of data
X   = ones(num, n+1);         % x^1, ..., x^n, x^0=1. Usually called as design matrix
 
for i = 1:n+1
    X(:,i) = x.^(i-1);
end

W = (X'*X)^-1 * X'*y;       % W = [w0, w1, ..., wn]', least-square closed-form solution.
disp(W')

% draw result
figure(1);
scatter(x, y, 30, 'filled', 'blue');
hold on

% Print the fitted line
xplot = (-5:0.01:5);

X1   = ones(length(xplot), n+1);         % x^1, ..., x^n, x^0=1. Usually called as design matrix
 
for i = 1:n+1
    X1(:,i) = xplot.^(i-1);
end

% yplot = zeros(length(y),1);
% for i = 1:n+1
%     yplot = yplot + W(i,:)*xplot.^(i-1);    
% end
yplot = X1 * W;
plot(xplot, yplot, 'r', 'linewidth', 2);
title('least square method');   xlabel('x');    ylabel('y');

%================= polyfit ===================
%Matlab built-in function polyfit()
% P = polyfit(X,Y,N) finds the coefficients of a polynomial P(X) of
% degree N that fits the data Y best in a least-squares sense. P is a
% row vector of length N+1 containing the polynomial coefficients in
% descending powers, P(1)*X^N + P(2)*X^(N-1) +...+ P(N)*X + P(N+1).
p = polyfit(x,y,n);
disp(flip(p))

% Evaluate the fitted polynomial p and plot:
f = polyval(p,x);
figure(2);
plot(x,y,'o',x,f,'-');legend('data','linear fit');
title('polyfit');   xlabel('x');    ylabel('y');

% --------------------- 