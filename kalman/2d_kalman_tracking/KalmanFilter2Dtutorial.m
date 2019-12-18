%Reference: 
%  Muhammad Alahdab: 2D Tracking Kalman Filter
%  NOTE: The notations in this program are slightly different from the orignal paper.

%2019-12-18 chenxy
%   Refinement for readability
%   Some minor correction for notation consistency with the paper

close all; clear; clc

Ts=0.1; %define the sample time
A=[1 0 0 Ts 0  0 ; ...
   0 1 0 0  Ts 0 ; ...
   0 0 1 0  0 Ts ; ...
   0 0 0 1  0  0 ; ...
   0 0 0 0  1  0 ; ...
   0 0 0 0  0  1]; %define the state matrix
C=[1 0 0 0  0  0 ; ...
   0 1 0 0  0  0 ; ...
   0 0 1 0  0  0]; %define the output matrix -- Only [x,y,theta] are measured.
B=[0.5*Ts^2 0        0; ...
   0        0.5*Ts^2 0; ...
   0        0        0.5*Ts^2; ...
   Ts       0        0; ...
   0       Ts        0; ...
   0        0        Ts]; %define the input matrix

x0=[0;0;0;0;0;0]; %define the initial conditions
sys =ss(A,B,eye(6),[],Ts); %define a system to generate true data
t=0:Ts:40; %define the time interval

%assuming that the uncertanities in the accelerations are equal, we define
%them as follow(In practice, these values are determined experimentally.):
%  ux -- ax, uy -- ay, alpha -- alpha
%  Acclerations represents external driving forces from outside.
segmaux=5; %standard deviation ax
segmauy=5; %standard deviation ay
segmaualpha=5; %standard deviation angular acceleration

%define the input(accelerations):
ux    = [zeros(1, 5) 70*ones(1,30) -20*ones(1,35) 15*ones(1,length(t)-70)]+normrnd(0,segmaux,1,length(t));
uy    = [zeros(1,10) 60*ones(1,60) -20*ones(1,length(t)-70)]+normrnd(0,segmauy,1,length(t));
ualpha= [zeros(1,30) 25*ones(1,20) -20*ones(1,20) 15*ones(1,length(t)-70)]+normrnd(0,segmaualpha,1,length(t));
u     = [ux;uy;ualpha]; % Each column represents one time instant.

%generating the true data:
Xtrue  = lsim(sys,u,t,x0);
xtrue  = Xtrue(:,1);
ytrue  = Xtrue(:,2);
thtrue = Xtrue(:,3);
vxtrue = Xtrue(:,4);
vytrue = Xtrue(:,5);
wtrue  = Xtrue(:,6);

%defining V: measurement noise variances
V   = [200.^2 0 0; 0 200.^2 0; 0 0 300.^2];

%generating measurment data by adding noise to the true data:
xm  = xtrue  + normrnd(0,200,length(xtrue),1);
ym  = ytrue  + normrnd(0,200,length(ytrue),1);
thm = thtrue + normrnd(0,300,length(ytrue),1);
%initializing the matricies for the for loop (this will make the matlab run
%the for loop faster.
Xest=zeros(6,length(t));
Xest(:,1)=x0;
%defining R and Q
%R: measurement covariance matrix
%Q: system state transition covariance matrix
R  = V*C*C';
Qb = [segmaux.^2 0 0 ; 0 segmauy.^2 0 ;0 0 segmaualpha.^2]; 
Q  = B*Qb*B';
%Initializing P 
P  = Q; 

%Iteration.
for(i=2:1:length(t))
    % Prediction stage
    P        = A*P*A'+ Q; %Prior prediction of P(i)
    Xest(:,i)= A*Xest(:,i-1)+B*u(:,i-1); %Prior prediction of the state X(i)
    
    % Update the Kalman gain
    K        = P*C'/(C*P*C'+R); %calculating the Kalman gains
    
    % Update the Posterior State estimation and also P.
    Xest(:,i)= Xest(:,i)+K*([xm(i); ym(i); thm(i)]-C*Xest(:,i)); %Correcting: estimating the state
    P        = (eye(6)-K*C)*P; %Correcting: estimating P
end

%%Visualization of result.
figure
subplot(311)
    plot(t,Xest(1,:),'r',t,xm,'g',t,xtrue,'b')
    xlabel('time [sec]');
    ylabel('displacementx [m]');
    title('displacementx');
    legend('estimated displacementx','measured displacementx','true displacementx');
subplot(312)
    plot(t,Xest(2,:),'r',t,ym,'g',t,ytrue,'b')
    xlabel('time [sec]');
    ylabel('displacementy [m]');
    title('displacementy');
    legend('estimated displacementy','measured displacementy','true displacementy');
subplot(313)
    plot(t,Xest(3,:),'r',t,thm,'g',t,thtrue,'b')
    xlabel('time [sec]');
    ylabel('angle');
    title('angle theta');
    legend('estimated angle theta','measured angle theta','true angle theta');

figure
hold on 
%simple animation:
for i=1:1:length(t)
    axis([min(xtrue)-500 max(xtrue)+500 min(ytrue)-500 max(ytrue)+500]);
    %viscircles([xtrue(i) ytrue(i)],20,'color','b')
    %viscircles([Xest(1,i) Xest(2,i)],20,'color','r')
    plot(xtrue(i),ytrue(i),'b.-');
    plot(Xest(1,i),Xest(2,i),'ro');
    plot(xm(i),ym(i),'k+:');
    pause(0.1)
end
legend('True trajectory', 'Estimated trajectory', 'Measured trajectory');
