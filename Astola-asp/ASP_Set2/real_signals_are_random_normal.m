function real_signals_are_random_normal(Y, dlt, cntr_pw, no)

nY = length(Y);

disp('Entering real_signals_are_random_normal()...');

for i=1:no % 每个循环取不同的区间长度2^(i+dlt)
    figure(1); clf;
    
    % Take intervals with length 2^(i+dlt):
    % Xcenters表示各区间的中心点
    if cntr_pw(1) == 0
        Xcenters = 0:2^(i+dlt):2^cntr_pw(2);
    else
        Xcenters = -2^cntr_pw(1):2^(i+dlt):2^cntr_pw(2);
    end
    
    % How many intervals fit inside min(Y) max(Y):
    % 区间个数
    number_of_intervals_containing_data = ceil((max(Y)-min(Y))/2^(i+dlt))
    
    % Take the intervals having as centers the points
    % -2^cntr_pw(1):2^(i+dlt):2^cntr_pw(2),
    % and compute how many times Y has value in each interval;
    % the hist function gives quickly the answer, followed by a plot:
    hist(Y, Xcenters); title('histogram of Y');
    hold on
    
    % Now compute the mean and variance of the values:
    [muhat, sigmahat] = normfit(Y);
    
    muhat_o = sum(Y)/length(Y);
    sigmahat_o = sqrt(sum( (Y-muhat_o).^2)/length(Y));
    
    matlab_estimates = [muhat, sigmahat]
    own_estimates = [muhat_o, sigmahat_o]
    
    % Assume a normal distribution and plot the frequency of occurance for
    % each interval, according to the normal distribution hypothesis:
    if cntr_pw(1) == 0
        Xbounderies = [0 (Xcenters(1:(end-1)) + Xcenters(2:end))/2 2^cntr_pw(2)];
    else
        Xbounderies = [-2^cntr_pw(1) (Xcenters(1:(end-1)) + Xcenters(2:end))/2 2^cntr_pw(2)];
    end
    
    % Cumulative normal distribution at each boundary point P(x<Xb(j)):
    P = normcdf(Xbounderies, muhat, sigmahat);
    
    % Probability of each interval:
    Pint = P(2:end) - P(1:(end-1));
    plot(Xcenters, nY*Pint, '-ro');
    ylabel('Value count');
    xlabel('Centers values');
    
    pause;
    clc;
end

end