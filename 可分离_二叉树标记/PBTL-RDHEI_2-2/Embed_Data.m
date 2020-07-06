function [stego_I,emD,num_emD] = Embed_Data(encrypt_I,D,Data_key,pa_1,pa_2)
% 函数说明：在加密图像encrypt_I中嵌入数据
% 输入：encrypt_I（加密图像）,D（秘密数据）,Data_key（数据加密密钥）,pa_1,pa_2（参数）
% 输出：stego_I（载密图像）,emD（嵌入的秘密数据）,num_emD（嵌入秘密数据的个数）
[row,col] = size(encrypt_I); %计算encrypt_I的行列值
%% 对原始秘密信息D进行加密
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% 辅助量
m = floor(row/2);
n = floor(col/2);
num_D = length(Encrypt_D); %求秘密信息D的长度
num_emD = 0; %计数，统计嵌入秘密信息的个数
%% 对加密图像encrypt_I进行标记
[mark_I,PE_I,Side_Info,pe_min,pe_max] = BinaryTree_Mark(encrypt_I,pa_1,pa_2);
%% 求预测误差对应的标记
stego_I = mark_I;  %构建存储载密图像的容器
mark_Block = zeros(2,2); %用来记录2*2标记分块的像素
pe_Block = zeros(2,2); %用来记录2*2分块像素的预测误差
num_S = length(Side_Info); %求辅助信息Side_Info的长度
num_side = 0; %计数，记录嵌入辅助信息的个数
for i=1:m
    for j=1:n 
        if num_emD >= num_D %秘密数据已嵌入完毕
            break;
        end
        %---------------------------求对应标记分块-------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                mark_Block(row_B,col_B) = mark_I(x,y);
                pe_Block(row_B,col_B) = PE_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %--------------------在标记分块的像素中嵌入数据---------------------%
        stego_Block = mark_Block; %用来记录载密分块的像素 
        if i==1 && j==1 %第一个分块中有一个特殊像素，用来存储参数
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %参考像素，跳过
                        continue;
                    elseif x==1 && y==2 %特殊像素，跳过
                        continue;
                    else
                        value = mark_Block(x,y); %当前标记像素值
                        [bin2_8] = Decimalism_Binary(value); %当前标记像素值对应的8位二进制
                        pe = pe_Block(x,y); %当前像素的预测误差
                        if pe>=pe_min && pe<=pe_max  %可嵌入加密像素，可嵌入(8-pa_1)比特
                            if num_side < num_S %辅助信息没有嵌完
                                if num_side+8-pa_1 <= num_S %(8-pa_1)比特都用来嵌入辅助信息
                                    bin2_8(pa_1+1:8) = Side_Info(num_side+1:num_side+8-pa_1); 
                                    num_side = num_side + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                else
                                    t = num_S - num_side; %剩余辅助信息个数
                                    bin2_8(pa_1+1:pa_1+t) = Side_Info(num_side+1:num_S); %tbit辅助信息
                                    num_side = num_side + t;
                                    bin2_8(pa_1+t+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1-t); %(8-pa_1-t)bit秘密数据
                                    num_emD = num_emD + 8-pa_1-t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                end
                            else %辅助信息嵌完之后再嵌入秘密数据
                                if num_emD+8-pa_1 <= num_D %(8-pa_1)比特都用来嵌入秘密数据
                                    bin2_8(pa_1+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1); 
                                    num_emD = num_emD + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                else
                                    t = num_D - num_emD; %剩余秘密数据个数
                                    bin2_8(pa_1+1:pa_1+t) = Encrypt_D(num_emD+1:num_D); %tbit秘密数据
                                    num_emD = num_emD + t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                end
                            end
                        end
                    end
                end
            end
        else %其余分块除了一个参考像素，其它标记像素根据预测误差来存储数据
            for x=1:2
                for y=1:2
                    if x==1 && y==1 %参考像素，跳过
                        continue; 
                    else
                        value = mark_Block(x,y); %当前标记像素值
                        [bin2_8] = Decimalism_Binary(value); %当前标记像素值对应的8位二进制
                        pe = pe_Block(x,y); %当前像素的预测误差
                        if pe>=pe_min && pe<=pe_max  %可嵌入加密像素，可嵌入(8-pa_1)比特
                            if num_side < num_S %辅助信息没有嵌完
                                if num_side+8-pa_1 <= num_S %(8-pa_1)比特都用来嵌入辅助信息
                                    bin2_8(pa_1+1:8) = Side_Info(num_side+1:num_side+8-pa_1); 
                                    num_side = num_side + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                else
                                    t = num_S - num_side; %剩余辅助信息个数
                                    bin2_8(pa_1+1:pa_1+t) = Side_Info(num_side+1:num_S); %tbit辅助信息
                                    num_side = num_side + t;
                                    bin2_8(pa_1+t+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1-t); %(8-pa_1-t)bit秘密数据
                                    num_emD = num_emD + 8-pa_1-t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                end
                            else %辅助信息嵌完之后再嵌入秘密数据
                                if num_emD+8-pa_1 <= num_D %(8-pa_1)比特都用来嵌入秘密数据
                                    bin2_8(pa_1+1:8) = Encrypt_D(num_emD+1:num_emD+8-pa_1); 
                                    num_emD = num_emD + 8-pa_1;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                else
                                    t = num_D - num_emD; %剩余秘密数据个数
                                    bin2_8(pa_1+1:pa_1+t) = Encrypt_D(num_emD+1:num_D); %tbit秘密数据
                                    num_emD = num_emD + t;
                                    [value] = Binary_Decimalism(bin2_8);
                                    stego_Block(x,y) = value; %替换t位LSB
                                end
                            end
                        end
                    end
                end
            end
        end  
        %----------------------将载密分块放到当前位置-----------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                stego_I(x,y) = stego_Block(row_B,col_B); %记录载密分块的像素
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
    end
end
%% 统计嵌入的秘密数据
if num_side == num_S %表示辅助信息嵌入完毕
    emD = D(1:num_emD);
else %否侧辅助信息过长，无法嵌入秘密数据
    emD = zeros();
    num_emD = num_side - num_S;
end
end