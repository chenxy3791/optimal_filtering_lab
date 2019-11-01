% Reference: 
% https://www.researchgate.net/publication/296636431
% Mahamad Nabab Alam: Codes in MATLAB for Particle Swarm Optimization

function f = ofun(x)

    % objective function (minimization)
    of = 10*(x(1)-1)^2+20*(x(2)-2)^2+30*(x(3)-3)^2;
    
    % constraints (all constraints must be converted into <=0 type)
    % if there is no constraints then comments all c0 lines below
    
    c0    = [];
    c0(1) = x(1)+x(2)+x(3)-5; % <=0 type constraints
    c0(2) = x(1)^2+2*x(2)-x(3); % <=0 type constraints
    
    % defining penalty for each constraint
    for i = 1 : length(c0)
        if c0(i) > 0
            c(i) = 1;
        else
            c(i) = 0;
        end
    end
    
    penalty = 10000; % penalty on each constraint violation
    f = of + penalty * sum(c); % fitness function
