function [recover_jpeg_info] = Recover(stego_jpeg_info,Side,index_DC)
%stego_jpeg_info��ʾ����JPEGͼ�����Ϣ,Side��ʾ����Ϣ,index_DC��ʾ�ָ���Կ
%recover_jpeg_info��ʾ�ָ�JPEGͼ�����Ϣ
recover_jpeg_info = stego_jpeg_info;%�����洢����jpegͼ�������
dct_coef = stego_jpeg_info.coef_arrays{1,1}; %��ȡdctϵ��
[row_dct,col_dct]=size(dct_coef); %ͳ��dctϵ����������
block_m = row_dct/8; %�ֿ飬ÿ��8*8
block_n = col_dct/8; 
%------������------%
AC = zeros(8,8);%������¼ÿ��8*8�ֿ���Ϣ������
numS = 0; %ͳ����ʹ�õĲ���Ϣ����
%% ��DC��ACϵ���������һָ�
[dct_coef] = RecoverDct(dct_coef,index_DC);
%% �ָ��ֿ�RLEԭʼ����
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
        [Q,~,~] = Grouping(RLE);  %����
        [~,L]=size(Q);  %ͳ�Ʒֿ�RLE���жԵĸ���
        Sn = Side(numS+1:numS+L);
        numS = numS+L;
        %--------�ָ��ֿ�--------%
        recover_AC = zeros(8,8);%��������������
        recover_AC(1,1) = AC(1,1);  %DCϵ������
        x=1; %����
        y=1;         
        for p=1:L       
            q = Sn(p); %��ȡ����Ϣ    
            num0 = Q(1,q); %��ֵ����         
            [x0,y0] = FindCoors(x,y,num0); %�ҵ�Ƕ���          
            recover_AC(x0,y0) = Q(2,q); %Ƕ��LRE���ж�          
            x = x0; %��¼����λ��          
            y = y0;     
            for z=q:L-1 %�����RLE��ǰ��     
                Q(1,z)=Q(1,z+1);   
                Q(2,z)=Q(2,z+1);   
            end       
        end
        %--------���Ϸֿ�--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8
            for col=(j-1)*8+1:j*8
                dct_coef(row,col)=recover_AC(row_AC,col_AC);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
    end
end
%% ���ָ�֮���dctϵ���Ż�JPEG��
recover_jpeg_info.coef_arrays{1,1} = dct_coef;
end