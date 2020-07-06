function [Side_Info,Encrypt_exD,PE_I,pa_1,pa_2] = Extract_Data(stego_I,num_emD)
% ����˵�����ڼ��ܱ��ͼ������ȡ��Ϣ
% ���룺stego_I�����ܱ��ͼ��,num_emD��������Ϣ�ĳ��ȣ�
% �����Side_Info��������Ϣ��,Encrypt_exD�����ܵ�������Ϣ��,PE_I��Ԥ����,pa_1,pa_2��������
%% ��ȡ����
pa_value = stego_I(1,1); %�洢����������λ�ڵ�һ���ֿ�ĵ�һ��λ��
[bin_pa] = Decimalism_Binary(pa_value); %��ǰ����ֵ��Ӧ��8λ������
bin_pa_1(1:4) = bin_pa(1:4); %ǰ4λ��¼����pa_1
bin_pa_2(1:4) = bin_pa(5:8); %��4λ��¼����pa_2
[pa_1] = Binary_Decimalism(bin_pa_1);
[pa_2] = Binary_Decimalism(bin_pa_2);
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
%% ������
[row,col] = size(stego_I); %ͳ��stego_I��������
num_side = 0; %��������¼������Ϣ�ĸ���
Info = zeros(); %��¼��ȡ����Ϣ������������Ϣ���������ݣ�
t = 0; %����,ͳ����ȡ��Ϣ�ĸ���
PE_I = stego_I;
%% ��ȡǶ�����Ϣ
for i=2:row
    for j=2:col
        sign = 0; %�����Ϣ���ж���Ƕ��㻹�ǲ���Ƕ���
        value = stego_I(i,j); %��ǰ��������ֵ
        [bin2_8] = Decimalism_Binary(value); %��ǰ��������ֵ��Ӧ��8λ������
        bin2_8 = fliplr(bin2_8); %��8λ������bin2_8��ת
        for k=1:pa_2
            if bin2_8(k) ~= 0
                sign = 1; %��ʾǰpa_2λ��ȫΪ0����Ϊ��Ƕ���
            end
        end
        if sign == 1 %��Ƕ���
            bin_mark = bin2_8(1:pa_1); %��ȡ���ֵ
            [mark] = Binary_Decimalism(bin_mark); %�������ת����ʮ����
            PE_I(i,j) = mark - dv; %Ԥ���������ֵ���dv
            Info(t+1:t+8-pa_1) = bin2_8(pa_1+1:8); %���λ֮��ļ�ΪǶ�����Ϣ
            t = t + 8-pa_1;
        else %����Ƕ���
            num_side = num_side + pa_2; %ǰpa_2λ��Ϊ������Ϣ
            PE_I(i,j) = pe_min - 1; %����������ΪǶ��Ԥ��Χ֮��
        end 
    end
end
%% ��¼������Ϣ�ͼ��ܵ���������
num_side = num_side + 8; %��������8λҲ��Ϊ������Ϣ
Side_Info = Info(1:num_side);
Encrypt_exD = Info(num_side+1:num_side+num_emD);
end