function [encrypt_I,stego_I,emD] = Encrypt_Embed(origin_I,D,Image_key,Data_key,ref_x,ref_y)
% ����˵������ԭʼͼ��origin_I���ܲ�Ƕ������
% ���룺origin_I��ԭʼͼ��,D��ҪǶ������ݣ�,Image_key,Data_key����Կ��,ref_x,ref_y���ο����ص���������
% �����encrypt_I������ͼ��,stego_I�����ܱ��ͼ��,emD��Ƕ������ݣ�

%% ����origin_I��Ԥ��ֵ
[origin_PV_I] = Predictor_Value(origin_I,ref_x,ref_y); 
%% ��ÿ������ֵ���б�ǣ���ԭʼͼ���λ��ͼ��
[Map_origin_I] = Category_Mark(origin_PV_I,origin_I,ref_x,ref_y);
%% ������ֵ�ı��������Huffman������
hist_Map_origin_I = tabulate(Map_origin_I(:)); %ͳ��ÿ�������������ֵ����
num_Map_origin_I = zeros(9,2);
for i=1:9  % 9�����ı��
    num_Map_origin_I(i,1) = i-1; 
end
[m,~] = size(hist_Map_origin_I);
for i=1:9
    for j=2:m %hist_Map_origin_I��һ��ͳ�Ƶ��ǲο����صĸ���
        if num_Map_origin_I(i,1) == hist_Map_origin_I(j,1)
            num_Map_origin_I(i,2) = hist_Map_origin_I(j,2);
        end
    end
end
[Code,Code_Bin] = Huffman_Code(num_Map_origin_I); %�����ǵ�ӳ���ϵ������������б�ʾ
%% ��λ��ͼMap_origin_Iת���ɶ���������
[Map_Bin] = Map_Binary(Map_origin_I,Code);
%% ����洢Map_Binary������Ҫ����Ϣ����
[row,col]=size(origin_I); 
max = ceil(log2(row)) + ceil(log2(col)) + 2; %����ô���Ķ����Ʊ�ʾMap_Binary�ĳ���
length_Map = length(Map_Bin);
len_Bin = dec2bin(length_Map)-'0'; %��length_Mapת���ɶ���������
if length(len_Bin) < max
    len = length(len_Bin);
    B = len_Bin;
    len_Bin = zeros(1,max);
    for i=1:len
        len_Bin(max-len+i) = B(i); %�洢Map_Bin�ĳ�����Ϣ
    end 
end
%% ͳ�ƻָ�ʱ��Ҫ�ĸ�����Ϣ��Code_Bin��len_Bin��Map_Bin��
Side_Information = [Code_Bin,len_Bin,Map_Bin];
%% ��ԭʼͼ��origin_I���м���
[encrypt_I] = Encrypt_Image(origin_I,Image_key);
%% ��Encrypt_I��Ƕ����Ϣ
[stego_I,emD] = Embed_Data(encrypt_I,Map_origin_I,Side_Information,D,Data_key,ref_x,ref_y);
end