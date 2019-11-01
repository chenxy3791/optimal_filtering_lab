% Reference: 
% https://www.researchgate.net/publication/296636431
% Mahamad Nabab Alam: Codes in MATLAB for Particle Swarm Optimization

% TO-DO:
% [1] Dump all the simulation data to files for the convenenience of
% post-analysis.
% [2] Packaging the 'pso algorithm' part into one function.

tic
clc
clear all
close all
rng default
LB  = [0 0 0]; %lower bounds of variables
UB  = [10 10 10]; %upper bounds of variables

% pso parameters values
m   = 3;   % number of variables, or number of elements of state vector
n   = 100; % population size
wmax= 0.9; % inertia weight upper limit
wmin= 0.4; % inertia weight lower limit
c1  = 2;   % acceleration factor. Learning rate governing the cognition component
c2  = 2;   % acceleration factor. Learning rate governing the social component

% pso main program----------------------------------------------------start
maxite=1000; % set maximum number of iteration
maxrun=10;   % set maximum number of runs need to be

for run=1:maxrun
run
    % pso initialization----------------------------------------------start
    for i=1:n
        for j=1:m
            x0(i,j)=round(LB(j)+rand()*(UB(j)-LB(j)));
        end
    end
    x=x0; % initial population
    v=0.1*x0; % initial velocity
    for i=1:n
        f0(i,1)=ofun(x0(i,:));
    end
    [fmin0,index0]=min(f0);
    pbest=x0; % initial pbest
    gbest=x0(index0,:); % initial gbest
    % pso initialization------------------------------------------------end
    
    % pso algorithm---------------------------------------------------start
    ite=1;
    tolerance=1;
    while ite<=maxite && tolerance>10^-12
    
        w=wmax-(wmax-wmin)*ite/maxite; % update inertial weight
        
        % pso velocity updates
        for i=1:n
            for j=1:m
                v(i,j) = w*v(i,j) + c1*rand()*(pbest(i,j)-x(i,j)) + c2*rand()*(gbest(1,j)-x(i,j));
            end
        end
        
        % pso position update
        for i=1:n
            for j=1:m
                x(i,j)=x(i,j)+v(i,j);
            end
        end
        
        % handling boundary violations
        for i=1:n
            for j=1:m
                if x(i,j)<LB(j)
                    x(i,j)=LB(j);
                elseif x(i,j)>UB(j)
                    x(i,j)=UB(j);
                end
            end
        end
        
        % evaluating fitness
        for i=1:n
            f(i,1)=ofun(x(i,:));
        end
        
        % updating pbest and fitness
        for i=1:n
            if f(i,1)<f0(i,1)
                pbest(i,:)=x(i,:);
                f0(i,1)=f(i,1);
            end
        end
        [fmin,index]=min(f0); % finding out the best particle
        ffmin(ite,run)=fmin; % storing best fitness
        ffite(run)=ite; % storing iteration count
        
        % updating gbest and best fitness
        if fmin<fmin0
            gbest=pbest(index,:);
            fmin0=fmin;
        end
        
        % calculating tolerance
        if ite>100
            tolerance=abs(ffmin(ite-100,run)-fmin0);
        end
        
        % displaying iterative results
        if ite==1
            fprintf('Iteration Best particle Objective fun\n');
        end
        fprintf('%8g %8g %8.4f\n',ite,index,fmin0);
        ite=ite+1;
    end
    % pso algorithm-----------------------------------------------------end
    % gbest;
    fvalue        = 10*(gbest(1)-1)^2+20*(gbest(2)-2)^2+30*(gbest(3)-3)^2;
    fff(run)      = fvalue;
    rgbest(run,:) = gbest;
    fprintf('--------------------------------------\n');
end
% pso main program------------------------------------------------------end

fprintf('\n\n');
fprintf('*********************************************************\n');
fprintf('Final Results-----------------------------\n');
[bestfun,bestrun] = min(fff)
best_variables    = rgbest(bestrun,:)
fprintf('*********************************************************\n');
toc

% PSO convergence characteristic of the best run.
plot(ffmin(1:ffite(bestrun),bestrun),'-k');
xlabel('Iteration');
ylabel('Fitness function value');
title('PSO convergence characteristic of the best run');

% PSO convergence characteristic of all runs.
figure(); hold on;
for k = 1:maxrun
    plot(ffmin(1:ffite(k),k));
end
xlabel('Iteration');
ylabel('Fitness function value');
title('PSO convergence characteristic of all runs');

%##########################################################################
