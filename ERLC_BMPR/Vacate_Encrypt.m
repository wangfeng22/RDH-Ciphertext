function [ES_I,PL_len_CBS,PL_room,num_LSB] = Vacate_Encrypt(origin_I,Block_size,L_fix,K_en,K_sh)
% 函数说明：空出图像空间并加密原始图像，得到空出嵌入空间的加密图像
% 输入：origin_I（原始图像）,Block_size（分块大小）,L_fix（定长编码参数）,K_en（图像加密密钥）,K_sh（图像混洗密钥）
% 输出：ES_I（压缩之后的加密混洗图像）,PL_len_CBS（可压缩位平面的压缩比特流长度）,PL_room（各个位平面的压缩空间）,num_LSB（空出的总空间大小）

[row,col] = size(origin_I); %计算origin_I的行列值
num = ceil(log2(row))+ceil(log2(col))+2; %记录空出空间大小需要的比特数（+2代表最大嵌入率不超过4bpp）
%% 在原始图像中空出可以嵌入秘密信息的空间
[vacate_I,num_LSB,PL_room,PL_len_CBS] = Vacate_Room(origin_I,Block_size,L_fix);
%% 根据图像加密密钥K_en加密图像vacate_I
rand('seed',K_en); %设置种子
E = round(rand(row,col)*255); %生成大小为row*col的伪随机数矩阵
encrypt_I = vacate_I;
for i=1:row  %根据伪随机数矩阵E对图像vacate_I进行bit级加密
    for j=1:col
        encrypt_I(i,j) = bitxor(vacate_I(i,j),E(i,j));
    end
end
%% 净载荷空间大于num比特&&MSB位平面记录了辅助信息的情况下才进行数据嵌入（代表有压缩空间）
transition_I = encrypt_I;
if num_LSB>=num && PL_room(8)>=0 %需要num比特记录净压缩空间大小&&MSB位平面记录辅助信息
    %% 在图像的LSB位平面记录空出的空间大小
    room_bits = zeros(1,num);
    bin2 = dec2bin(num_LSB)-'0'; %将空出空间的大小转换成二进制
    len = length(bin2);
    if len<num
        room_bits(num-len+1:num) = bin2;
    else
        room_bits = bin2; 
    end
    for i=1:num %将空出空间大小记录在图像最低位平面的第一行
        value_0 = transition_I(1,i);
        bit = room_bits(i);
        value_1 = (floor(value_0/2))*2 + bit;
        transition_I(1,i) = value_1;
    end   
end
%% 根据图像混洗密钥K_sh混洗图像transition_I
rand('seed',K_sh); %设置种子
SH = randperm(row*col); %生成大小为row*col的伪随机序列
[shuffle_I] = Image_Shuffle(transition_I,SH);
%% 记录含有嵌入空间的加密混洗图像
ES_I = shuffle_I;
