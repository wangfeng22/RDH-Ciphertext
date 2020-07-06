function [change_ori_I,LSB,LM] = Overflow(origin_I)
% ����˵��������ԭʼͼ��������Ϣ��������ԭʼͼ��
% ���룺origin_I��ԭʼͼ��
% �����change_ori_I������ͼ��,LSB��ԭʼͼ���������洢����Ϣ�����ص�LSB��,LM�������Ϣ��
change_ori_I = origin_I;
[row,col] = size(origin_I);
%% ͳ�������Ϣ
num = 0; %������������ظ���
Location = zeros(); %��¼λ��
for i=1:row %���һ��һ�п϶���Ƕ����Ϣ
    for j=1:col
        if origin_I(i,j) == 0 %�п������磬+1
            num = num+1;
            Location(num) = (i-1)*col + j; %λ����Ϣ
            change_ori_I(i,j) = 1;
        elseif origin_I(i,j) == 255 %�п������磬-1
            num = num+1;
            Location(num) = (i-1)*col + j; %λ����Ϣ
            change_ori_I(i,j) = 254;   
        end
    end
end
LM_loc = zeros(); %�������λ��
x = ceil(log2(row));
y = ceil(log2(col));
for i=1:num
    temp = Location(i);
    n = (i-1)*(x+y);
    for j=1:x+y
        LM_loc(n+j) = mod(temp,2);
        temp = floor(temp/2);
    end
end
LM_num = zeros(); %������ظ���
temp = num;
for i=1:x+y  %���row*colͼ����2^(x+y)������
    LM_num(i) = mod(temp,2);
    temp = floor(temp/2);
end
if num == 0
    LM = LM_num;
else
    LM = [LM_num,LM_loc];
end
%% �û�LSB����֤Ƕ����ȡ����ֵ��ͬ
LSB = zeros();
L = length(LM);
if L+138+(x+y) <= row %���һ���ܴ洢����Ϣ
    for i=1:L+138+(x+y)
        value = change_ori_I(i,col);
        LSB(i) = mod(value,2);
        change_ori_I(i,col) = value - LSB(i);
    end
else
    re = L-(row-138-x-y);
    for i=1:row
        value = change_ori_I(i,col);
        LSB(i) = mod(value,2);
        change_ori_I(i,col) = value - LSB(i);
    end
    for j=1:re %ʣ�µ������һ�д洢
        value = change_ori_I(row,j);
        LSB(row+j) = mod(value,2);
        change_ori_I(row,j) = value - LSB(row+j); 
    end
end
end