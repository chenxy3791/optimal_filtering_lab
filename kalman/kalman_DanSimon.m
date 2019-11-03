% Reference: DAN Simon, Kalman Filtering, JUNE 2001 Embedded Systems Programming

function kalman_DanSimon(duration, dt)
% function kalman(duration, dt)
%
% Kalman filter simulation for a vehicle travelling along a road.
% INPUTS
% duration = length of simulation (seconds)
% dt = step size (seconds)

measnoise  = 10;  % position measurement noise (feet)
accelnoise = 0.2; % acceleration noise (feet/sec^2)
a = [1 dt; 0 1];  % transition matrix
b = [dt^2/2; dt]; % input matrix
c = [1 0];        % measurement matrix
Sz = measnoise^2; % measurement error covariance
Sw = accelnoise^2 * [dt^4/4 dt^3/2; dt^3/2 dt^2]; % process noise cov


% Initialization
x = [0; 0];       % initial state vector
xhat = x;         % initial state estimate
P  = Sw;          % initial estimation covariance

% Initialize arrays for later plotting.
pos     = []; % true position array
poshat  = []; % estimated position array
posmeas = []; % measured position array
vel     = []; % true velocity array
velhat  = []; % estimated velocity array

% Recursive loop
for t = 0 : dt: duration
    % Use a constant commanded acceleration of 1 foot/sec^2.
    u = 1;
    % Simulate the linear system.
    ProcessNoise = accelnoise * [(dt^2/2)*randn; dt*randn];
    x = a * x + b * u + ProcessNoise;
    % Simulate the noisy measurement
    MeasNoise = measnoise * randn;
    y = c * x + MeasNoise;
    % Extrapolate the most recent state estimate to the present time.
    xhat = a * xhat + b * u;
    % Form the Innovation vector.
    Inn = y - c * xhat;
    % Compute the covariance of the Innovation.
    s = c * P * c' + Sz;
    % Form the Kalman Gain matrix.
    K = a * P * c' * inv(s);
    % Update the state estimate.
    xhat = xhat + K * Inn;
    % Compute the covariance of the estimation error

    P = a * P * a' - a * P * c' * inv(s) * c * P * a' + Sw;
    % Save some parameters for plotting later.
    pos = [pos; x(1)];
    posmeas = [posmeas; y];
    poshat = [poshat; xhat(1)];
    vel = [vel; x(2)];
    velhat = [velhat; xhat(2)];
end

% Plot the results
close all;
t = 0 : dt : duration;
figure;
plot(t,pos, t,posmeas, t,poshat);grid;
legend('True position','Measured position','Estimated position');
xlabel('prmb\_corr\_rot\_bufTime (sec)');
ylabel('Position (feet)');
title('Figure 1 - Vehicle Position (True, Measured, and Estimated)')

figure;
plot(t,pos-posmeas, t,pos-poshat);grid;
legend('Error between True position and Measured position','Error between True position and Estimated position');
xlabel('Time (sec)');
ylabel('Position Error (feet)');
title('Figure 2 - Position Measurement Error and Position Estimation Error');

figure;
plot(t,vel, t,velhat);grid;
legend('True Velocity','Estimated Velocity');
xlabel('Time (sec)');
ylabel('Velocity (feet/sec)');
title('Figure 3 - Velocity (True and Estimated)');

figure;
plot(t,vel-velhat);grid;
xlabel('Time (sec)');
ylabel('Velocity Error (feet/sec)');
title('Figure 4 - Velocity Estimation Error')