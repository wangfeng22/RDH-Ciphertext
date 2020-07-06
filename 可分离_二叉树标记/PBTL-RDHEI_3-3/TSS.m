function [r,x0] = TSS(Image_key)
% 函数说明：根据TSS（Tent-Sine system）产生初始参数
% 输入：Image_key（密钥）
% 输出：r,x0（初始参数）
%% 产生256个0/1序列
rand('seed',Image_key); %设置种子
Ke = round(rand(1,256)*1); %产生稳定随机数
%% 计算u1/u2/v1/v2
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
%% 计算x0/x1/x2/r0/r1/r2
x0 = u1/(2^90);
r0 = u2/(2^90);
x1 = mod((x0*u1*v1)/(2^80)+x0,1);
r1 = mod((r0*u1*v1)/(2^80)+r0,4);
x2 = mod((x1*u1*v1)/(2^80)+x1,1);
r2 = mod((r1*u1*v1)/(2^80)+r1,4);
%% 对r,x0赋值
r = 4 - r2;
x0 = x2;
end