function [vacate_I,num_LSB,PL_room,PL_len_CBS] = Vacate_Room(origin_I,Block_size,L_fix)
% 函数说明：利用BMPR算法压缩原始图像，以空出可以嵌入秘密信息的空间
% 输入：origin_I（原始图像）,Block_size（分块大小）,L_fix（定长编码参数）
% 输出：vacate_I（空出空间的图像）,num_LSB（空出的总空间大小）,PL_room（各个位平面的压缩空间）,PL_len_CBS（可压缩位平面的压缩比特流长度）

[row,col] = size(origin_I); %计算origin_I的行列值
%% 提取3个低位位平面的比特流（1→3）
LSB = zeros(); %记录全部的低位比特流
num_lsb = 0; %计数
for pl=1:3  %8代表最高位MSB
    [Plane] = BitPlanes_Extract(origin_I,pl); %提取第pl个位平面
    Trans_Plane = Plane'; %矩阵转置
    TP_bits = reshape(Trans_Plane,1,row*col); %将Trans_Plane转换成一维矩阵，按列遍历    
    LSB(num_lsb+1:num_lsb+row*col) = TP_bits;      
    num_lsb = num_lsb+row*col;
end
%% 从高到低依次求图像最终位平面的比特流（8→4）
PL_room = zeros(1,8); %用来记录位平面压缩后空出的空间大小
PL_len_CBS = zeros(1,8); %用来记录位平面压缩比特流的长度
num_pl = 0; %用来记录可压缩位平面数
PL_comp = cell(0); %用来记录压缩后的位平面
num_LSB = 0; %计数，总空间大小
for pl=8:-1:4  %8代表最高位平面，即像素的MSB
    %% ----------------------提取第pl个位平面----------------------%
    [Plane] = BitPlanes_Extract(origin_I,pl);
    %% ----------------------压缩第pl个位平面----------------------%
    [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix);
    %% ------------------记录最终的位平面的比特流-------------------%
    len_CBS = length(CBS); %压缩位平面比特流的长度
    num = ceil(log2(row)) + ceil(log2(col)); %记录长度信息需要的比特数
    if len_CBS+num+2 <= row*col %判断第pl个位平面是否可以压缩
         num_pl = num_pl+1;
         PL_bits = zeros(1,row*col); %用来记录最终位平面的比特流
         num_bits = 0; %计数
         %----------------在MSB位平面中记录公共参数（10bits）---------------%
         if pl==8
             [bin28_Bs] = BinaryConversion_10_2(Block_size); %将分块大小Block_size转换成8位二进制
             PL_bits(num_bits+1:num_bits+4) = bin28_Bs(5:8); %用4bit表示分块大小Block_size
             num_bits = num_bits + 4;
             [bin28_Lf] = BinaryConversion_10_2(L_fix); %将参数L_fix转换成8位二进制
             PL_bits(num_bits+1:num_bits+3) = bin28_Lf(6:8); %用3bit表示参数L_fix
             num_bits = num_bits + 3;
%              [bin28_pl] = BinaryConversion_10_2(num_pl); %将位平面数量num_pl转换成8位二进制
%              PL_bits(num_bits+1:num_bits+3) = bin28_pl(6:8); %用3bit表示位平面数量num_pl
             num_bits = num_bits + 3; %用3bit表示位平面数量num_pl
         end
         %--------------------记录位平面的重排列方式type--------------------%
         bin2_type = dec2bin(type)-'0'; %将位平面重排列方式转换成二进制
         if length(bin2_type) == 1  %位平面重排列方式用2比特表示
             tem = bin2_type(1);
             bin2_type(1) = 0;
             bin2_type(2) = tem;   
         end
         PL_bits(num_bits+1:num_bits+2) = bin2_type; %用2bit表示位平面重排列方式
         num_bits = num_bits + 2;
         %----------------记录位平面压缩比特流CBS及其长度信息----------------%
         len_CBS_bits = zeros(1,num); 
         bin2_len_CBS = dec2bin(len_CBS)-'0'; %将压缩位平面比特流的长度转换成二进制
         len = length(bin2_len_CBS);
         len_CBS_bits(num-len+1:num) = bin2_len_CBS; 
         PL_bits(num_bits+1:num_bits+num) = len_CBS_bits; %用num比特来表示压缩位平面比特流的长度
         num_bits = num_bits + num;
         PL_bits(num_bits+1:num_bits+len_CBS) = CBS; %记录压缩位平面比特流
         num_bits = num_bits + len_CBS;
         %---------------计算空出的空间大小并嵌入低位平面的LSB---------------%
         room = row*col - num_bits; %空出的空间大小
         re = num_lsb-num_LSB; %剩余的未嵌入LSB
         if room<=re %表示压缩空间不能完全嵌入LSB
             PL_bits(num_bits+1:num_bits+room) = LSB(num_LSB+1:num_LSB+room); %嵌入低位平面的LSB  
         else %表示压缩空间能完全嵌入LSB
             PL_bits(num_bits+1:num_bits+re) = LSB(num_LSB+1:num_LSB+re); %嵌入低位平面的LSB
         end
         PL_room(pl) = room;
         PL_len_CBS(pl) = len_CBS;
         %----------------记录最终位平面比特流和空出的空间大小---------------%
         PL_comp{num_pl} = PL_bits;
         num_LSB = num_LSB + room;
    else
        PL_room(pl) = -1; %-1表示该位平面不可压缩
        PL_len_CBS(pl) = -1;
        break;
    end
end
%% 更新最高位平面中记录的可压缩位平面数的信息
if num_pl >= 1
    PL_bits = PL_comp{1}; %最高位平面的比特流
    [bin28_pl] = BinaryConversion_10_2(num_pl); %将位平面数量num_pl转换成8位二进制        
    PL_bits(8:10) = bin28_pl(6:8); %用3bit表示位平面数量num_pl   
    PL_comp{1} = PL_bits;
end
%% 将最终的位平面比特流放回原始图像中
vacate_I = origin_I;
for k=1:num_pl
    pl = 8-k+1; %表示哪一个位平面
    PL_bits = PL_comp{k}; %最终位平面比特流
    Trans_Plane = reshape(PL_bits,col,row); %换成矩阵,以列排序
    Plane = Trans_Plane'; %矩阵转置
    [RI] = BitPlanes_Embed(vacate_I,Plane,pl); %将最终位平面矩阵放回图像中
    vacate_I = RI;
end
