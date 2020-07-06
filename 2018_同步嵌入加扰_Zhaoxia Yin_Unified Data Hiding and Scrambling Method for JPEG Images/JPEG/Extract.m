function [exD] = Extract(stego_jpeg_info,index_DC)
%stego_jpeg_info��ʾ����JPEGͼ�����Ϣ,Side��ʾ����Ϣ,index_DC��ʾ�ָ���Կ
dct_coef = stego_jpeg_info.coef_arrays{1,1}; %��ȡdctϵ��
[row_dct,col_dct]=size(dct_coef); %ͳ��dctϵ����������
block_m = row_dct/8; %�ֿ飬ÿ��8*8
block_n = col_dct/8;
exD = zeros();
%------������------%
AC = zeros(8,8);%������¼ÿ��8*8�ֿ���Ϣ������
num_exD = 0;    %ͳ������ȡ���ݵĸ���
%% ��DC��ACϵ���������һָ�
[dct_coef] = RecoverDct(dct_coef,index_DC);
%% ��ȡ��������
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
        %--------RLE���жԼ�����--------%
        [RLE] = GetRLE(AC); %��ֿ��RLE���ж�
        [~,G,k] = Grouping(RLE);  %����ͳ��
         %------�ֿ���ȡ��Ϣ------%
        [exData,numD] = GroupExtract(RLE,G,k); %�ֿ���ȡ��Ϣ
        exD(num_exD+1:num_exD+numD) = exData;
        num_exD = num_exD + numD;
    end
end