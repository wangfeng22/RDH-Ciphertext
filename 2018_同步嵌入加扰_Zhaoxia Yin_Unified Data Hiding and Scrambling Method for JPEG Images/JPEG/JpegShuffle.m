function [shuffle_I] = JpegShuffle(origin_I,index_DC)
%shuffle_I��ʾ����֮�����Ϣ��origin_I��ʾԭʼͼ��
shuffle_I = origin_I;
[row_I,col_I]=size(origin_I); %ͳ��I��������
m = row_I/8;
n = col_I/8;
%% ��DCϵ������DPCM�����ϴ
%------��DCϵ����DPCM��ֵ------%
dc_PV = zeros(m,n); %�����ֵ
for i=1:m
    for j=1:n
        dx = (i-1)*8+1; %(dx,dy)��DCϵ������       
        dy = (j-1)*8+1;
        if j==1  %��һ��
            if i==1  %(1,1)����DCϵ������
                dc_PV(i,j) = shuffle_I(dx,dy);
            else  %ÿ�е�һ��������һ�����һ��DCϵ���Ĳ�ֵ
                dx0 = (i-2)*8+1; %��һ��     
                dy0 = (n-1)*8+1; %���һ��
                PV = shuffle_I(dx,dy)-shuffle_I(dx0,dy0);
                dc_PV(i,j) = PV;
            end
        else  %����ÿ�б�����ǰһ�еĲ�ֵ
            dy0 = (j-2)*8+1;
            PV = shuffle_I(dx,dy)-shuffle_I(dx,dy0);
            dc_PV(i,j) = PV;
        end 
    end
end 
%------��DCϵ����DPCM��ֵ��������------%
[stego_dc_PV]=Shuffling(dc_PV,index_DC);
%------�����ҵĲ�ֵ�����DCϵ���Ż�------%
for i=1:m
    for j=1:n
        dx = (i-1)*8+1; %(dx,dy)��DCϵ������       
        dy = (j-1)*8+1; 
        if j==1  %��һ��
            if i==1  %(1,1)����DCϵ������
                shuffle_I(dx,dy) = stego_dc_PV(i,j);
            else  %ÿ�е�һ��DCϵ�����ڲ�ֵ����һ�����һ��DCϵ���ĺ�
                dx0 = (i-2)*8+1; %��һ��     
                dy0 = (n-1)*8+1; %���һ�� 
                sum = stego_dc_PV(i,j)+shuffle_I(dx0,dy0);
                shuffle_I(dx,dy) = sum;
            end
        else  %����ÿ�е��ڲ�ֵ��ǰһ�еĺ�
            dy0 = (j-2)*8+1;
            sum = stego_dc_PV(i,j)+shuffle_I(dx,dy0);
            shuffle_I(dx,dy) = sum;
        end 
    end
end
%% �����зֿ��RLE���л�ϴ
AC = zeros(8,8); %������¼ÿ��8*8�ֿ������
for i=1:m
    for j=1:n  
        %--------�ֿ����--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8  %��ÿ���ֿ�
            for col=(j-1)*8+1:j*8
                AC(row_AC,col_AC)=shuffle_I(row,col);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
        %-----��ϴRLE-----%
        [RLE] = GetRLE(AC); %��ֿ��RLE���ж�
        [~,L] = size(RLE);  %ͳ��RLE����
        stego_AC = zeros(8,8);
        x=1; %��x,y��������¼�ϴ�Ƕ����Ϣ��λ��
        y=1; %(1,2)����ʼλ��
        for r=L:-1:1  %����Ƕ��RLE
            num0 = RLE(1,r); %Ƕ��RLE���жԵ���ֵ����       
            [x0,y0] = FindCoors(x,y,num0); %�ҵ�Ƕ���      
            stego_AC(x0,y0) = RLE(2,r); %Ƕ��LRE���ж�
            x = x0;         
            y = y0; %��¼����λ�ã�x,y��
        end
        stego_AC(1,1)=AC(1,1); %DCϵ������
        %--------���Ϸֿ�--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8
            for col=(j-1)*8+1:j*8
                shuffle_I(row,col)=stego_AC(row_AC,col_AC);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
    end
end