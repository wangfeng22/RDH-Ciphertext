function [Map_Bin] = Map_Binary(Map_origin_I,Code)
% ����˵������λ��ͼMap_origin_Iת���ɶ���������Map
% ���룺Map_origin_I��ԭʼͼ���λ��ͼ��,Code��ӳ���ϵ��
% �����Map_Bin��ԭʼͼ��λ��ͼ�Ķ��������飩
[row,col] = size(Map_origin_I); %����Map_origin_II������ֵ
Map_Bin = zeros();
t = 0; %����������������ĳ���
for i=1:row 
    for j=1:col
        if Map_origin_I(i,j) == -1 %��Ϊ-1�ĵ�����Ϊ�ο����أ���ͳ��
            continue;
        end
        for k=1:9
            if Map_origin_I(i,j) == Code(k,1)
                value = Code(k,2);
                break;
            end
        end
        if value == 0
            Map_Bin(t+1) = 0;
            Map_Bin(t+2) = 0;
            t = t+2;
        elseif value == 1
            Map_Bin(t+1) = 0;
            Map_Bin(t+2) = 1;
            t = t+2;
        else
            add = ceil(log2(value+1)); %��ʾ��Ǳ���ĳ���
            Map_Bin(t+1:t+add) = dec2bin(value)-'0'; %��valueת���ɶ���������
            t = t + add;
        end 
    end
end