function [stego_I,emD,num_emD] = Embed_Data(encrypt_I,D,Data_key,pa_1,pa_2)
% ����˵�����ڼ���ͼ��encrypt_I��Ƕ������
% ���룺encrypt_I������ͼ��,D���������ݣ�,Data_key�����ݼ�����Կ��,pa_1,pa_2��������
% �����stego_I������ͼ��,emD��Ƕ����������ݣ�,num_emD��Ƕ���������ݵĸ�����
[row,col] = size(encrypt_I); %����encrypt_I������ֵ
%% ��ԭʼ������ϢD���м���
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% ������
m = floor(row/2);
n = floor(col/2);
num_D = length(Encrypt_D); %��������ϢD�ĳ���
num_emD = 0; %������ͳ��Ƕ��������Ϣ�ĸ���
%% �Լ���ͼ��encrypt_I���б��
[mark_I,PE_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(encrypt_I,pa_1,pa_2);
%% ��Ԥ������Ӧ�ı��
stego_I = mark_I;  %�����洢����ͼ�������
mark_Block = zeros(2,2); %������¼2*2��Ƿֿ������
pe_Block = zeros(2,2); %������¼2*2�ֿ����ص�Ԥ�����
num_S = length(Side_Info); %������ϢSide_Info�ĳ���
num_side = 0; %��������¼Ƕ�븨����Ϣ�ĸ���
for i=1:m
    for j=1:n 
        if num_emD >= num_D %����������Ƕ�����
            break;
        end
        %---------------------------���Ӧ��Ƿֿ�-------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                mark_Block(row_B,col_B) = mark_I(x,y);
                pe_Block(row_B,col_B) = PE_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %--------------------�ڱ�Ƿֿ��������Ƕ������---------------------%
        stego_Block = mark_Block; %������¼���ֿܷ������ 
        if i==1 && j==1 %��һ���ֿ�����һ���������أ������洢����
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %�ο����أ�����
                        continue;
                    elseif x==1 && y==2 %�������أ�����
                        continue;
                    else
                        value = mark_Block(x,y); %��ǰ�������ֵ
                        [bin2_8] = Decimalism_Binary(value); %��ǰ�������ֵ��Ӧ��8λ������
                        pe = pe_Block(x,y); %��ǰ���ص�Ԥ�����
                        if pe>=pe_min && pe<=pe_max  %��Ƕ��������أ���Ƕ��(8-pa_1)����
                            if num_side < num_S %������Ϣû��Ƕ��
                                if num_side+8-pa_1 <= num_S %(8-pa_1)���ض�����Ƕ�븨����Ϣ
                                    bin2_8(pa_1+1:8) = Side_Info(num_side+1:num_side+8-pa_1); 
                                    num_side = num_side + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                else
                                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                                    bin2_8(pa_1+1:pa_1+t) = Side_Info(num_side+1:num_S); %tbit������Ϣ
                                    num_side = num_side + t;
                                    bin2_8(pa_1+t+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1-t); %(8-pa_1-t)bit��������
                                    num_emD = num_emD + 8-pa_1-t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                end
                            else %������ϢǶ��֮����Ƕ����������
                                if num_emD+8-pa_1 <= num_D %(8-pa_1)���ض�����Ƕ����������
                                    bin2_8(pa_1+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1); 
                                    num_emD = num_emD + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                else
                                    t = num_D - num_emD; %ʣ���������ݸ���
                                    bin2_8(pa_1+1:pa_1+t) = Encrypt_D(num_emD+1:num_D); %tbit��������
                                    num_emD = num_emD + t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                end
                            end
                        end
                    end
                end
            end
        else %����ֿ����һ���ο����أ�����������ظ���Ԥ��������洢����
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %�ο����أ�����
                        continue; 
                    else
                        value = mark_Block(x,y); %��ǰ�������ֵ
                        [bin2_8] = Decimalism_Binary(value); %��ǰ�������ֵ��Ӧ��8λ������
                        pe = pe_Block(x,y); %��ǰ���ص�Ԥ�����
                        if pe>=pe_min && pe<=pe_max  %��Ƕ��������أ���Ƕ��(8-pa_1)����
                            if num_side < num_S %������Ϣû��Ƕ��
                                if num_side+8-pa_1 <= num_S %(8-pa_1)���ض�����Ƕ�븨����Ϣ
                                    bin2_8(pa_1+1:8) = Side_Info(num_side+1:num_side+8-pa_1); 
                                    num_side = num_side + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                else
                                    t = num_S - num_side; %ʣ�ศ����Ϣ����
                                    bin2_8(pa_1+1:pa_1+t) = Side_Info(num_side+1:num_S); %tbit������Ϣ
                                    num_side = num_side + t;
                                    bin2_8(pa_1+t+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1-t); %(8-pa_1-t)bit��������
                                    num_emD = num_emD + 8-pa_1-t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                end
                            else %������ϢǶ��֮����Ƕ����������
                                if num_emD+8-pa_1 <= num_D %(8-pa_1)���ض�����Ƕ����������
                                    bin2_8(pa_1+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1); 
                                    num_emD = num_emD + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                else
                                    t = num_D - num_emD; %ʣ���������ݸ���
                                    bin2_8(pa_1+1:pa_1+t) = Encrypt_D(num_emD+1:num_D); %tbit��������
                                    num_emD = num_emD + t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %�滻tλLSB
                                end
                            end
                        end
                    end
                end
            end
        end  
        %----------------------�����ֿܷ�ŵ���ǰλ��-----------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                stego_I(x,y) = stego_Block(row_B,col_B); %��¼���ֿܷ������
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
    end
end
%% ͳ��Ƕ�����������
if num_side == num_S %��ʾ������ϢǶ�����
    emD = D(1:num_emD);
else %��ศ����Ϣ�������޷�Ƕ����������
    emD = zeros();
    num_emD = num_side - num_S;
end
end