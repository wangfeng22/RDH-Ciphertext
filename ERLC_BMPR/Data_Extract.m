function [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD)
% ����˵����������ͼ��stego_I����ȡ������Ϣ
% ���룺stego_I������ͼ��,K_sh��ͼ���ϴ��Կ��,K_hide������Ƕ����Կ��,num_emD��Ƕ���������Ϣ����
% �����exD(��ȡ��������Ϣ)

Encrypt_exD = zeros();
[row,col] = size(stego_I);
%% ����ͼ���ϴ��ԿK_sh�ָ�ͼ�����ص�ԭʼλ��
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[re_I] = Image_ReShuffle(stego_I,SH);
%% �ڵ�λλƽ������ȡ������Ϣ
num_exD = 0; %��������ȡ��������Ϣ��
for pl=1:3
    if num_exD==num_emD %������Ϣ����ȡ���
        break;
    end
    for i=1:row
        for j=1:col
            if num_exD==num_emD %������Ϣ����ȡ���
                break;
            end
            value = re_I(i,j); %��ǰ����ֵ
            [bin2_8] = BinaryConversion_10_2(value); %ת����8λ������
            index = 8-pl+1; %���ص�pl��λƽ�������
            num_exD = num_exD+1;
            Encrypt_exD(num_exD) = bin2_8(index);
        end
    end
end
%% ��������Ƕ����ԿK_hide������ȡ��������Ϣ
[exD] = Data_Encrypt(Encrypt_exD,K_hide);
