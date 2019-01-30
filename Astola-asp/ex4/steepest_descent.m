function w_save = steepest_descent(R, p, w, mu, N)
% The steepest descent algorithm.
%
% IN:
%   R - the autocorrelation matrix
%   p - the cross-correlation vector
%   w - the initial filter coefficients
%   mu - the step size
%   N - maximum number of iterations
%
% OUT:
%   w_save - the filters at different iterations as columns(!) of w_save
%            i.e. the final filter is at w_save(:,end)

