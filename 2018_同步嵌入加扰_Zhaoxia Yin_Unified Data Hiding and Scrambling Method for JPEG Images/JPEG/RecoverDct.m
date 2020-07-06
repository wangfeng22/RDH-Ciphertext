function [recover_dct]=RecoverDct(stego_dct,index_DC)
%stego_dct��ʾ������Ϣ��index_DC��ʾ�ָ���Կ
recover_dct = stego_dct;
[row_dct,col_dct]=size(stego_dct); %ͳ��dctϵ����������
m = row_dct/8; %�ֿ飬ÿ��8*8
n = col_dct/8;
%% �����зֿ��RLE�������һָ�
AC = zeros(8,8);%������¼ÿ��8*8�ֿ���Ϣ������
for i=1:m
    for j=1:n  
        %--------�ֿ����--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8  %��ÿ���ֿ�
            for col=(j-1)*8+1:j*8
                AC(row_AC,col_AC)=recover_dct(row,col);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
        %-----���һָ�RLE-----%
        [RLE] = GetRLE(AC); %��ֿ��RLE���ж�
        [~,L] = size(RLE);  %ͳ��RLE����
        recover_AC = zeros(8,8);
        x=1; %��x,y��������¼�ϴ�Ƕ����Ϣ��λ��
        y=1; %(1,2)����ʼλ��
        for r=L:-1:1
            num0 = RLE(1,r); %Ƕ��RLE���жԵ���ֵ����       
            [x0,y0] = FindCoors(x,y,num0); %�ҵ�Ƕ���      
            recover_AC(x0,y0) = RLE(2,r); %Ƕ��LRE���ж�
            x = x0;         
            y = y0; %��¼����λ�ã�x,y��
        end
        recover_AC(1,1)=AC(1,1); %DCϵ������
        %--------���Ϸֿ�--------%
        row_AC = 1; %��
        col_AC = 1; %��
        for row=(i-1)*8+1:i*8
            for col=(j-1)*8+1:j*8
                recover_dct(row,col)=recover_AC(row_AC,col_AC);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
    end
end
%% ��DCϵ�����лָ�
%------��DCϵ����DPCM��ֵ------%
dc_PV = zeros(m,n);%�����ֵ
for i=1:m
    for j=1:n
        dx = (i-1)*8+1; %(dx,dy)��DCϵ������       
        dy = (j-1)*8+1; 
        if j==1  %��һ��
            if i==1  %(1,1)����DCϵ������
                dc_PV(i,j) = recover_dct(dx,dy);
            else  %ÿ�е�һ��������һ�����һ��DCϵ���Ĳ�ֵ
                dx0 = (i-2)*8+1; %��һ��     
                dy0 = (n-1)*8+1; %���һ��
                PV = recover_dct(dx,dy)-recover_dct(dx0,dy0);
                dc_PV(i,j) = PV;
            end
        else  %����ÿ�б�����ǰһ�еĲ�ֵ
            dy0 = (j-2)*8+1;
            PV = recover_dct(dx,dy)-recover_dct(dx,dy0);
            dc_PV(i,j) = PV;
        end
    end
end
%------��DCϵ����DPCM��ֵ�������һָ�------%
[recover_dc_PV]=ReShuffling(dc_PV,index_DC);
%------�ָ�ԭʼDCϵ��ֵ------%
for i=1:m
    for j=1:n              
        dx = (i-1)*8+1; %(dx,dy)��DCϵ������            
        dy = (j-1)*8+1;
        if j==1  %��һ��
            if i==1  %(1,1)����DCϵ������
                recover_dct(dx,dy) = recover_dc_PV(i,j);
            else  %ÿ�е�һ��DCϵ�����ڲ�ֵ����һ�����һ��DCϵ���ĺ�
                dx0 = (i-2)*8+1; %��һ��     
                dy0 = (n-1)*8+1; %���һ��
                sum = recover_dc_PV(i,j)+recover_dct(dx0,dy0);
                recover_dct(dx,dy) = sum;
            end
        else  %����ÿ�е��ڲ�ֵ��ǰһ�еĺ�
            dy0 = (j-2)*8+1;
            sum = recover_dc_PV(i,j)+recover_dct(dx,dy0);
            recover_dct(dx,dy) = sum;
        end 
    end
end