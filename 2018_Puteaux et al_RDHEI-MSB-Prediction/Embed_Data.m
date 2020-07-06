function [stego_I,emD,marked_block] = Embed_Data(encrypt_I,Data,error_location_map)
% 函数说明：在加密图像中嵌入秘密信息
% 输入：encrypt_I（加密图像）,Data（待嵌入的秘密信息）,error_location_map（MSB错误预测位置图）
% 输出：stego_I（载密图像）,emD（嵌入的秘密信息）,marked_block（MSB错误预测的分块标记图）

[row,col] = size(encrypt_I); %计算stegoI的行列值
stego_I = encrypt_I;  %构建存储载密图像的容器
num = numel(Data); %秘密信息个数
%% 以8个像素为一个分块来划分MSB错误预测位置图，统计不能嵌入的块
flag_block = zeros(row,col/8); %分块大小1*8
for i = 1:row  
    for j = 1:8:col
        sumblock = sum(error_location_map(i,j:j+7));
        if sumblock > 0
            flag_block(i,(j+7)/8) = 1;
        end
    end
end
%% 在错误块前后添加标记块 标记块也不能嵌入
marked_block = flag_block;
for i = 1:row 
    for j = 1:col/8
        if flag_block(i,j) == 1
            if j == 1
                marked_block(i,j+1) = 1;
            elseif j == col/8
                marked_block(i,j-1) = 1;
            else
                marked_block(i,j+1) = 1;
                marked_block(i,j-1) = 1;
            end     
        end
    end
end
%% 嵌入信息（第一行第一列不嵌入）
num_emD = 0; %计数，嵌入秘密信息的个数
for i = 2:row  
    for j = 1:8:col
        if marked_block(i,(j+7)/8) == 0
            if j == 1 %第一列不嵌入
                for k = j+1:j+7
                    if num_emD == num
                        break;
                    end
                    stego_I(i,k) = Data(num_emD+1)*128 + mod(encrypt_I(i,k),128); %MSB嵌入
                    num_emD = num_emD +1;
                end
            else
                for k = j:j+7
                    if num_emD == num
                        break;
                    end
                    stego_I(i,k) = Data(num_emD+1)*128 + mod(encrypt_I(i,k),128); %MSB嵌入
                    num_emD = num_emD +1;
                end
            end
        end
    end
end
%% 统计嵌入的秘密信息
emD = Data(1:num_emD);
end