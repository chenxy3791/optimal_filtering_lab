%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名称：main433.m
% 功能说明：从1-10个编号的球中有放回抽取3个，求抽到都为偶数的概率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main433
% error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=50;  
 
m=10000;
 
P=zeros(1,N);
 
for k=1:N % N realization
    disp(k);
    P(k)=fun(m);
end
 
Pave=mean(P)
 
figure
hold on;box on;
plot(P);
line([0,N],[Pave,Pave],'LineWidth',1,'Color','b');
xlabel('k');
ylabel('概率估计值');
 
p=0.5;
plot([1,N],[p^3,p^3],'r-','LineWidth',2);
legend('One time Experiment result','Ensemble average','Ground truth');

function p=fun(M)
 
frq=0;
 
MAX=10;
 
for k=1:M
 
    ball1=unidrnd(MAX);
    ball2=unidrnd(MAX);
    ball3=unidrnd(MAX);
 
    if( (mod(ball1,2)==0) &&  (mod(ball2,2)==0) && (mod(ball3,2)==0) )
 
        frq=frq+1;
    end
end
 
p=frq/M;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
