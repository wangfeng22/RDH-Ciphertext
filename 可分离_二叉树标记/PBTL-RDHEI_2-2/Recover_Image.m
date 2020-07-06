function [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I,pa_1,pa_2)
% 函数说明：根据提取的辅助信息和密钥恢复图像
% 输入：stego_I（载密图像）,Image_key（图像加密密钥）,Side_Info（辅助信息）,PE_I（预测误差）,pa_1,pa_2（参数）
% 输出：recover_I（恢复图像）
%% 辅助量
[row,col] = size(stego_I); %统计stego_I的行列数
m = floor(row/2);
n = floor(col/2);
num_side = 0; %计数，记录辅助信息的个数
%% 求可嵌入数据的预测误差的范围
if pa_1 <= pa_2
    na = 2^pa_1 - 1;
else
    na = (2^pa_2-1)*(2^(pa_1-pa_2));
end
pe_min = ceil(-na/2);
pe_max = floor((na-1)/2);
%% 根据Side_Info恢复图像中像素的标记位
encrypt_I = stego_I; %构建存储恢复像素标记位的图像矩阵
stego_Block = zeros(2,2); %用来记录2*2加密分块的像素
pe_Block = zeros(2,2); %用来记录2*2分块像素的预测误差
for i=1:m
    for j=1:n         
        %------------------------求对应载密分块----------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                stego_Block(row_B,col_B) = stego_I(x,y);
                pe_Block(row_B,col_B) = PE_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %----------------恢复载密分块中像素的标记位及原始值------------------%
        encrypt_Block = stego_Block;
        if i==1 && j==1 %------第一个分块中有一个特殊像素，用来存储参数------%
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %参考像素，跳过
                        continue; 
                    elseif x==1 && y==2 %特殊像素
                        bin2_8 = Side_Info(num_side+1:num_side+8); %特殊像素作为8位辅助信息
                        num_side = num_side + 8;
                        [value] = Binary_Decimalism(bin2_8); %将8位二进制转换成特殊像素值
                        encrypt_Block(x,y) = value;
                    else
                        pe = pe_Block(x,y); %当前像素点的预测误差
                        if pe>=pe_min && pe<=pe_max  %可嵌入点，直接根据预测误差恢复像素值
                            encrypt_Block(x,y) = encrypt_Block(1,1) + pe; 
                        else %不可嵌入点，替换前pa_2位标记值
                            value = stego_Block(x,y); %当前载密像素值
                            [bin2_8] = Decimalism_Binary(value); %当前载密像素值对应的8位二进制
                            bin2_8(1:pa_2) = Side_Info(num_side+1:num_side+pa_2);
                            num_side = num_side + pa_2;
                            [value] = Binary_Decimalism(bin2_8); %将替换后的8位二进制转换成像素值
                            encrypt_Block(x,y) = value;
                        end
                    end
                end
            end
        else %---其余分块除了一个参考像素，其它像素则根据预测误差恢复标记位---%
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %参考像素，跳过
                        continue; 
                    else
                        pe = pe_Block(x,y); %当前像素点的预测误差
                        if pe>=pe_min && pe<=pe_max  %可嵌入点，直接根据预测误差恢复像素值
                            encrypt_Block(x,y) = encrypt_Block(1,1) + pe; 
                        else %不可嵌入点，替换前pa_2位标记值
                            value = stego_Block(x,y); %当前载密像素值
                            [bin2_8] = Decimalism_Binary(value); %当前载密像素值对应的8位二进制
                            bin2_8(1:pa_2) = Side_Info(num_side+1:num_side+pa_2);
                            num_side = num_side + pa_2;
                            [value] = Binary_Decimalism(bin2_8); %将替换后的8位二进制转换成像素值
                            encrypt_Block(x,y) = value;
                        end
                    end
                end
            end 
        end
        %--------------------将预测误差分块放到当前位置---------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                encrypt_I(x,y) = encrypt_Block(row_B,col_B); %记录恢复的分块像素值
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
    end
end
%% 根据密钥Image_key解密图像
[recover_I] = Decrypt_Image(encrypt_I,Image_key);
end