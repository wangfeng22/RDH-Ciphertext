function [Side_Information,Refer_Value,Encrypt_exD,Map_I,sign] = Extract_Data(stego_I,num,ref_x,ref_y)
% ����˵�����ڼ��ܱ��ͼ������ȡ��Ϣ
% ���룺stego_I�����ܱ��ͼ��,num��������Ϣ�ĳ��ȣ�,ref_x,ref_y���ο����ص���������
% �����Side_Information��������Ϣ��,Refer_Value���ο�������Ϣ��,Encrypt_exD�����ܵ�������Ϣ��,Map_I��λ��ͼ��,sign���жϱ�ǣ�
[row,col]=size(stego_I); %ͳ��stego_I��������
%% �����洢λ��ͼ�ľ���
Map_I = zeros(row,col); %�����洢λ��ͼ�ľ���
for i=1:row
    for j=1:ref_y
        Map_I(i,j) = -1; %ǰ��ref_y��Ϊ�ο����أ������б��
    end
end
for i=1:ref_x
    for j=ref_y+1:col       
        Map_I(i,j) = -1; %ǰ��ref_x��Ϊ�ο����أ������б��   
    end
end
%% ����ȡǰref_y�С�ǰref_x���еĸ�����Ϣ
Side_Information = zeros();
num_side = 0;%������ͳ����ȡ������Ϣ�ĸ���
for i=1:row
    for j=1:ref_y
        value = stego_I(i,j);
        [bin2_8] = Decimalism_Binary(value); %��ʮ��������ת����8λ����������
        Side_Information(num_side+1:num_side+8) = bin2_8;
        num_side = num_side + 8;  
    end
end
for i=1:ref_x
    for j=ref_y+1:col
        value = stego_I(i,j);
        [bin2_8] = Decimalism_Binary(value); %��ʮ��������ת����8λ����������
        Side_Information(num_side+1:num_side+8) = bin2_8;
        num_side = num_side + 8; 
    end
end
%% ��ȡ����ӳ�����ĸ�����Ϣ
Code_Bin = Side_Information(1:32); %ǰ32λ��ӳ�������Ϣ
Code = [0,-1;1,-1;2,-1;3,-1;4,-1;5,-1;6,-1;7,-1;8,-1];
this_end = 0;
for i=1:9 %������������ӳ��ת��������ӳ��
    last_end = this_end;
    [code_value,this_end] = Huffman_DeCode(Code_Bin,last_end);
    Code(i,2) = code_value;
end
%% ��ȡλ��ͼ���������еĳ�����Ϣ
max = ceil(log2(row)) + ceil(log2(col)) + 2; %����ô���Ķ����Ʊ�ʾMap_Iת���ɶ��������еĳ���
len_Bin = Side_Information(33:32+max); %ǰ33��32+maxλ��λ��ͼ���������еĳ�����Ϣ
num_Map = 0; %������������len_Binת����ʮ������
for i=1:max
    num_Map = num_Map + len_Bin(i)*(2^(max-i));
end
%% ������
num_S = 32 + max + num_Map; %������Ϣ����
Refer_Value = zeros();
num_RV = (ref_x*row+ref_y*col-ref_x*ref_y)*8; %�ο����ض�����������Ϣ�ĳ���
num_re = 0; %������ͳ����ȡ�ο����ض�����������Ϣ�ĳ���
Encrypt_exD = zeros();
num_D = num; %������������Ϣ�ĳ���
num_exD = 0; %������ͳ��Ƕ��������Ϣ�ĸ���
%% ��ǰ���ж���֮���λ����ȡ��Ϣ
this_end = 32 + max; %ǰ��ĸ�����Ϣ����λ��ͼ
sign = 1; %��ʾ������ȫ��ȡ���ݻָ�ͼ��
for i=ref_x+1:row
    if sign == 0 %��ʾ������ȫ��ȡ���ݻָ�ͼ��
        break;
    end
    for j=ref_y+1:col
        if num_exD >= num_D %������������ȡ���
            break;
        end
        %------����ǰʮ��������ֵת����8λ����������------%
        value = stego_I(i,j); 
        [bin2_8] = Decimalism_Binary(value); 
        %--ͨ��������Ϣ���㵱ǰ���ص�����ȡ����bit����Ϣ--%
        last_end = this_end;
        [map_value,this_end] = Huffman_DeCode(Side_Information,last_end);
        if map_value == -1 %��ʾ������Ϣ���Ȳ������޷��ָ���һ��Huffman����
            sign = 0;
            break; 
        end
        for k=1:9
            if map_value == Code(k,2)
                Map_I(i,j) = Code(k,1); %��ǰ���ص�λ��ͼ��Ϣ
                break;
            end
        end
        %--------��ʾ������ص������ȡ 1 bit��Ϣ--------%
        if Map_I(i,j) == 0  %Map=0��ʾԭʼ����ֵ�ĵ�1MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                num_side = num_side + 1;
                Side_Information(num_side) = bin2_8(1);
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    num_re = num_re + 1;
                    Refer_Value(num_re) = bin2_8(1);
                else %�����ȡ������Ϣ
                    num_exD = num_exD + 1;
                    Encrypt_exD(num_exD) = bin2_8(1);
                end
            end
        %--------��ʾ������ص������ȡ 2 bit��Ϣ--------%
        elseif Map_I(i,j) == 1 %Map=1��ʾԭʼ����ֵ�ĵ�2MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+2 <= num_S %2λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+2) = bin2_8(1:2);
                    num_side = num_side + 2;
                else
                    num_side = num_side + 1; %1bit������Ϣ
                    Side_Information(num_side) = bin2_8(1);
                    num_re = num_re + 1; %1bit�ο����ض�����������Ϣ
                    Refer_Value(num_re) = bin2_8(2);                   
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+2 <= num_RV %2λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+2) = bin2_8(1:2);
                        num_re = num_re + 2;
                    else
                        num_re = num_re + 1; %1bit�ο����ض�����������Ϣ
                        Refer_Value(num_re) = bin2_8(1);  
                        num_exD = num_exD + 1; %1bit������Ϣ
                        Encrypt_exD(num_exD) = bin2_8(2);
                    end
                else
                    if num_exD+2 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+2) = bin2_8(1:2); %2bit������Ϣ
                        num_exD = num_exD + 2;
                    else
                        num_exD = num_exD + 1; %1bit������Ϣ
                        Encrypt_exD(num_exD) = bin2_8(1);
                    end
                end
            end 
        %--------��ʾ������ص������ȡ 3 bit��Ϣ--------%
        elseif Map_I(i,j) == 2  %Map=2��ʾԭʼ����ֵ�ĵ�3MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+3 <= num_S %3λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+3) = bin2_8(1:3);
                    num_side = num_side + 3;
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    Side_Information(num_side+1:num_side+t) = bin2_8(1:t); %tbit������Ϣ
                    num_side = num_side + t;
                    Refer_Value(num_re+1:num_re+3-t) = bin2_8(t+1:3); %(3-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 3-t;                 
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+3 <= num_RV %3λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+3) = bin2_8(1:3);
                        num_re = num_re + 3;
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        Refer_Value(num_re+1:num_re+t) = bin2_8(1:t); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        Encrypt_exD(num_exD+1:num_exD+3-t) = bin2_8(t+1:3); %(3-t)bit������Ϣ
                        num_exD = num_exD + 3-t;
                    end
                else
                    if num_exD+3 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+3) = bin2_8(1:3); %3bit������Ϣ
                        num_exD = num_exD + 3;
                    else
                        t = num_D - num_exD;
                        Encrypt_exD(num_exD+1:num_exD+t) = bin2_8(1:t); %tbit������Ϣ
                        num_exD = num_exD + t; 
                    end
                end
            end
        %--------��ʾ������ص������ȡ 4 bit��Ϣ--------%
        elseif Map_I(i,j) == 3  %Map=3��ʾԭʼ����ֵ�ĵ�4MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+4 <= num_S %4λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+4) = bin2_8(1:4);
                    num_side = num_side + 4;
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    Side_Information(num_side+1:num_side+t) = bin2_8(1:t); %tbit������Ϣ
                    num_side = num_side + t;
                    Refer_Value(num_re+1:num_re+4-t) = bin2_8(t+1:4); %(4-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 4-t;                 
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+4 <= num_RV %4λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+4) = bin2_8(1:4);
                        num_re = num_re + 4;
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        Refer_Value(num_re+1:num_re+t) = bin2_8(1:t); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        Encrypt_exD(num_exD+1:num_exD+4-t) = bin2_8(t+1:4); %(4-t)bit������Ϣ
                        num_exD = num_exD + 4-t;
                    end
                else
                    if num_exD+4 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+4) = bin2_8(1:4); %4bit������Ϣ
                        num_exD = num_exD + 4;
                    else
                        t = num_D - num_exD;
                        Encrypt_exD(num_exD+1:num_exD+t) = bin2_8(1:t); %tbit������Ϣ
                        num_exD = num_exD + t; 
                    end
                end
            end
        %--------��ʾ������ص������ȡ 5 bit��Ϣ--------%
        elseif Map_I(i,j) == 4  %Map=4��ʾԭʼ����ֵ�ĵ�5MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+5 <= num_S %5λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+5) = bin2_8(1:5);
                    num_side = num_side + 5;
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    Side_Information(num_side+1:num_side+t) = bin2_8(1:t); %tbit������Ϣ
                    num_side = num_side + t;
                    Refer_Value(num_re+1:num_re+5-t) = bin2_8(t+1:5); %(5-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 5-t;                 
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+5 <= num_RV %5λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+5) = bin2_8(1:5);
                        num_re = num_re + 5;
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        Refer_Value(num_re+1:num_re+t) = bin2_8(1:t); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        Encrypt_exD(num_exD+1:num_exD+5-t) = bin2_8(t+1:5); %(5-t)bit������Ϣ
                        num_exD = num_exD + 5-t;
                    end
                else
                    if num_exD+5 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+5) = bin2_8(1:5); %5bit������Ϣ
                        num_exD = num_exD + 5;
                    else
                        t = num_D - num_exD;
                        Encrypt_exD(num_exD+1:num_exD+t) = bin2_8(1:t); %tbit������Ϣ
                        num_exD = num_exD + t; 
                    end
                end
            end
            %--------��ʾ������ص������ȡ 6 bit��Ϣ--------%
        elseif Map_I(i,j) == 5  %Map=5��ʾԭʼ����ֵ�ĵ�6MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+6 <= num_S %6λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+6) = bin2_8(1:6);
                    num_side = num_side + 6;
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    Side_Information(num_side+1:num_side+t) = bin2_8(1:t); %tbit������Ϣ
                    num_side = num_side + t;
                    Refer_Value(num_re+1:num_re+6-t) = bin2_8(t+1:6); %(6-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 6-t;                 
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+6 <= num_RV %6λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+6) = bin2_8(1:6);
                        num_re = num_re + 6;
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        Refer_Value(num_re+1:num_re+t) = bin2_8(1:t); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        Encrypt_exD(num_exD+1:num_exD+6-t) = bin2_8(t+1:6); %(6-t)bit������Ϣ
                        num_exD = num_exD + 6-t;
                    end
                else
                    if num_exD+6 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+6) = bin2_8(1:6); %6bit������Ϣ
                        num_exD = num_exD + 6;
                    else
                        t = num_D - num_exD;
                        Encrypt_exD(num_exD+1:num_exD+t) = bin2_8(1:t); %tbit������Ϣ
                        num_exD = num_exD + t; 
                    end
                end
            end
            %--------��ʾ������ص������ȡ 7 bit��Ϣ--------%
        elseif Map_I(i,j) == 6  %Map=6��ʾԭʼ����ֵ�ĵ�7MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+7 <= num_S %7λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+7) = bin2_8(1:7);
                    num_side = num_side + 7;
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    Side_Information(num_side+1:num_side+t) = bin2_8(1:t); %tbit������Ϣ
                    num_side = num_side + t;
                    Refer_Value(num_re+1:num_re+7-t) = bin2_8(t+1:7); %(7-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 7-t;                 
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+7 <= num_RV %7λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+7) = bin2_8(1:7);
                        num_re = num_re + 7;
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        Refer_Value(num_re+1:num_re+t) = bin2_8(1:t); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        Encrypt_exD(num_exD+1:num_exD+7-t) = bin2_8(t+1:7); %(7-t)bit������Ϣ
                        num_exD = num_exD + 7-t;
                    end
                else
                    if num_exD+7 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+7) = bin2_8(1:7); %7bit������Ϣ
                        num_exD = num_exD + 7;
                    else
                        t = num_D - num_exD;
                        Encrypt_exD(num_exD+1:num_exD+t) = bin2_8(1:t); %tbit������Ϣ
                        num_exD = num_exD + t; 
                    end
                end
            end
            %--------��ʾ������ص������ȡ 8 bit��Ϣ--------%
        elseif Map_I(i,j) == 7 || Map_I(i,j) == 8  %Map=7��ʾԭʼ����ֵ�ĵ�8MSB(LSB)����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû����ȡ���
                if num_side+8 <= num_S %8λMSB���Ǹ�����Ϣ
                    Side_Information(num_side+1:num_side+8) = bin2_8(1:8);
                    num_side = num_side + 8;
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    Side_Information(num_side+1:num_side+t) = bin2_8(1:t); %tbit������Ϣ
                    num_side = num_side + t;
                    Refer_Value(num_re+1:num_re+8-t) = bin2_8(t+1:8); %(8-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 8-t;                 
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû����ȡ���
                    if num_re+8 <= num_RV %8λMSB���ǲο����ض�����������Ϣ
                        Refer_Value(num_re+1:num_re+8) = bin2_8(1:8);
                        num_re = num_re + 8;
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        Refer_Value(num_re+1:num_re+t) = bin2_8(1:t); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        Encrypt_exD(num_exD+1:num_exD+8-t) = bin2_8(t+1:8); %(8-t)bit������Ϣ
                        num_exD = num_exD + 8-t;
                    end
                else
                    if num_exD+8 <= num_D
                        Encrypt_exD(num_exD+1:num_exD+8) = bin2_8(1:8); %8bit������Ϣ
                        num_exD = num_exD + 8;
                    else
                        t = num_D - num_exD;
                        Encrypt_exD(num_exD+1:num_exD+t) = bin2_8(1:t); %tbit������Ϣ
                        num_exD = num_exD + t; 
                    end
                end
            end 
        end
    end
end
end