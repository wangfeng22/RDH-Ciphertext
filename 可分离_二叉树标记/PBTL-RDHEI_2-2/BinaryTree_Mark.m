function [mark_I,PE_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(encrypt_I,pa_1,pa_2)
% 函数说明：对加密图像encrypt_I进行标记
% 输入：encrypt_I（加密图像）,,pa_1,pa_2（参数）
% 输出：mark_I（标记图像）,PE_I（预测误差）,Side_Info（辅助信息）,pe_min,pe_max（可嵌入预测误差范围）
[row,col] = size(encrypt_I); %计算encrypt_I的行列值
mark_I = encrypt_I;  %构建存储标记图像的容器
PE_I = encrypt_I;  %构建存储预测误差的容器
%% 辅助量
m = floor(row/2);
n = floor(col/2);
Side_Info = zeros(); %记录辅助信息
num_S = 0; %计数，统计辅助信息个数
%% 求可嵌入数据的预测误差的范围
if pa_1 <= pa_2
    na = 2^pa_1 - 1;
else
    na = (2^pa_2-1)*(2^(pa_1-pa_2));
end
pe_min = ceil(-na/2);
pe_max = floor((na-1)/2);
%% 计算像素的标记比特值与其预测误差的差值
bin_max = ones(1,pa_1); %全为1的标记
[max] = Binary_Decimalism(bin_max);
dv = max - pe_max;
%% 根据预测误差对图像进行标记
encrypt_Block = zeros(2,2); %用来记录2*2加密分块的像素
for i=1:m
    for j=1:n 
        %---------------------------求对应加密分块-------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                encrypt_Block(row_B,col_B) = encrypt_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %---------------------对加密分块的像素进行标记----------------------%
        pe_Block = encrypt_Block; %用来记录预测误差
        mark_Block = encrypt_Block; %用来记录标记分块的像素  
        if i==1 && j==1 %第一个分块中有一个特殊像素，用来存储参数
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %参考像素，跳过
                        continue;
                    elseif x==1 && y==2 %特殊像素，存储参数
                        %--------------存储特殊像素作为辅助信息-------------%
                        value = encrypt_Block(x,y); %当前加密像素值
                        [bin2_8] = Decimalism_Binary(value); %当前加密像素值对应的8位二进制
                        Side_Info(num_S+1:num_S+8) = bin2_8; %记录参考像素值作为辅助信息
                        num_S = num_S + 8;
                        %--------------在特殊像素位置存储参数---------------%
                        [bin_pa_1] = Decimalism_Binary(pa_1); %参数pa_1对应的8位二进制
                        [bin_pa_2] = Decimalism_Binary(pa_2); %参数pa_2对应的8位二进制
                        bin2_8(1:4) = bin_pa_1(5:8); %参数最多4位即可表示
                        bin2_8(5:8) = bin_pa_2(5:8);
                        [value] = Binary_Decimalism(bin2_8); %将参数二进制转换成标记像素值
                        mark_Block(x,y) = value;
                    else  %根据预测误差标记像素  
                        value = encrypt_Block(x,y); %当前加密像素值
                        [bin2_8] = Decimalism_Binary(value); %当前加密像素值对应的8位二进制
                        pe = value - encrypt_Block(1,1); %求当前加密像素值的预测误差
                        pe_Block(x,y) = pe;
                        if pe>=pe_min && pe<=pe_max  %可嵌入加密像素，用pa_1比特标记
                            mark = pe + dv; %mark表示标记比特转成十进制的值
                            [bin_mark] = Decimalism_Binary(mark); %标记mark对应的8位二进制
                            bin2_8(1:pa_1) = bin_mark(8-pa_1+1:8);%标记mark只用pa_1比特表示
                        else %不可嵌入像素，用pa_2比特全0标记
                            Side_Info(num_S+1:num_S+pa_2) = bin2_8(1:pa_2); %记录加密像素值的前pa_2比特MSB作为辅助信息
                            num_S = num_S + pa_2;
                            for k=1:pa_2
                                bin2_8(k) = 0;
                            end
                        end
                        [value] = Binary_Decimalism(bin2_8); %将标记后的二进制转换成标记像素值
                        mark_Block(x,y) = value; %记录标记像素
                    end
                end
            end
        else %其余分块除了一个参考像素，其它加密像素根据预测误差来进行标记
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %参考像素，跳过
                        continue;
                    else %根据预测误差标记像素值  
                        value = encrypt_Block(x,y); %当前加密像素值 
                        [bin2_8] = Decimalism_Binary(value); %当前加密像素值对应的8位二进制
                        pe = value - encrypt_Block(1,1); %求当前加密像素值的预测误差
                        pe_Block(x,y) = pe;
                        if pe>=pe_min && pe<=pe_max  %可嵌入加密像素，用pa_1比特标记
                            mark = pe + dv; %mark表示标记比特转成十进制的值
                            [bin_mark] = Decimalism_Binary(mark); %标记mark对应的8位二进制
                            bin2_8(1:pa_1) = bin_mark(8-pa_1+1:8);%标记mark只用pa_1比特表示
                        else %不可嵌入像素，用pa_2比特全0标记
                            Side_Info(num_S+1:num_S+pa_2) = bin2_8(1:pa_2); %记录加密像素值的前pa_2比特MSB作为辅助信息
                            num_S = num_S + pa_2;
                            for k=1:pa_2
                                bin2_8(k) = 0;
                            end
                        end
                        [value] = Binary_Decimalism(bin2_8); %将标记后的二进制转换成标记像素值
                        mark_Block(x,y) = value; %记录标记像素
                    end
                end
            end
        end 
        %----------------将标记分块放到当前位置并记录预测误差----------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                PE_I(x,y) = pe_Block(row_B,col_B); %记录分块像素的预测误差
                mark_I(x,y) = mark_Block(row_B,col_B); %记录标记分块的像素
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
    end
end
end