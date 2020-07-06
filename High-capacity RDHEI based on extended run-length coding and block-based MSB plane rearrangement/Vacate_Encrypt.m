function [ES_I,num_LSB] = Vacate_Encrypt(origin_I,Block_size,L_fix,K_en,K_sh)
% ����˵�����ճ�ͼ��ռ䲢����ԭʼͼ�񣬵õ��ճ�Ƕ��ռ�ļ���ͼ��
% ���룺origin_I��ԭʼͼ��,Block_size���ֿ��С��,L_fix���������������,K_en��ͼ�������Կ��,K_sh��ͼ���ϴ��Կ��
% �����ES_I��ѹ��֮��ļ��ܻ�ϴͼ��

[row,col] = size(origin_I); %����origin_I������ֵ
%% ��ԭʼͼ���пճ�����Ƕ��������Ϣ�Ŀռ�
[vacate_I,num_LSB] = Vacate_Room(origin_I,Block_size,L_fix);
%% ����ͼ�������ԿK_en����ͼ��vacate_I
rand('seed',K_en); %��������
E = round(rand(row,col)*255); %���ɴ�СΪrow*col��α���������
encrypt_I = vacate_I;
for i=1:row  %����α���������E��ͼ��vacate_I����bit������
    for j=1:col
        encrypt_I(i,j) = bitxor(vacate_I(i,j),E(i,j));
    end
end
%% ��ͼ���LSBλƽ���¼�ճ��Ŀռ��С
transition_I = encrypt_I;
num = ceil(log2(row))+ceil(log2(col))+2; %��¼�ճ��ռ��С��Ҫ�ı�����
room_bits = zeros(1,num);
bin2 = dec2bin(num_LSB)-'0'; %���ճ��ռ�Ĵ�Сת���ɶ�����
len = length(bin2);
if len<num
    room_bits(num-len+1:num) = bin2;
else
    room_bits = bin2; 
end
for i=1:num %���ճ��ռ��С��¼��ͼ�����λƽ��ĵ�һ��
    value_0 = transition_I(1,i);
    bit = room_bits(i);
    value_1 = (floor(value_0/2))*2 + bit;
    transition_I(1,i) = value_1;
end
%% ����ͼ���ϴ��ԿK_sh��ϴͼ��transition_I
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[shuffle_I] = Image_Shuffle(transition_I,SH);
%% ��¼����Ƕ��ռ�ļ��ܻ�ϴͼ��
ES_I = shuffle_I;
