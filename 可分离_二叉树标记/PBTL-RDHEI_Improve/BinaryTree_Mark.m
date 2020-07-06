function [mark_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(PE_I,encrypt_I,pa_1,pa_2)
% ����˵�����Լ���ͼ��encrypt_I���б��
% ���룺PE_I��Ԥ����,encrypt_I������ͼ��,,pa_1,pa_2��������
% �����mark_I�����ͼ��,Side_Info��������Ϣ��,pe_min,pe_max����Ƕ��Ԥ����Χ��
[row,col] = size(encrypt_I); %����encrypt_I������ֵ
mark_I = encrypt_I;  %�����洢���ͼ�������
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
dv = max - pe_max; %���������ֵ
%% ������
Side_Info = zeros(); %��¼������Ϣ
num_S = 0; %������ͳ�Ƹ�����Ϣ����
%% ����������λ�ô洢����pa_1��pa_2
value = encrypt_I(1,1); %��ǰ��������ֵ
[bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
Side_Info(num_S+1:num_S+8) = bin2_8; %��¼�ο�����ֵ��Ϊ������Ϣ
num_S = num_S + 8;
[bin_pa_1] = Decimalism_Binary(pa_1); %����pa_1��Ӧ��8λ������
[bin_pa_2] = Decimalism_Binary(pa_2); %����pa_2��Ӧ��8λ������
bin2_8(1:4) = bin_pa_1(5:8); %�������4λ���ɱ�ʾ
bin2_8(5:8) = bin_pa_2(5:8);
[value] = Binary_Decimalism(bin2_8); %������������ת���ɱ������ֵ
mark_I(1,1) = value;
%% ����Ԥ������ͼ����б��
for i=2:row
    for j=2:col
        pe = PE_I(i,j); %��ǰ���ص��Ԥ�����
        value = encrypt_I(i,j); %��ǰ��������ֵ
        [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
        bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
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
        bin2_8 = fliplr(bin2_8); %��bin2_8��ת����
        [value] = Binary_Decimalism(bin2_8); %����Ǻ�Ķ�����ת���ɱ������ֵ
        mark_I(i,j) = value; %��¼������� 
    end
end
end