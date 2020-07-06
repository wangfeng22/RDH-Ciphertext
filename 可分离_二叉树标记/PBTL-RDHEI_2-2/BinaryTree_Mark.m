function [mark_I,PE_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(encrypt_I,pa_1,pa_2)
% ����˵�����Լ���ͼ��encrypt_I���б��
% ���룺encrypt_I������ͼ��,,pa_1,pa_2��������
% �����mark_I�����ͼ��,PE_I��Ԥ����,Side_Info��������Ϣ��,pe_min,pe_max����Ƕ��Ԥ����Χ��
[row,col] = size(encrypt_I); %����encrypt_I������ֵ
mark_I = encrypt_I;  %�����洢���ͼ�������
PE_I = encrypt_I;  %�����洢Ԥ����������
%% ������
m = floor(row/2);
n = floor(col/2);
Side_Info = zeros(); %��¼������Ϣ
num_S = 0; %������ͳ�Ƹ�����Ϣ����
%% ���Ƕ�����ݵ�Ԥ�����ķ�Χ
if pa_1 <= pa_2
    na = 2^pa_1 - 1;
else
    na = (2^pa_2-1)*(2^(pa_1-pa_2));
end
pe_min = ceil(-na/2);
pe_max = floor((na-1)/2);
%% �������صı�Ǳ���ֵ����Ԥ�����Ĳ�ֵ
bin_max = ones(1,pa_1); %ȫΪ1�ı��
[max] = Binary_Decimalism(bin_max);
dv = max - pe_max;
%% ����Ԥ������ͼ����б��
encrypt_Block = zeros(2,2); %������¼2*2���ֿܷ������
for i=1:m
    for j=1:n 
        %---------------------------���Ӧ���ֿܷ�-------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                encrypt_Block(row_B,col_B) = encrypt_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %---------------------�Լ��ֿܷ�����ؽ��б��----------------------%
        pe_Block = encrypt_Block; %������¼Ԥ�����
        mark_Block = encrypt_Block; %������¼��Ƿֿ������  
        if i==1 && j==1 %��һ���ֿ�����һ���������أ������洢����
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %�ο����أ�����
                        continue;
                    elseif x==1 && y==2 %�������أ��洢����
                        %--------------�洢����������Ϊ������Ϣ-------------%
                        value = encrypt_Block(x,y); %��ǰ��������ֵ
                        [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
                        Side_Info(num_S+1:num_S+8) = bin2_8; %��¼�ο�����ֵ��Ϊ������Ϣ
                        num_S = num_S + 8;
                        %--------------����������λ�ô洢����---------------%
                        [bin_pa_1] = Decimalism_Binary(pa_1); %����pa_1��Ӧ��8λ������
                        [bin_pa_2] = Decimalism_Binary(pa_2); %����pa_2��Ӧ��8λ������
                        bin2_8(1:4) = bin_pa_1(5:8); %�������4λ���ɱ�ʾ
                        bin2_8(5:8) = bin_pa_2(5:8);
                        [value] = Binary_Decimalism(bin2_8); %������������ת���ɱ������ֵ
                        mark_Block(x,y) = value;
                    else  %����Ԥ�����������  
                        value = encrypt_Block(x,y); %��ǰ��������ֵ
                        [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
                        pe = value - encrypt_Block(1,1); %��ǰ��������ֵ��Ԥ�����
                        pe_Block(x,y) = pe;
                        if pe>=pe_min && pe<=pe_max  %��Ƕ��������أ���pa_1���ر��
                            mark = pe + dv; %mark��ʾ��Ǳ���ת��ʮ���Ƶ�ֵ
                            [bin_mark] = Decimalism_Binary(mark); %���mark��Ӧ��8λ������
                            bin2_8(1:pa_1) = bin_mark(8-pa_1+1:8);%���markֻ��pa_1���ر�ʾ
                        else %����Ƕ�����أ���pa_2����ȫ0���
                            Side_Info(num_S+1:num_S+pa_2) = bin2_8(1:pa_2); %��¼��������ֵ��ǰpa_2����MSB��Ϊ������Ϣ
                            num_S = num_S + pa_2;
                            for k=1:pa_2
                                bin2_8(k) = 0;
                            end
                        end
                        [value] = Binary_Decimalism(bin2_8); %����Ǻ�Ķ�����ת���ɱ������ֵ
                        mark_Block(x,y) = value; %��¼�������
                    end
                end
            end
        else %����ֿ����һ���ο����أ������������ظ���Ԥ����������б��
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %�ο����أ�����
                        continue;
                    else %����Ԥ�����������ֵ  
                        value = encrypt_Block(x,y); %��ǰ��������ֵ 
                        [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
                        pe = value - encrypt_Block(1,1); %��ǰ��������ֵ��Ԥ�����
                        pe_Block(x,y) = pe;
                        if pe>=pe_min && pe<=pe_max  %��Ƕ��������أ���pa_1���ر��
                            mark = pe + dv; %mark��ʾ��Ǳ���ת��ʮ���Ƶ�ֵ
                            [bin_mark] = Decimalism_Binary(mark); %���mark��Ӧ��8λ������
                            bin2_8(1:pa_1) = bin_mark(8-pa_1+1:8);%���markֻ��pa_1���ر�ʾ
                        else %����Ƕ�����أ���pa_2����ȫ0���
                            Side_Info(num_S+1:num_S+pa_2) = bin2_8(1:pa_2); %��¼��������ֵ��ǰpa_2����MSB��Ϊ������Ϣ
                            num_S = num_S + pa_2;
                            for k=1:pa_2
                                bin2_8(k) = 0;
                            end
                        end
                        [value] = Binary_Decimalism(bin2_8); %����Ǻ�Ķ�����ת���ɱ������ֵ
                        mark_Block(x,y) = value; %��¼�������
                    end
                end
            end
        end 
        %----------------����Ƿֿ�ŵ���ǰλ�ò���¼Ԥ�����----------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                PE_I(x,y) = pe_Block(row_B,col_B); %��¼�ֿ����ص�Ԥ�����
                mark_I(x,y) = mark_Block(row_B,col_B); %��¼��Ƿֿ������
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
    end
end
end