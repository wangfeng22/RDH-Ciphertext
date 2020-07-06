function [emD,stego_jpeg_info,Side] = Embedding(D,index_DC,origin_jpeg_info)
%D��ʾҪǶ�����Ϣ,origin_jpeg_info��ʾԭʼJPEGͼ�����Ϣ
%emD��ʾ��Ƕ�����Ϣ,stego_jpeg_info��ʾ����JPEGͼ�����Ϣ,Side��ʾ����Ϣ
stego_jpeg_info = origin_jpeg_info; %�����洢����jpegͼ�������
dct_coef = origin_jpeg_info.coef_arrays{1,1}; %��ȡdctϵ��
[row_dct,col_dct]=size(dct_coef); %ͳ��dctϵ����������
block_m = row_dct/8; %�ֿ飬ÿ��8*8
block_n = col_dct/8; 
Side = zeros(); %��¼����Ϣ
%------������------%
AC = zeros(8,8);%������¼ÿ��8*8�ֿ���Ϣ������
num_Side = 0;   %ͳ�Ʊ���Ϣ����
num_emD = 0;    %ͳ����Ƕ�����ݵĸ���
%% �ֿ�Ƕ����Ϣ
for i=1:block_m
    for j=1:block_n  
        %--------�ֿ����--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8  %��ÿ���ֿ�
            for col=(j-1)*8+1:j*8
                AC(row_AC,col_AC)=dct_coef(row,col);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1; 
        end      
        %--------RLE���жԼ�����Ϣ--------%
        [RLE] = GetRLE(AC); %��ֿ��RLE���ж�
        [n_Side] = GetSideInfo(RLE); %��ֿ�RLE���жԶ�Ӧ�ı���Ϣ 
        [~,L] = size(n_Side); %ͳ�Ʒֿ����Ϣ����
        Side(num_Side+1:num_Side+L) = n_Side; %���Ϸֿ�ı���Ϣ
        num_Side = num_Side+L;
        [~,G,k] = Grouping(RLE);  %����ͳ��
         %------�ֿ�Ƕ����Ϣ------%
        [stego_AC,numD] = GroupEmbed(G,k,D,num_emD); %�ֿ�Ƕ����Ϣ
        stego_AC(1,1) = AC(1,1);%DCϵ������
        num_emD = num_emD + numD;
        %--------���Ϸֿ�--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8
            for col=(j-1)*8+1:j*8
                dct_coef(row,col)=stego_AC(row_AC,col_AC);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
    end
end
%% ����JPEGͼ���DCϵ����ACϵ��
[dct_coef] = JpegShuffle(dct_coef,index_DC);
%% �����ܺͼ���֮���dctϵ���Ż�JPEG��
stego_jpeg_info.coef_arrays{1,1} = dct_coef;
emD = D(1:num_emD);
end