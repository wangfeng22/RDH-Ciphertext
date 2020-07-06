function [r,x0] = TSS(Image_key)
% ����˵��������TSS��Tent-Sine system��������ʼ����
% ���룺Image_key����Կ��
% �����r,x0����ʼ������
%% ����256��0/1����
rand('seed',Image_key); %��������
Ke = round(rand(1,256)*1); %�����ȶ������
%% ����u1/u2/v1/v2
u1 = 0;
for i=1:64
    u1 = u1 + Ke(i)*(2^(64-i));
end
u2 = 0;
for i=65:128
    u2 = u2 + Ke(i)*(2^(128-i));
end
v1 = 0;
for i=129:192
    v1 = v1 + Ke(i)*(2^(192-i));
end
v2 = 0;
for i=193:256
    v2 = v2 + Ke(i)*(2^(256-i));
end
%% ����x0/x1/x2/r0/r1/r2
x0 = u1/(2^90);
r0 = u2/(2^90);
x1 = mod((x0*u1*v1)/(2^80)+x0,1);
r1 = mod((r0*u1*v1)/(2^80)+r0,4);
x2 = mod((x1*u1*v1)/(2^80)+x1,1);
r2 = mod((r1*u1*v1)/(2^80)+r1,4);
%% ��r,x0��ֵ
r = 4 - r2;
x0 = x2;
end