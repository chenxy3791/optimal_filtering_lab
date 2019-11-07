%Refer to: https://blog.csdn.net/Tiger_v/article/details/80274658
%============== Kalman filtering ================
clc; 
clear;
close all;
 
% 在这个例子中，原始数据（underlying ground-truth）是（可以理解为）一条线性增长
% 的曲线。
% 加入噪声后，则可以理解为对该线性增长曲线的带有误差的观测结果。
% 这个underlying ground-truth可以看作是比如说一个匀速直线运动的物体的随时间变化
% 的距离。
% 系统状态包括离散时间点的距离和速度。
% 而要估计的参数则是它的运动速度。
% 按照这种解释(one possible explanation, not limited to this one)，可以把距离
% 和速度理解为状态变量，
% 也就是说下面的X[0]可以理解为距离，X[1]可以理解为运动速度。这样以下矩阵A的物理
% 意义就很直白而且容易理解了。
% 而H表示观测矩阵(measurement sensitivity matrix)，因为实际上只能观测到距离，所
% 以H = [1 0]. H取决于模型本身的特性。

% 疑问1：P的初始值如何确定？初始值对最终结果有影响吗，影响收敛速度吗？
% 疑问2：Q矩阵如何确定？
% 疑问3：R矩阵如何确定？
% 疑问4：A代表状态迁移，这个也是应该取决于系统模型本身。
%        这个也是一般假定为静态不变的，有可变的情况吗？

%=============== generate data ====================
orginal_data = (1:2:200);
noise = randn(1, 100);
sigma = 0.316; 
meas_data = orginal_data + noise*sigma;

%=============== Least Square Method for average velocity estimation=======
%   y = H * x + b0
%   y: meas_data, measured data
%   x: velocity to be estimated
%   b0:the initial distance at time 0
y = meas_data';
H_ls = (1:1:length(meas_data))'; 
G_ls = H_ls' * H_ls;
G_inv = inv(G_ls);
x = G_inv * (H_ls' * y);
fprintf(1, 'The estimated velocity from least-sqaure method = %g\n', x);

%=============== Velocity estimation based on IIR filtering=======
iir_alpha = 0.9;
v_instantaneous = meas_data(2:end)-meas_data(1:length(meas_data)-1);
v_esti = zeros(1, length(v_instantaneous)); 
v_esti(1) = v_instantaneous(1);

for k = 2:length(v_instantaneous)
    v_esti(k) = iir_alpha * v_esti(k-1) + (1-iir_alpha) * v_instantaneous(k);
end

figure;
plot(v_esti); title('Velocity estimation based on IIR filtering');grid on;


%=============== Kalman filtering ===========================
% 相关参数
X = [0; 0];         % k-1 时刻的系统状态. 
P = [1 0; 0 1];     % k-1 时刻的系统状态对应的协方差矩阵--what is the physical interpretation for P?
A = [1 1; 0 1];     % 系统参数矩阵--state transition matrix
Q = [0.0001 0; 0 0.0001];     % 系统过程的协方差--the covariance of the underlying and unknown process noise.
H = [1 0];          % 测量系统的参数
R = sigma^2;        % 测量过程的协方差--the covariance of the underlying and unknown measurement process noise.
                    % 

X_buf = zeros(2, length(meas_data));
X_buf(:,1) = X;

figure;
hold on;
for i = 2:100    
    X_k = A*X;       % k 时刻的系统状态, in this example, no external input is assumed, hence the next state depends only on the previous state. 
    P_k = A*P*A' + Q;                 % k 时刻的系统状态对应的协方差矩阵
    Kg  = P_k*H' / (H*P_k*H' + R);    % 卡尔曼增益(Kalman Gain)
    X   = X_k + Kg*(meas_data(i) - H*X_k);  % k时刻的系统状态的最优化估算值
    P   = (eye(2) - Kg*H) * P_k;      % 更新k时刻的系统状态对应的协方差矩阵

    X_buf(:,i) = X;    

end

% 纵轴表示速度
scatter([2:1:100], meas_data(2:end)-meas_data(1:length(meas_data)-1), 20, 's', 'filled', 'red');  grid on;
scatter([1:1:100], X_buf(2,:), 5); title('Measured instantaneous velocity vs Estimated velocity');grid on;
plot(v_esti); title('Velocity estimation based on IIR filtering');

figure; 
subplot(2,1,1); hold on; grid on;
plot(meas_data); scatter([1:1:100], X_buf(1,:), 5); title('Measured distance vs Estimated distance');
subplot(2,1,2); plot(X_buf(1,:)-meas_data);title('Difference between Measured distance vs Estimated distance');grid on;

