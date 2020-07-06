function [stego_I_1] = Side_Embed(stego_I_0,opt_R_S,context,index,end_x,end_y,LM)
% ����˵������������ϢǶ�뵽����ͼ������һ��һ��
% ���룺stego_I_0������ͼ��,opt_R_S���Ż�������,context��Ԥ�����ظ�����,index�����Ų���������������,(end_x,end_y)������λ�ã�,LM�������Ϣ��
% �����stego_I_1�����и�����Ϣ������ͼ��
[row,col] = size(stego_I_0);
%% ��0/1 bit��¼������Ϣ
x = ceil(log2(row));
y = ceil(log2(col));
len = length(LM);
Side = zeros(); %��138+(x+y)+len bits�ĸ�����Ϣ(128+4+6+(x+y)+len)
s = 0; %����
%% ��¼�Ż�����(128 bits)��opt_R_S
for i=1:2  
    for j=1:32
        opt = opt_R_S(i,j); %ֻ��-2��-1��0��1�ĸ�ֵ
        if opt == 0  % 2 bit��ʾ��00 
            Side(s+1) = 0;
            Side(s+2) = 0;
        elseif opt == 1 % 2 bit��ʾ��01
            Side(s+1) = 0;
            Side(s+2) = 1;
        elseif opt == -1 % 2 bit��ʾ��10
            Side(s+1) = 1;
            Side(s+2) = 0;
        elseif opt == -2 % 2 bit��ʾ��11
            Side(s+1) = 1;
            Side(s+2) = 1;
        end  
        s = s + 2;
    end
end
%% ��¼Ԥ�����ظ���(4 bits)��context��[2,15]
temp1 = context; 
for i=1:4 
    Side(s+i) = mod(temp1,2);
    temp1 = floor(temp1/2);
end
s = s + 4;
%% ��¼���Ų�������������(6 bits)��index
temp2 = index;
for i=1:6 
    Side(s+i) = mod(temp2,2);
    temp2 = floor(temp2/2);
end
s = s + 6;
%% ��¼����λ��(x+y bits)��(end_x,end_y)
temp3 = end_x;
for i=1:x 
    Side(s+i) = mod(temp3,2);
    temp3 = floor(temp3/2);
end
s = s + x;
temp4 = end_y;
for i=1:y 
    Side(s+i) = mod(temp4,2);
    temp4 = floor(temp4/2);
end
s = s + y;
%% ��¼�����Ϣ(len bits)��LM
for i=1:len
    Side(s+i) = LM(i);
end
s = s + len;
%% Ƕ�븨����Ϣ
stego_I_1 = stego_I_0;
if s <= row %���һ���ܴ洢����Ϣ
    for i=1:s
        stego_I_1(i,col) = stego_I_1(i,col) + Side(i);
    end  
else
    re = s-row;
    for i=1:row
        stego_I_1(i,col) = stego_I_1(i,col) + Side(i);
    end
    for j=1:re %ʣ�µ������һ�д洢
        stego_I_1(row,j) = stego_I_1(row,j) + Side(row+j); 
    end
end
end