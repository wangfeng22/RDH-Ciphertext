function [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I,pa_1,pa_2)
% ����˵����������ȡ�ĸ�����Ϣ����Կ�ָ�ͼ��
% ���룺stego_I������ͼ��,Image_key��ͼ�������Կ��,Side_Info��������Ϣ��,PE_I��Ԥ����,pa_1,pa_2��������
% �����recover_I���ָ�ͼ��
%% ������
[row,col] = size(stego_I); %ͳ��stego_I��������
m = floor(row/2);
n = floor(col/2);
num_side = 0; %��������¼������Ϣ�ĸ���
%% ���Ƕ�����ݵ�Ԥ�����ķ�Χ
if pa_1 <= pa_2
    na = 2^pa_1 - 1;
else
    na = (2^pa_2-1)*(2^(pa_1-pa_2));
end
pe_min = ceil(-na/2);
pe_max = floor((na-1)/2);
%% ����Side_Info�ָ�ͼ�������صı��λ
encrypt_I = stego_I; %�����洢�ָ����ر��λ��ͼ�����
stego_Block = zeros(2,2); %������¼2*2���ֿܷ������
pe_Block = zeros(2,2); %������¼2*2�ֿ����ص�Ԥ�����
for i=1:m
    for j=1:n         
        %------------------------���Ӧ���ֿܷ�----------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                stego_Block(row_B,col_B) = stego_I(x,y);
                pe_Block(row_B,col_B) = PE_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %----------------�ָ����ֿܷ������صı��λ��ԭʼֵ------------------%
        encrypt_Block = stego_Block;
        if i==1 && j==1 %------��һ���ֿ�����һ���������أ������洢����------%
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %�ο����أ�����
                        continue; 
                    elseif x==1 && y==2 %��������
                        bin2_8 = Side_Info(num_side+1:num_side+8); %����������Ϊ8λ������Ϣ
                        num_side = num_side + 8;
                        [value] = Binary_Decimalism(bin2_8); %��8λ������ת������������ֵ
                        encrypt_Block(x,y) = value;
                    else
                        pe = pe_Block(x,y); %��ǰ���ص��Ԥ�����
                        if pe>=pe_min && pe<=pe_max  %��Ƕ��㣬ֱ�Ӹ���Ԥ�����ָ�����ֵ
                            encrypt_Block(x,y) = encrypt_Block(1,1) + pe; 
                        else %����Ƕ��㣬�滻ǰpa_2λ���ֵ
                            value = stego_Block(x,y); %��ǰ��������ֵ
                            [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
                            bin2_8(1:pa_2) = Side_Info(num_side+1:num_side+pa_2);
                            num_side = num_side + pa_2;
                            [value] = Binary_Decimalism(bin2_8); %���滻���8λ������ת��������ֵ
                            encrypt_Block(x,y) = value;
                        end
                    end
                end
            end
        else %---����ֿ����һ���ο����أ��������������Ԥ�����ָ����λ---%
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %�ο����أ�����
                        continue; 
                    else
                        pe = pe_Block(x,y); %��ǰ���ص��Ԥ�����
                        if pe>=pe_min && pe<=pe_max  %��Ƕ��㣬ֱ�Ӹ���Ԥ�����ָ�����ֵ
                            encrypt_Block(x,y) = encrypt_Block(1,1) + pe; 
                        else %����Ƕ��㣬�滻ǰpa_2λ���ֵ
                            value = stego_Block(x,y); %��ǰ��������ֵ
                            [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
                            bin2_8(1:pa_2) = Side_Info(num_side+1:num_side+pa_2);
                            num_side = num_side + pa_2;
                            [value] = Binary_Decimalism(bin2_8); %���滻���8λ������ת��������ֵ
                            encrypt_Block(x,y) = value;
                        end
                    end
                end
            end 
        end
        %--------------------��Ԥ�����ֿ�ŵ���ǰλ��---------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                encrypt_I(x,y) = encrypt_Block(row_B,col_B); %��¼�ָ��ķֿ�����ֵ
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
    end
end
%% ������ԿImage_key����ͼ��
[recover_I] = Decrypt_Image(encrypt_I,Image_key);
end