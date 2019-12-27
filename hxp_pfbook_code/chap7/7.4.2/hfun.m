%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 版权声明：
%     本程序的详细中文注释请参考
%     黄小平，王岩，缪鹏程.粒子滤波原理及应用[M].电子工业出版社，2017.4
%     书中有原理介绍+例子+程序+中文注释
%     如果此程序有错误，请对提示修改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 程序说明： 观测方程函数
% 输入参数： x目标的状态，（x0,y0)是观测站的位置
% 输出参数： y是角度
function [y]=hfun(x,x0,y0)
 
if nargin < 3
    error('Not enough input arguments.'); 
end
[row,col]=size(x);
if row~=4|col~=1
    error('Input arguments error!');
end
xx=x(1)-x0;
yy=x(3)-y0;
y=atan2(yy,xx);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
