%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ����Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ������+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ˵�������㶨����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function main444
 
a=0;  
b=1;
 error('����Ĳ���N��ο����е�ֵ���ã�Ȼ��ɾ�����д���')
N=0; 
fun(a,b,N);
 
function result=fun(a,b,mm)
 
sum=0;
urandnum = unifrnd(a,b,1,mm);
xrandnum = -1+sqrt(1+3.*unifrnd(a,b,1,mm));
for ii=1:mm
    sum=sum+exp (xrandnum(1,ii))/(1+ xrandnum(1,ii));
end    
result=1.5*sum/mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%