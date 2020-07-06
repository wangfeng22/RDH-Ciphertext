function [recover_jpeg_info] = Recover(stego_jpeg_info,Side,index_DC)
%stego_jpeg_info表示载密JPEG图像的信息,Side表示侧信息,index_DC表示恢复秘钥
%recover_jpeg_info表示恢复JPEG图像的信息
recover_jpeg_info = stego_jpeg_info;%构建存储载密jpeg图像的容器
dct_coef = stego_jpeg_info.coef_arrays{1,1}; %获取dct系数
[row_dct,col_dct]=size(dct_coef); %统计dct系数的行列数
block_m = row_dct/8; %分块，每块8*8
block_n = col_dct/8; 
%------辅助量------%
AC = zeros(8,8);%用来记录每个8*8分块信息的容器
numS = 0; %统计已使用的侧信息个数
%% 对DC和AC系数进行置乱恢复
[dct_coef] = RecoverDct(dct_coef,index_DC);
%% 恢复分块RLE原始序列
for i=1:block_m
    for j=1:block_n           
        %--------分块矩阵--------%
        row_AC = 1; %行
        col_AC = 1; %列
        for row=(i-1)*8+1:i*8  %求每个分块
            for col=(j-1)*8+1:j*8
                AC(row_AC,col_AC)=dct_coef(row,col);
                col_AC=col_AC+1;
            end
            row_AC=row_AC+1;
            col_AC=1;
        end
        %--------RLE序列对及排序--------%
        [RLE] = GetRLE(AC); %求分块的RLE序列对
        [Q,~,~] = Grouping(RLE);  %排序
        [~,L]=size(Q);  %统计分块RLE序列对的个数
        Sn = Side(numS+1:numS+L);
        numS = numS+L;
        %--------恢复分块--------%
        recover_AC = zeros(8,8);%构建重排列容器
        recover_AC(1,1) = AC(1,1);  %DC系数不变
        x=1; %坐标
        y=1;         
        for p=1:L       
            q = Sn(p); %读取侧信息    
            num0 = Q(1,q); %零值个数         
            [x0,y0] = FindCoors(x,y,num0); %找到嵌入点          
            recover_AC(x0,y0) = Q(2,q); %嵌入LRE序列对          
            x = x0; %记录结束位置          
            y = y0;     
            for z=q:L-1 %后面的RLE向前移     
                Q(1,z)=Q(1,z+1);   
                Q(2,z)=Q(2,z+1);   
            end       
        end
        %--------整合分块--------%
        row_AC = 1; %行
        col_AC = 1; %列
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
%% 将恢复之后的dct系数放回JPEG中
recover_jpeg_info.coef_arrays{1,1} = dct_coef;
end