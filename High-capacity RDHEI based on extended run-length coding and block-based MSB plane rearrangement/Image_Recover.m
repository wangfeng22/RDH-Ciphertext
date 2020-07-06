function [recover_I,re_I] = Image_Recover(stego_I,K_en,K_sh)
% ����˵����������ͼ��stego_I���ָܻ�
% ���룺stego_I������ͼ��,K_en��ͼ�������Կ��,K_sh��ͼ���ϴ��Կ��
% �����recover_I���ָ�ͼ��

[row,col] = size(stego_I); %����stego_I������ֵ
%% ����ͼ���ϴ��ԿK_sh�ָ�ͼ�����ص�ԭʼλ��
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[reShuffle_I] = Image_ReShuffle(stego_I,SH);
%% ����ͼ�������ԿK_en����ͼ��re_I
rand('seed',K_en); %��������
E = round(rand(row,col)*255); %���ɴ�СΪrow*col��α���������
decrypt_I = reShuffle_I;
for i=1:row  %����α���������E��ͼ��vacate_I����bit������
    for j=1:col
        decrypt_I(i,j) = bitxor(reShuffle_I(i,j),E(i,j));
    end
end
%% �Ӹߵ������λָ�ѹ����λƽ�棨8��4��
re_I = decrypt_I;
num_pl = 5; %ѹ����λƽ���������Ϊ5��
LSB = zeros();%������¼Ƕ��ĵ�λλƽ��ı���ֵ
num_LSB = 0;  %����
for pl=8:-1:4 
    if 9-pl > num_pl %�ж�ѹ����λƽ���Ƿ�ָ����
        break;
    end
    %% ----------------------��ȡ��pl��λƽ��----------------------%
    [Plane] = BitPlanes_Extract(decrypt_I,pl);
    %% --------------��ȡλƽ���ѹ����������Ƕ���LSB---------------% 
    Trans_Plane = Plane'; %����ת��
    TP_bits = reshape(Trans_Plane,1,row*col); %��Trans_Planeת����һά����,���б���
    t = 0; %����
    %-----------------MSBλƽ���д洢����ز�����10 bits��------------------%
    if pl==8 
        bin28_Bs = TP_bits(t+1:t+4); %��ȡ�洢�ķֿ��С��Ϣ(4 bits)
        [Block_size] = BinaryConversion_2_10(bin28_Bs); %�ֿ��С
        t = t+4;
        bin28_Lf = TP_bits(t+1:t+3); %��ȡ�洢�Ĳ�����Ϣ(3 bits)
        [L_fix] = BinaryConversion_2_10(bin28_Lf); %����
        t = t+3;
        bin28_pl = TP_bits(t+1:t+3); %��ȡ�洢��ѹ��λƽ����(3 bits)
        [num_pl] = BinaryConversion_2_10(bin28_pl); %ѹ��λƽ����
        t = t+3;
    end
    %--------------------��ȡλƽ��������з�ʽ��2 bits��-------------------%
    bin2_type = TP_bits(t+1:t+2); 
    [type] = BinaryConversion_2_10(bin2_type); %λƽ�������з�ʽ
    t = t+2;
    %------------------------��ȡλƽ���ѹ��������-------------------------%
    num = ceil(log2(row)) + ceil(log2(col)); %��¼������Ϣ��Ҫ�ı�����
    bin2_len = TP_bits(t+1:t+num); 
    [len_CBS] = BinaryConversion_2_10(bin2_len); %λƽ��ѹ���������ĳ���
    t = t+num;
    CBS = TP_bits(t+1:t+len_CBS); %��ǰλƽ���ѹ��������
    t = t+len_CBS;
    re = row*col - t;
    LSB(num_LSB+1:num_LSB+re) = TP_bits(t+1:t+re); %Ƕ���LSB
    num_LSB = num_LSB+re;
    %% ------------------��ѹ��λƽ���ѹ��������-------------------% 
    [Plane_bits] = BitStream_DeCompress(CBS,L_fix);
    %% --------------------�ָ�λƽ���ԭʼ����---------------------% 
    [Plane_Matrix] = BitPlanes_Recover(Plane_bits,Block_size,type,row,col);
    %% ---------------���ָ���λƽ�����Żؽ���ͼ����---------------% 
    [RI] = BitPlanes_Embed(re_I,Plane_Matrix,pl);
    re_I = RI;
end
%% �ָ���λλƽ��
recover_I = re_I;
k = 0; %������Ƕ���LSB��
for pl=1:3
    if k==num_LSB %LSB��ȫ���ָ�
        break;
    end
    for i=1:row
        for j=1:col
            if k==num_LSB %LSB��ȫ���ָ�
                break;
            end
            value = recover_I(i,j); %��ǰ����ֵ
            [bin2_8] = BinaryConversion_10_2(value); %ת����8λ������
            index = 8-pl+1; %���ص�pl��λƽ�������
            k = k+1;
            bin2_8(index) = LSB(k);
            [value] = BinaryConversion_2_10(bin2_8);
            recover_I(i,j) = value;
        end
    end
end

