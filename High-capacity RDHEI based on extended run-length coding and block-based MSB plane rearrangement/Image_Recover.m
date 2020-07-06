function [recover_I,re_I] = Image_Recover(stego_I,K_en,K_sh)
% 函数说明：将载密图像stego_I解密恢复
% 输入：stego_I（载密图像）,K_en（图像加密密钥）,K_sh（图像混洗密钥）
% 输出：recover_I（恢复图像）

[row,col] = size(stego_I); %计算stego_I的行列值
%% 根据图像混洗密钥K_sh恢复图像像素的原始位置
rand('seed',K_sh); %设置种子
SH = randperm(row*col); %生成大小为row*col的伪随机序列
[reShuffle_I] = Image_ReShuffle(stego_I,SH);
%% 根据图像加密密钥K_en解密图像re_I
rand('seed',K_en); %设置种子
E = round(rand(row,col)*255); %生成大小为row*col的伪随机数矩阵
decrypt_I = reShuffle_I;
for i=1:row  %根据伪随机数矩阵E对图像vacate_I进行bit级加密
    for j=1:col
        decrypt_I(i,j) = bitxor(reShuffle_I(i,j),E(i,j));
    end
end
%% 从高到低依次恢复压缩的位平面（8→4）
re_I = decrypt_I;
num_pl = 5; %压缩的位平面数（最大为5）
LSB = zeros();%用来记录嵌入的低位位平面的比特值
num_LSB = 0;  %计数
for pl=8:-1:4 
    if 9-pl > num_pl %判断压缩的位平面是否恢复完毕
        break;
    end
    %% ----------------------提取第pl个位平面----------------------%
    [Plane] = BitPlanes_Extract(decrypt_I,pl);
    %% --------------提取位平面的压缩比特流和嵌入的LSB---------------% 
    Trans_Plane = Plane'; %矩阵转置
    TP_bits = reshape(Trans_Plane,1,row*col); %将Trans_Plane转换成一维矩阵,按列遍历
    t = 0; %计数
    %-----------------MSB位平面中存储了相关参数（10 bits）------------------%
    if pl==8 
        bin28_Bs = TP_bits(t+1:t+4); %提取存储的分块大小信息(4 bits)
        [Block_size] = BinaryConversion_2_10(bin28_Bs); %分块大小
        t = t+4;
        bin28_Lf = TP_bits(t+1:t+3); %提取存储的参数信息(3 bits)
        [L_fix] = BinaryConversion_2_10(bin28_Lf); %参数
        t = t+3;
        bin28_pl = TP_bits(t+1:t+3); %提取存储的压缩位平面数(3 bits)
        [num_pl] = BinaryConversion_2_10(bin28_pl); %压缩位平面数
        t = t+3;
    end
    %--------------------提取位平面的重排列方式（2 bits）-------------------%
    bin2_type = TP_bits(t+1:t+2); 
    [type] = BinaryConversion_2_10(bin2_type); %位平面重排列方式
    t = t+2;
    %------------------------提取位平面的压缩比特流-------------------------%
    num = ceil(log2(row)) + ceil(log2(col)); %记录长度信息需要的比特数
    bin2_len = TP_bits(t+1:t+num); 
    [len_CBS] = BinaryConversion_2_10(bin2_len); %位平面压缩比特流的长度
    t = t+num;
    CBS = TP_bits(t+1:t+len_CBS); %当前位平面的压缩比特流
    t = t+len_CBS;
    re = row*col - t;
    LSB(num_LSB+1:num_LSB+re) = TP_bits(t+1:t+re); %嵌入的LSB
    num_LSB = num_LSB+re;
    %% ------------------解压缩位平面的压缩比特流-------------------% 
    [Plane_bits] = BitStream_DeCompress(CBS,L_fix);
    %% --------------------恢复位平面的原始矩阵---------------------% 
    [Plane_Matrix] = BitPlanes_Recover(Plane_bits,Block_size,type,row,col);
    %% ---------------将恢复的位平面矩阵放回解密图像中---------------% 
    [RI] = BitPlanes_Embed(re_I,Plane_Matrix,pl);
    re_I = RI;
end
%% 恢复低位位平面
recover_I = re_I;
k = 0; %计数，嵌入的LSB数
for pl=1:3
    if k==num_LSB %LSB已全部恢复
        break;
    end
    for i=1:row
        for j=1:col
            if k==num_LSB %LSB已全部恢复
                break;
            end
            value = recover_I(i,j); %当前像素值
            [bin2_8] = BinaryConversion_10_2(value); %转换成8位二进制
            index = 8-pl+1; %像素第pl个位平面的索引
            k = k+1;
            bin2_8(index) = LSB(k);
            [value] = BinaryConversion_2_10(bin2_8);
            recover_I(i,j) = value;
        end
    end
end

