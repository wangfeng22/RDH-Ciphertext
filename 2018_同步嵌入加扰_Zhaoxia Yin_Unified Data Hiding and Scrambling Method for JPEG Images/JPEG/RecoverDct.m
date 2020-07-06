function [recover_dct]=RecoverDct(stego_dct,index_DC)
%stego_dct表示置乱信息，index_DC表示恢复秘钥
recover_dct = stego_dct;
[row_dct,col_dct]=size(stego_dct); %统计dct系数的行列数
m = row_dct/8; %分块，每块8*8
n = col_dct/8;
%% 对所有分块的RLE进行置乱恢复
AC = zeros(8,8);%用来记录每个8*8分块信息的容器
for i=1:m
    for j=1:n  
        %--------分块矩阵--------%
        row_AC = 1; %行
        col_AC = 1; %列
        for row=(i-1)*8+1:i*8  %求每个分块
            for col=(j-1)*8+1:j*8
                AC(row_AC,col_AC)=recover_dct(row,col);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
        %-----置乱恢复RLE-----%
        [RLE] = GetRLE(AC); %求分块的RLE序列对
        [~,L] = size(RLE);  %统计RLE个数
        recover_AC = zeros(8,8);
        x=1; %（x,y）用来记录上次嵌入信息的位置
        y=1; %(1,2)是起始位置
        for r=L:-1:1
            num0 = RLE(1,r); %嵌入RLE序列对的零值个数       
            [x0,y0] = FindCoors(x,y,num0); %找到嵌入点      
            recover_AC(x0,y0) = RLE(2,r); %嵌入LRE序列对
            x = x0;         
            y = y0; %记录结束位置（x,y）
        end
        recover_AC(1,1)=AC(1,1); %DC系数不变
        %--------整合分块--------%
        row_AC = 1; %行
        col_AC = 1; %列
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
%% 对DC系数进行恢复
%------求DC系数的DPCM差值------%
dc_PV = zeros(m,n);%保存差值
for i=1:m
    for j=1:n
        dx = (i-1)*8+1; %(dx,dy)是DC系数坐标       
        dy = (j-1)*8+1; 
        if j==1  %第一列
            if i==1  %(1,1)处的DC系数不变
                dc_PV(i,j) = recover_dct(dx,dy);
            else  %每行第一个保存上一行最后一个DC系数的差值
                dx0 = (i-2)*8+1; %上一行     
                dy0 = (n-1)*8+1; %最后一列
                PV = recover_dct(dx,dy)-recover_dct(dx0,dy0);
                dc_PV(i,j) = PV;
            end
        else  %后面每列保存与前一列的差值
            dy0 = (j-2)*8+1;
            PV = recover_dct(dx,dy)-recover_dct(dx,dy0);
            dc_PV(i,j) = PV;
        end
    end
end
%------对DC系数的DPCM差值进行置乱恢复------%
[recover_dc_PV]=ReShuffling(dc_PV,index_DC);
%------恢复原始DC系数值------%
for i=1:m
    for j=1:n              
        dx = (i-1)*8+1; %(dx,dy)是DC系数坐标            
        dy = (j-1)*8+1;
        if j==1  %第一列
            if i==1  %(1,1)处的DC系数不变
                recover_dct(dx,dy) = recover_dc_PV(i,j);
            else  %每行第一个DC系数等于差值与上一行最后一个DC系数的和
                dx0 = (i-2)*8+1; %上一行     
                dy0 = (n-1)*8+1; %最后一列
                sum = recover_dc_PV(i,j)+recover_dct(dx0,dy0);
                recover_dct(dx,dy) = sum;
            end
        else  %后面每列等于差值与前一列的和
            dy0 = (j-2)*8+1;
            sum = recover_dc_PV(i,j)+recover_dct(dx,dy0);
            recover_dct(dx,dy) = sum;
        end 
    end
end