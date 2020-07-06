function [vacate_I,num_LSB,PL_room,PL_len_CBS] = Vacate_Room(origin_I,Block_size,L_fix)
% ����˵��������BMPR�㷨ѹ��ԭʼͼ���Կճ�����Ƕ��������Ϣ�Ŀռ�
% ���룺origin_I��ԭʼͼ��,Block_size���ֿ��С��,L_fix���������������
% �����vacate_I���ճ��ռ��ͼ��,num_LSB���ճ����ܿռ��С��,PL_room������λƽ���ѹ���ռ䣩,PL_len_CBS����ѹ��λƽ���ѹ�����������ȣ�

[row,col] = size(origin_I); %����origin_I������ֵ
%% ��ȡ3����λλƽ��ı�������1��3��
LSB = zeros(); %��¼ȫ���ĵ�λ������
num_lsb = 0; %����
for pl=1:3  %8�������λMSB
    [Plane] = BitPlanes_Extract(origin_I,pl); %��ȡ��pl��λƽ��
    Trans_Plane = Plane'; %����ת��
    TP_bits = reshape(Trans_Plane,1,row*col); %��Trans_Planeת����һά���󣬰��б���    
    LSB(num_lsb+1:num_lsb+row*col) = TP_bits;      
    num_lsb = num_lsb+row*col;
end
%% �Ӹߵ���������ͼ������λƽ��ı�������8��4��
PL_room = zeros(1,8); %������¼λƽ��ѹ����ճ��Ŀռ��С
PL_len_CBS = zeros(1,8); %������¼λƽ��ѹ���������ĳ���
num_pl = 0; %������¼��ѹ��λƽ����
PL_comp = cell(0); %������¼ѹ�����λƽ��
num_LSB = 0; %�������ܿռ��С
for pl=8:-1:4  %8�������λƽ�棬�����ص�MSB
    %% ----------------------��ȡ��pl��λƽ��----------------------%
    [Plane] = BitPlanes_Extract(origin_I,pl);
    %% ----------------------ѹ����pl��λƽ��----------------------%
    [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix);
    %% ------------------��¼���յ�λƽ��ı�����-------------------%
    len_CBS = length(CBS); %ѹ��λƽ��������ĳ���
    num = ceil(log2(row)) + ceil(log2(col)); %��¼������Ϣ��Ҫ�ı�����
    if len_CBS+num+2 <= row*col %�жϵ�pl��λƽ���Ƿ����ѹ��
         num_pl = num_pl+1;
         PL_bits = zeros(1,row*col); %������¼����λƽ��ı�����
         num_bits = 0; %����
         %----------------��MSBλƽ���м�¼����������10bits��---------------%
         if pl==8
             [bin28_Bs] = BinaryConversion_10_2(Block_size); %���ֿ��СBlock_sizeת����8λ������
             PL_bits(num_bits+1:num_bits+4) = bin28_Bs(5:8); %��4bit��ʾ�ֿ��СBlock_size
             num_bits = num_bits + 4;
             [bin28_Lf] = BinaryConversion_10_2(L_fix); %������L_fixת����8λ������
             PL_bits(num_bits+1:num_bits+3) = bin28_Lf(6:8); %��3bit��ʾ����L_fix
             num_bits = num_bits + 3;
%              [bin28_pl] = BinaryConversion_10_2(num_pl); %��λƽ������num_plת����8λ������
%              PL_bits(num_bits+1:num_bits+3) = bin28_pl(6:8); %��3bit��ʾλƽ������num_pl
             num_bits = num_bits + 3; %��3bit��ʾλƽ������num_pl
         end
         %--------------------��¼λƽ��������з�ʽtype--------------------%
         bin2_type = dec2bin(type)-'0'; %��λƽ�������з�ʽת���ɶ�����
         if length(bin2_type) == 1  %λƽ�������з�ʽ��2���ر�ʾ
             tem = bin2_type(1);
             bin2_type(1) = 0;
             bin2_type(2) = tem;   
         end
         PL_bits(num_bits+1:num_bits+2) = bin2_type; %��2bit��ʾλƽ�������з�ʽ
         num_bits = num_bits + 2;
         %----------------��¼λƽ��ѹ��������CBS���䳤����Ϣ----------------%
         len_CBS_bits = zeros(1,num); 
         bin2_len_CBS = dec2bin(len_CBS)-'0'; %��ѹ��λƽ��������ĳ���ת���ɶ�����
         len = length(bin2_len_CBS);
         len_CBS_bits(num-len+1:num) = bin2_len_CBS; 
         PL_bits(num_bits+1:num_bits+num) = len_CBS_bits; %��num��������ʾѹ��λƽ��������ĳ���
         num_bits = num_bits + num;
         PL_bits(num_bits+1:num_bits+len_CBS) = CBS; %��¼ѹ��λƽ�������
         num_bits = num_bits + len_CBS;
         %---------------����ճ��Ŀռ��С��Ƕ���λƽ���LSB---------------%
         room = row*col - num_bits; %�ճ��Ŀռ��С
         re = num_lsb-num_LSB; %ʣ���δǶ��LSB
         if room<=re %��ʾѹ���ռ䲻����ȫǶ��LSB
             PL_bits(num_bits+1:num_bits+room) = LSB(num_LSB+1:num_LSB+room); %Ƕ���λƽ���LSB  
         else %��ʾѹ���ռ�����ȫǶ��LSB
             PL_bits(num_bits+1:num_bits+re) = LSB(num_LSB+1:num_LSB+re); %Ƕ���λƽ���LSB
         end
         PL_room(pl) = room;
         PL_len_CBS(pl) = len_CBS;
         %----------------��¼����λƽ��������Ϳճ��Ŀռ��С---------------%
         PL_comp{num_pl} = PL_bits;
         num_LSB = num_LSB + room;
    else
        PL_room(pl) = -1; %-1��ʾ��λƽ�治��ѹ��
        PL_len_CBS(pl) = -1;
        break;
    end
end
%% �������λƽ���м�¼�Ŀ�ѹ��λƽ��������Ϣ
if num_pl >= 1
    PL_bits = PL_comp{1}; %���λƽ��ı�����
    [bin28_pl] = BinaryConversion_10_2(num_pl); %��λƽ������num_plת����8λ������        
    PL_bits(8:10) = bin28_pl(6:8); %��3bit��ʾλƽ������num_pl   
    PL_comp{1} = PL_bits;
end
%% �����յ�λƽ��������Ż�ԭʼͼ����
vacate_I = origin_I;
for k=1:num_pl
    pl = 8-k+1; %��ʾ��һ��λƽ��
    PL_bits = PL_comp{k}; %����λƽ�������
    Trans_Plane = reshape(PL_bits,col,row); %���ɾ���,��������
    Plane = Trans_Plane'; %����ת��
    [RI] = BitPlanes_Embed(vacate_I,Plane,pl); %������λƽ�����Ż�ͼ����
    vacate_I = RI;
end
