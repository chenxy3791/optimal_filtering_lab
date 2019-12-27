%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名称：main431.m
% 功能说明：硬币投掷实验，计算机模拟
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main431

p=0.6;
%error('下面的参数N请参考书中的值设置，然后删除本行代码') 
N=10000;
 
sum=0
 
for k=1:N
  
    sum=sum+binornd(1,p);
   
    P(k)=sum/k;
end
 
figure
hold on;box on;
plot(1:N,P);
plot([1,N],[p,p],'r-','LineWidth',2);
legend('Experiment result','Ground truth');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
