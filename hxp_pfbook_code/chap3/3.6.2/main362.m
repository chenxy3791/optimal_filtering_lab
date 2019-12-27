%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 文件名称：main362.m
% 功能说明：用于分析白噪声和有色噪声的频谱
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function main362 %--chenxy With this line, all variables become local variable
 %error('下面的参数L请参考书中的值设置，然后删除本行代码')
L=500;   
c=[1 0.5 0.2];   
d=[1 -1.5 0.7 0.1];
Nc=length(c)-1;    
Nd=length(d)-1 ;
XX=zeros(Nc,1);   
YY=zeros(Nd,1);
X=randn(L,1);   
Y=zeros(1,L);
for k=1:L
    Y(k)=-d(2:Nd+1)*YY+c*[X(k);XX];  
   
    for i=Nd:-1:2
        YY(i)=YY(i-1);
    end
    YY(1)=Y(k);
    for i=Nc:-1:2
        XX(i)=XX(i-1);
    end
    XX(1)=X(k);
end

Y2 = filter(c,d,X); % chenxy. This is equivalent to the above naive difference equation implementation.
 
[Fx,f1] = myFFT(X',512);
Px = 1/L * Fx.*conj(Fx);

  
[Fy,f2] = myFFT(Y,512);
Py = 1/L * Fy.*conj(Fy);
 
figure
subplot(2,1,1);
plot(X);
xlabel('k');ylabel('噪声幅值');title('白噪声序列');
subplot(2,1,2);
plot(Y);
xlabel('k');ylabel('噪声幅值');title('有色噪声序列');

 
figure
subplot(211)
plot(f1,Px)
xlabel('k');ylabel('白噪声频谱');
subplot(212)
plot(f2,Py)
xlabel('k');ylabel('有色噪声频谱');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



