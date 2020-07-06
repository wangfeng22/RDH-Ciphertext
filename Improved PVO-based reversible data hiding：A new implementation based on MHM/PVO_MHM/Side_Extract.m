function [recover_I_0,opt_R_S,context,index,end_x,end_y,LM] = Side_Extract(stego_I)
% ����˵������ȡ������Ϣ�����ָ��õ�����������Ϣ������ͼ��
% ���룺stego_I�����и�����Ϣ������ͼ��
% �����recover_I_0������������Ϣ������ͼ��,opt_R_S���Ż�������,context��Ԥ�����ظ�����,index�����Ų���������������,(end_x,end_y)������λ�ã�,LM�������Ϣ��
[row,col] = size(stego_I);
x = ceil(log2(row));
y = ceil(log2(col));
%% ��ȡ�Ż�����(128 bits)��opt_R_S
opt_R_S = zeros(2,32); %�Ż�����(128 bits)��opt_R_S 
for i=1:+2:128  %2 bits��ʾһ��ֵ��0:00��1:01��-1:10��-2:11��
    bit1 = mod(stego_I(i,col),2);
    bit2 = mod(stego_I(i+1,col),2);
    if i <= 64 %ǰ64λ��ʾ32���Ż�����r(32)
        t = round(i/2);
        if bit1==0 && bit2==0 % 00��ʾ0
            opt_R_S(1,t) = 0;
        elseif bit1==0 && bit2==1 % 01��ʾ1
            opt_R_S(1,t) = 1;   
        elseif bit1==1 && bit2==0 % 10��ʾ-1
            opt_R_S(1,t) = -1;      
        elseif bit1==1 && bit2==1 % 11��ʾ-2
            opt_R_S(1,t) = -2;
        end   
    else %��64λ��ʾ32���Ż�����s(32)
        t = round((i-64)/2);
        if bit1==0 && bit2==0 % 00��ʾ0
            opt_R_S(2,t) = 0;
        elseif bit1==0 && bit2==1 % 01��ʾ1
            opt_R_S(2,t) = 1;   
        elseif bit1==1 && bit2==0 % 10��ʾ-1
            opt_R_S(2,t) = -1;      
        elseif bit1==1 && bit2==1 % 11��ʾ-2
            opt_R_S(2,t) = -2;
        end 
    end
end
%% ��ȡԤ�����ظ���(4 bits)��context��[2,15]
context = 0;
for i=1:4
    bit = mod(stego_I(i+128,col),2);
    context = context + bit*(2^(i-1));
end
%% ��ȡ���Ų�������������(6 bits)��index
index = 0;
for i=1:6
    bit = mod(stego_I(i+128+4,col),2);
    index = index + bit*(2^(i-1));
end
%% ��ȡ����λ��(x+y bits)��(end_x,end_y)
end_x = 0;
end_y = 0;
for i=1:x
    bit = mod(stego_I(i+128+4+6,col),2);
    end_x = end_x + bit*(2^(i-1));
end
for i=1:y
    bit = mod(stego_I(i+128+4+6+x,col),2);
    end_y = end_y + bit*(2^(i-1));
end
%% ��ȡ�����Ϣ(len bits)��LM
LM = zeros();
num = 0; %��¼���������صĸ���
sum = 128+4+6+x+y; %���һ�����Ѿ���ȡ��Ϣ�����ظ���
for i=1:x+y
    bit = mod(stego_I(i+sum,col),2);
    LM(i) = bit;
    num = num + bit*(2^(i-1)); 
end
if num ~= 0
    len = (x+y) * num;
    if sum+x+y+len <= row %ֻ�����һ����ȡ��Ϣ
        for i=1:len
            bit = mod(stego_I(i+sum+x+y,col),2);
            LM(i+x+y) = bit;
        end
    else  %�����һ��һ�ж���ȡ��Ϣ
        for i=1:row-sum-x-y
            bit = mod(stego_I(i+sum+x+y,col),2);
            LM(i+x+y) = bit;    
        end
        for j=1:len-(row-sum-x-y)
            bit = mod(stego_I(row,j),2);
            LM(j+row-sum) = bit; 
        end
    end
end
%% �ָ�����������Ϣ������ͼ��
recover_I_0 = stego_I;
len = (x+y) * num;
if sum+x+y+len <= row %ֻ�����һ�д洢�˸�����Ϣ
    for i=1:sum+x+y+len
        value = recover_I_0(i,col);
        bit = mod(value,2);
        recover_I_0(i,col) = value - bit;
    end
else
    re = sum+x+y+len-row;
    for i=1:row
        value = recover_I_0(i,col);
        bit = mod(value,2);
        recover_I_0(i,col) = value - bit;
    end
    for j=1:re
        value = recover_I_0(row,j);
        bit = mod(value,2);
        recover_I_0(row,j) = value - bit; 
    end
end
end