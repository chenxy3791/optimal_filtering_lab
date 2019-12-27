%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名称：main434.m
% 功能说明：模拟走出矿井实验
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main434
%error('下面的参数N请参考书中的值设置，然后删除本行代码')
N=10000;
  
Time=zeros(1,N);
for k=1:N
    if mod(k,1000) == 0    
        fprintf(1,'k = %d\n',k) ;
    end
    t=0;
    while(1)      
        number=randi(3); %getChannel();         
        if(number==1)       
            t=t+3;
            break;           
        else if(number==2)   
                t=t+5;
            else          
                t=t+7;
            end
        end
    end
 
    Time(k)=t;
end
 
TimerAve=mean(Time)
 
Tmax=max(Time)
 
Tmin=min(Time)
 
figure
hold on;box on;
plot(Time);
  
line([0,N],[TimerAve,TimerAve],'LineWidth',5,'Color','r');
xlabel('k');
ylabel('时间开销')
 
figure;
hist(Time,50); title('Histogram of time cost');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
