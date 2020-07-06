function [Code,Code_Bin] = Huffman_Code(num_Map_origin_I)
% ����˵�����ñ䳤����(��λ0/1����)��ʾ����ֵ�ı�����
% ���룺num_Map_origin_I������ֵ�������ͳ�������
% �����Code��ӳ���ϵ��,Code_Bin��Code�Ķ����Ʊ�ʾ��
% ��ע����{00,01,100,101,1100,1101,1110,11110,11111}��9�б�������ʾ9�ֱ�����
% ���򣺱����������صĸ���Խ�࣬��������ʾ�����ı��볤��Խ��
% {00,01,100,101,1100,1101,1110,11110,11111}��{0,1,4,5,12,13,14,30,31}
%% ����ӳ������ϵ
Code = [-1,0;-1,1;-1,4;-1,5;-1,12;-1,13;-1,14;-1,30;-1,31];
for i=1:9
    drder=1;
    for j=1:9
        if num_Map_origin_I(i,2) < num_Map_origin_I(j,2)
            drder = drder + 1;
        end
    end
    while Code(drder) ~= -1 %��ֹ���ֱ����������صĸ������
        drder = drder + 1; 
    end
    Code(drder,1) = num_Map_origin_I(i,1);
end
%% ��Mapӳ���ϵ�ö����Ʊ�������ʾ
Code_Bin = zeros();
t = 0; %����
for i=0:8
    for j=1:9
        if Code(j,1) == i
            value = Code(j,2);
        end
    end
    if value == 0
        Code_Bin(t+1) = 0;
        Code_Bin(t+2) = 0;
        t = t+2;
    elseif value == 1
        Code_Bin(t+1) = 0;
        Code_Bin(t+2) = 1;
        t = t+2;
    else 
        add = ceil(log2(value+1)); %��ʾ��Ǳ���ĳ���
        Code_Bin(t+1:t+add) = dec2bin(value)-'0'; %��valueת���ɶ���������
        t = t + add;
    end     
end
end
