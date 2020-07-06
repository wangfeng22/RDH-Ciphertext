function [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D)
% ����˵�����ڼ��ܻ�ϴͼ��ES_I��Ƕ��������Ϣ
% ���룺ES_I�����ܻ�ϴͼ��,K_sh��ͼ���ϴ��Կ��,K_hide������Ƕ����Կ��,D����Ƕ���������Ϣ��
% �����stego_I������ͼ��,emD(Ƕ���������Ϣ)

[row,col] = size(ES_I); %����ES_I������ֵ
%% ����ͼ���ϴ��ԿK_sh�ָ�ͼ�����ص�ԭʼλ��
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[reshuffle_I] = Image_ReShuffle(ES_I,SH);
%% ��ͼ��LSB����ȡ��Ƕ��ռ�Ĵ�С��Ϣ
num = ceil(log2(row))+ceil(log2(col))+2; %��¼�ճ��ռ��С��Ҫ�ı�������+2�������Ƕ���ʲ�����4bpp��
room_bits = zeros(1,num); %��¼�ռ��С�ı�����
for i=1:num
    value = reshuffle_I(1,i);
    bit = mod(value,2);
    room_bits(i) = bit;
end
[room] = BinaryConversion_2_10(room_bits); %�ռ��С
%% ��������Ƕ����ԿK_hide��ԭʼ������ϢD���м���
[encrypt_D] = Data_Encrypt(D,K_hide);
%% �ڿճ��Ŀռ���Ƕ��������Ϣ
marked_I = reshuffle_I;
num_emD = 0; %������Ƕ��������Ϣ��
num_D = length(D);
for pl=1:3
    if num_emD==num_D || num_emD==room %������Ϣ��Ƕ��||�Ѵﵽ���Ƕ����
        break;
    end
    index = 8-pl+1; %���ص�pl��λƽ�������
    for i=1:row
        for j=1:col
            if num_emD==num_D || num_emD==room %������Ϣ��Ƕ��||�Ѵﵽ���Ƕ����
                break;
            end
            value = marked_I(i,j); %��ǰ����ֵ
            [bin2_8] = BinaryConversion_10_2(value); %ת����8λ������
            num_emD = num_emD+1;
            bin2_8(index) = encrypt_D(num_emD);
            [value] = BinaryConversion_2_10(bin2_8);
            marked_I(i,j) = value; %����������Ϣ������ֵ
        end
    end
end
%% ������������Ϣ�ı��ͼ��marked_I���л�ϴ
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[stego_I] = Image_Shuffle(marked_I,SH);
%% ͳ��Ƕ���������Ϣ
emD = D(1:num_emD);
end