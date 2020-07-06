function [stego_I,emD] = Embed_Data(encrypt_I,Map_origin_I,Side_Information,D,Data_key,ref_x,ref_y)
% ����˵��������λ��ͼ��������Ϣ��������ϢǶ�뵽����ͼ����
% ���룺encrypt_I������ͼ��,Map_origin_I��λ��ͼ��,Side_Information��������Ϣ��,D��������Ϣ��,Data_key�����ݼ�����Կ��,ref_x,ref_y���ο����ص���������
% �����stego_I�����ܱ��ͼ��,emD��Ƕ������ݣ�
stego_I = encrypt_I;
[row,col] = size(encrypt_I); %ͳ��encrypt_I��������
%% ��ԭʼ������ϢD���м���
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% ��ǰref_y�С�ǰref_x�еĲο����ؼ�¼����������������Ϣ֮ǰǶ��ͼ����
Refer_Value = zeros();
t = 0; %����
for i=1:row
    for j=1:ref_y  %ǰref_y��
        value = encrypt_I(i,j);
        [bin2_8] = Decimalism_Binary(value); %��ʮ��������ת����8λ����������
        Refer_Value(t+1:t+8) = bin2_8;
        t = t + 8; 
    end
end
for i=1:ref_x  %ǰref_x��
    for j=ref_y+1:col
        value = encrypt_I(i,j);
        [bin2_8] = Decimalism_Binary(value); %��ʮ��������ת����8λ����������
        Refer_Value(t+1:t+8) = bin2_8;
        t = t + 8; 
    end
end 
%% ������
num_D = length(D); %��������ϢD�ĳ���
num_emD = 0; %������ͳ��Ƕ��������Ϣ�ĸ���
num_S = length(Side_Information); %������ϢSide_Information�ĳ���
num_side = 0;%������ͳ��Ƕ�븨����Ϣ�ĸ���
num_RV = length(Refer_Value); %�ο����ض�����������Ϣ�ĳ���
num_re = 0; %������ͳ��Ƕ��ο����ض�����������Ϣ�ĳ���
%% ����ǰref_y�С�ǰref_x�еĲο������д洢������Ϣ
for i=1:row
    for j=1:ref_y  %ǰref_y��
        bin2_8 = Side_Information(num_side+1:num_side+8);
        [value] = Binary_Decimalism(bin2_8); %��8λ����������ת����ʮ��������
        stego_I(i,j) = value;
        num_side = num_side + 8;
    end
end
for i=1:ref_x  %ǰref_x��
    for j=ref_y+1:col
        bin2_8 = Side_Information(num_side+1:num_side+8);
        [value] = Binary_Decimalism(bin2_8); %��8λ����������ת����ʮ��������
        stego_I(i,j) = value;
        num_side = num_side + 8;
    end
end
%% ��������λ��Ƕ�븨����Ϣ���ο����غ���������
for i=ref_x+1:row  
    for j=ref_y+1:col 
        if num_emD >= num_D %����������Ƕ��
            break;
        end
        %------��ʾ������ص����Ƕ�� 1 bit��Ϣ------%
        if Map_origin_I(i,j) == 0  %Map=0��ʾԭʼ����ֵ�ĵ�1MSB����Ԥ��ֵ�෴
            if num_side < num_S %������Ϣû��Ƕ��
                num_side = num_side + 1;
                stego_I(i,j) = mod(stego_I(i,j),2^7) + Side_Information(num_side)*(2^7); %�滻1λMSB
            else
                if num_re < num_RV %�ο����ض�����������Ϣû��Ƕ��
                    num_re = num_re + 1;
                    stego_I(i,j) = mod(stego_I(i,j),2^7) + Refer_Value(num_re)*(2^7); %�滻1λMSB
                else %���Ƕ��������Ϣ
                    num_emD = num_emD + 1;
                    stego_I(i,j) = mod(stego_I(i,j),2^7) + Encrypt_D(num_emD)*(2^7); %�滻1λMSB
                end       
            end
        %------��ʾ������ص����Ƕ�� 2 bit��Ϣ------%
        elseif Map_origin_I(i,j) == 1  %Map=1��ʾԭʼ����ֵ�ĵ�2MSB����Ԥ��ֵ�෴  
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+2 <= num_S %2λMSB������Ƕ�븨����Ϣ
                    num_side = num_side + 2;
                    stego_I(i,j) = mod(stego_I(i,j),2^6) + Side_Information(num_side-1)*(2^7) + Side_Information(num_side)*(2^6); %�滻2λMSB
                else
                    num_side = num_side + 1; %1bit������Ϣ
                    num_re = num_re + 1; %1bit�ο����ض�����������Ϣ
                    stego_I(i,j) = mod(stego_I(i,j),2^6) + Side_Information(num_side)*(2^7) + Refer_Value(num_re)*(2^6); %�滻2λMSB
                end
            else
                if num_re < num_RV %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+2 <= num_RV %2λMSB������Ƕ��ο����ض�����������Ϣ   
                        num_re = num_re + 2;
                        stego_I(i,j) = mod(stego_I(i,j),2^6) + Refer_Value(num_re-1)*(2^7) + Refer_Value(num_re)*(2^6); %�滻2λMSB
                    else
                        num_re = num_re + 1; %1bit�ο����ض�����������Ϣ
                        num_emD = num_emD + 1; %1bit������Ϣ
                        stego_I(i,j) = mod(stego_I(i,j),2^6) + Refer_Value(num_re)*(2^7) + Encrypt_D(num_emD)*(2^6); %�滻2λMSB
                    end
                else
                    if num_emD+2 <= num_D
                        num_emD = num_emD + 2; %2bit������Ϣ
                        stego_I(i,j) = mod(stego_I(i,j),2^6) + Encrypt_D(num_emD-1)*(2^7) + Encrypt_D(num_emD)*(2^6); %�滻2λMSB
                    else
                        num_emD = num_emD + 1; %1bit������Ϣ
                        stego_I(i,j) = mod(stego_I(i,j),2^7) + Encrypt_D(num_emD)*(2^7); %�滻1λMSB
                    end   
                end
            end
        %------��ʾ������ص����Ƕ�� 3 bit��Ϣ------%
        elseif Map_origin_I(i,j) == 2  %Map=2��ʾԭʼ����ֵ�ĵ�3MSB����Ԥ��ֵ�෴
            bin2_8 = zeros(1,8); %������¼ҪǶ�����Ϣ������8λ�ĵ�λ(LSB)Ĭ��Ϊ0
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+3 <= num_S %3λMSB������Ƕ�븨����Ϣ
                    bin2_8(1:3) = Side_Information(num_side+1:num_side+3); 
                    num_side = num_side + 3;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^5) + value; %�滻3λMSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(1:t) = Side_Information(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(t+1:3) = Refer_Value(num_re+1:num_re+3-t); %(3-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 3-t;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^5) + value; %�滻3λMSB
                end
            else
                if num_re < num_RV  %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+3 <= num_RV %3λMSB������Ƕ��ο����ض�����������Ϣ
                        bin2_8(1:3) = Refer_Value(num_re+1:num_re+3); 
                        num_re = num_re + 3;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^5) + value; %�滻3λMSB
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        bin2_8(1:t) = Refer_Value(num_re+1:num_RV); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        bin2_8(t+1:3) = Encrypt_D(num_emD+1:num_emD+3-t); %(3-t)bit������Ϣ
                        num_emD = num_emD + 3-t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^5) + value; %�滻3λMSB
                    end 
                else
                    if num_emD+3 <= num_D
                        bin2_8(1:3) = Encrypt_D(num_emD+1:num_emD+3); %3bit������Ϣ 
                        num_emD = num_emD + 3;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^5) + value; %�滻3λMSB
                    else
                        t = num_D - num_emD; %ʣ��������Ϣ����
                        bin2_8(1:t) = Encrypt_D(num_emD+1:num_emD+t); %tbit������Ϣ
                        num_emD = num_emD + t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^(8-t)) + value; %�滻tλMSB
                    end 
                end
            end   
        %------��ʾ������ص����Ƕ�� 4 bit��Ϣ------%    
        elseif Map_origin_I(i,j) == 3  %Map=3��ʾԭʼ����ֵ�ĵ�4MSB����Ԥ��ֵ�෴
            bin2_8 = zeros(1,8); %������¼ҪǶ�����Ϣ������8λ�ĵ�λ(LSB)Ĭ��Ϊ0
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+4 <= num_S %4λMSB������Ƕ�븨����Ϣ
                    bin2_8(1:4) = Side_Information(num_side+1:num_side+4); 
                    num_side = num_side + 4;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^4) + value; %�滻4λMSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(1:t) = Side_Information(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(t+1:4) = Refer_Value(num_re+1:num_re+4-t); %(4-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 4-t;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^4) + value; %�滻4λMSB
                end
            else
                if num_re < num_RV  %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+4 <= num_RV %4λMSB������Ƕ��ο����ض�����������Ϣ
                        bin2_8(1:4) = Refer_Value(num_re+1:num_re+4); 
                        num_re = num_re + 4;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^4) + value; %�滻4λMSB
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        bin2_8(1:t) = Refer_Value(num_re+1:num_RV); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        bin2_8(t+1:4) = Encrypt_D(num_emD+1:num_emD+4-t); %(4-t)bit������Ϣ
                        num_emD = num_emD + 4-t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^4) + value; %�滻4λMSB
                    end 
                else
                    if num_emD+4 <= num_D
                        bin2_8(1:4) = Encrypt_D(num_emD+1:num_emD+4); %4bit������Ϣ 
                        num_emD = num_emD + 4;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^4) + value; %�滻4λMSB
                    else
                        t = num_D - num_emD; %ʣ��������Ϣ����
                        bin2_8(1:t) = Encrypt_D(num_emD+1:num_emD+t); %tbit������Ϣ
                        num_emD = num_emD + t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^(8-t)) + value; %�滻tλMSB
                    end 
                end
            end    
        %------��ʾ������ص����Ƕ�� 5 bit��Ϣ------%    
        elseif Map_origin_I(i,j) == 4 %Map=4��ʾԭʼ����ֵ�ĵ�5MSB����Ԥ��ֵ�෴
            bin2_8 = zeros(1,8); %������¼ҪǶ�����Ϣ������8λ�ĵ�λ(LSB)Ĭ��Ϊ0
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+5 <= num_S %5λMSB������Ƕ�븨����Ϣ
                    bin2_8(1:5) = Side_Information(num_side+1:num_side+5); 
                    num_side = num_side + 5;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^3) + value; %�滻5λMSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(1:t) = Side_Information(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(t+1:5) = Refer_Value(num_re+1:num_re+5-t); %(5-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 5-t;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^3) + value; %�滻5λMSB
                end
            else
                if num_re < num_RV  %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+5 <= num_RV %5λMSB������Ƕ��ο����ض�����������Ϣ
                        bin2_8(1:5) = Refer_Value(num_re+1:num_re+5); 
                        num_re = num_re + 5;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^3) + value; %�滻5λMSB
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        bin2_8(1:t) = Refer_Value(num_re+1:num_RV); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        bin2_8(t+1:5) = Encrypt_D(num_emD+1:num_emD+5-t); %(5-t)bit������Ϣ
                        num_emD = num_emD + 5-t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^3) + value; %�滻5λMSB
                    end 
                else
                    if num_emD+5 <= num_D
                        bin2_8(1:5) = Encrypt_D(num_emD+1:num_emD+5); %5bit������Ϣ 
                        num_emD = num_emD + 5;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^3) + value; %�滻5λMSB
                    else
                        t = num_D - num_emD; %ʣ��������Ϣ����
                        bin2_8(1:t) = Encrypt_D(num_emD+1:num_emD+t); %tbit������Ϣ
                        num_emD = num_emD + t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^(8-t)) + value; %�滻tλMSB
                    end 
                end
            end           
        %------��ʾ������ص����Ƕ�� 6 bit��Ϣ------%    
        elseif Map_origin_I(i,j) == 5  %Map=5��ʾԭʼ����ֵ�ĵ�6MSB����Ԥ��ֵ�෴
            bin2_8 = zeros(1,8); %������¼ҪǶ�����Ϣ������8λ�ĵ�λ(LSB)Ĭ��Ϊ0
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+6 <= num_S %6λMSB������Ƕ�븨����Ϣ
                    bin2_8(1:6) = Side_Information(num_side+1:num_side+6); 
                    num_side = num_side + 6;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^2) + value; %�滻6λMSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(1:t) = Side_Information(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(t+1:6) = Refer_Value(num_re+1:num_re+6-t); %(6-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 6-t;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^2) + value; %�滻6λMSB
                end
            else
                if num_re < num_RV  %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+6 <= num_RV %3λMSB������Ƕ��ο����ض�����������Ϣ
                        bin2_8(1:6) = Refer_Value(num_re+1:num_re+6); 
                        num_re = num_re + 6;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^2) + value; %�滻6λMSB
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        bin2_8(1:t) = Refer_Value(num_re+1:num_RV); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        bin2_8(t+1:6) = Encrypt_D(num_emD+1:num_emD+6-t); %(6-t)bit������Ϣ
                        num_emD = num_emD + 6-t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^2) + value; %�滻6λMSB
                    end 
                else
                    if num_emD+6 <= num_D
                        bin2_8(1:6) = Encrypt_D(num_emD+1:num_emD+6); %6bit������Ϣ 
                        num_emD = num_emD + 6;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^2) + value; %�滻6λMSB
                    else
                        t = num_D - num_emD; %ʣ��������Ϣ����
                        bin2_8(1:t) = Encrypt_D(num_emD+1:num_emD+t); %tbit������Ϣ
                        num_emD = num_emD + t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^(8-t)) + value; %�滻tλMSB
                    end 
                end
            end      
        %------��ʾ������ص����Ƕ�� 7 bit��Ϣ------%    
        elseif Map_origin_I(i,j) == 6  %Map=6��ʾԭʼ����ֵ�ĵ�7MSB����Ԥ��ֵ�෴
            bin2_8 = zeros(1,8); %������¼ҪǶ�����Ϣ������8λ�ĵ�λ(LSB)Ĭ��Ϊ0
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+7 <= num_S %7λMSB������Ƕ�븨����Ϣ
                    bin2_8(1:7) = Side_Information(num_side+1:num_side+7); 
                    num_side = num_side + 7;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^1) + value; %�滻7λMSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(1:t) = Side_Information(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(t+1:7) = Refer_Value(num_re+1:num_re+7-t); %(7-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 7-t;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = mod(stego_I(i,j),2^1) + value; %�滻7λMSB
                end
            else
                if num_re < num_RV  %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+7 <= num_RV %7λMSB������Ƕ��ο����ض�����������Ϣ
                        bin2_8(1:7) = Refer_Value(num_re+1:num_re+7); 
                        num_re = num_re + 7;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^1) + value; %�滻7λMSB
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        bin2_8(1:t) = Refer_Value(num_re+1:num_RV); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        bin2_8(t+1:7) = Encrypt_D(num_emD+1:num_emD+7-t); %(7-t)bit������Ϣ
                        num_emD = num_emD + 7-t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^1) + value; %�滻7λMSB
                    end 
                else
                    if num_emD+7 <= num_D
                        bin2_8(1:7) = Encrypt_D(num_emD+1:num_emD+7); %7bit������Ϣ 
                        num_emD = num_emD + 7;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^1) + value; %�滻7λMSB
                    else
                        t = num_D - num_emD; %ʣ��������Ϣ����
                        bin2_8(1:t) = Encrypt_D(num_emD+1:num_emD+t); %tbit������Ϣ
                        num_emD = num_emD + t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^(8-t)) + value; %�滻tλMSB
                    end 
                end
            end           
        %------��ʾ������ص����Ƕ�� 8 bit��Ϣ------%    
        elseif Map_origin_I(i,j) == 7 || Map_origin_I(i,j) == 8  %Map=7��ʾԭʼ����ֵ�ĵ�8MSB(LSB)����Ԥ��ֵ�෴
            bin2_8 = zeros(1,8); %������¼ҪǶ�����Ϣ������8λ�ĵ�λ(LSB)Ĭ��Ϊ0
            if num_side < num_S %������Ϣû��Ƕ��
                if num_side+8 <= num_S %8λMSB������Ƕ�븨����Ϣ
                    bin2_8(1:8) = Side_Information(num_side+1:num_side+8); 
                    num_side = num_side + 8;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %�滻8λMSB
                else
                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                    bin2_8(1:t) = Side_Information(num_side+1:num_S); %tbit������Ϣ
                    num_side = num_side + t;
                    bin2_8(t+1:8) = Refer_Value(num_re+1:num_re+8-t); %(8-t)bit�ο����ض�����������Ϣ
                    num_re = num_re + 8-t;
                    [value] = Binary_Decimalism(bin2_8);
                    stego_I(i,j) = value; %�滻8λMSB
                end
            else
                if num_re < num_RV  %�ο����ض�����������Ϣû��Ƕ��
                    if num_re+8 <= num_RV %8λMSB������Ƕ��ο����ض�����������Ϣ
                        bin2_8(1:8) = Refer_Value(num_re+1:num_re+8); 
                        num_re = num_re + 8;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = value; %�滻8λMSB
                    else
                        t = num_RV - num_re; %ʣ��ο����ض�����������Ϣ����
                        bin2_8(1:t) = Refer_Value(num_re+1:num_RV); %tbit�ο����ض�����������Ϣ
                        num_re = num_re + t;
                        bin2_8(t+1:8) = Encrypt_D(num_emD+1:num_emD+8-t); %(8-t)bit������Ϣ
                        num_emD = num_emD + 8-t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = value; %�滻8λMSB
                    end 
                else
                    if num_emD+8 <= num_D
                        bin2_8(1:8) = Encrypt_D(num_emD+1:num_emD+8); %8bit������Ϣ 
                        num_emD = num_emD + 8;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = value; %�滻8λMSB
                    else
                        t = num_D - num_emD; %ʣ��������Ϣ����
                        bin2_8(1:t) = Encrypt_D(num_emD+1:num_emD+t); %tbit������Ϣ
                        num_emD = num_emD + t;
                        [value] = Binary_Decimalism(bin2_8);
                        stego_I(i,j) = mod(stego_I(i,j),2^(8-t)) + value; %�滻tλMSB
                    end 
                end
            end         
        end
    end
end
%% ͳ��Ƕ�����������
emD = D(1:num_emD);
end