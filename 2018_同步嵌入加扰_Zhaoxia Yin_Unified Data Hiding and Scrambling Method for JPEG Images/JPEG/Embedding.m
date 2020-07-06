function [emD,stego_jpeg_info,Side] = Embedding(D,index_DC,origin_jpeg_info)
%D表示要嵌入的信息,origin_jpeg_info表示原始JPEG图像的信息
%emD表示已嵌入的信息,stego_jpeg_info表示载密JPEG图像的信息,Side表示边信息
stego_jpeg_info = origin_jpeg_info; %构建存储载密jpeg图像的容器
dct_coef = origin_jpeg_info.coef_arrays{1,1}; %获取dct系数
[row_dct,col_dct]=size(dct_coef); %统计dct系数的行列数
block_m = row_dct/8; %分块，每块8*8
block_n = col_dct/8; 
Side = zeros(); %记录边信息
%------辅助量------%
AC = zeros(8,8);%用来记录每个8*8分块信息的容器
num_Side = 0;   %统计边信息个数
num_emD = 0;    %统计已嵌入数据的个数
%% 分块嵌入信息
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
        %--------RLE序列对及边信息--------%
        [RLE] = GetRLE(AC); %求分块的RLE序列对
        [n_Side] = GetSideInfo(RLE); %求分块RLE序列对对应的边信息 
        [~,L] = size(n_Side); %统计分块边信息个数
        Side(num_Side+1:num_Side+L) = n_Side; %整合分块的边信息
        num_Side = num_Side+L;
        [~,G,k] = Grouping(RLE);  %分组统计
         %------分块嵌入信息------%
        [stego_AC,numD] = GroupEmbed(G,k,D,num_emD); %分块嵌入信息
        stego_AC(1,1) = AC(1,1);%DC系数不变
        num_emD = num_emD + numD;
        %--------整合分块--------%
        row_AC = 1; %行
        col_AC = 1; %列
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
%% 置乱JPEG图像的DC系数和AC系数
[dct_coef] = JpegShuffle(dct_coef,index_DC);
%% 将载密和加扰之后的dct系数放回JPEG中
stego_jpeg_info.coef_arrays{1,1} = dct_coef;
emD = D(1:num_emD);
end