function [exD] = Extract(stego_jpeg_info,index_DC)
%stego_jpeg_info表示载密JPEG图像的信息,Side表示侧信息,index_DC表示恢复秘钥
dct_coef = stego_jpeg_info.coef_arrays{1,1}; %获取dct系数
[row_dct,col_dct]=size(dct_coef); %统计dct系数的行列数
block_m = row_dct/8; %分块，每块8*8
block_n = col_dct/8;
exD = zeros();
%------辅助量------%
AC = zeros(8,8);%用来记录每个8*8分块信息的容器
num_exD = 0;    %统计已提取数据的个数
%% 对DC和AC系数进行置乱恢复
[dct_coef] = RecoverDct(dct_coef,index_DC);
%% 提取秘密数据
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
        [~,G,k] = Grouping(RLE);  %分组统计
         %------分块提取信息------%
        [exData,numD] = GroupExtract(RLE,G,k); %分块提取信息
        exD(num_exD+1:num_exD+numD) = exData;
        num_exD = num_exD + numD;
    end
end