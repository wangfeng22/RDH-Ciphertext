clear
clc
%% 产生二进制秘密数据
num_D = 2000000;
rand('seed',0); %设置种子
D = round(rand(1,num_D)*1); %产生稳定随机数
%% 图像数据集信息(BOSSbase_1.01),格式:PGM,数量:10000；
I_file_path = 'D:\ImageDatabase\BOSSbase_1.01\'; %测试图像数据集文件夹路径
I_path_list = dir(strcat(I_file_path,'*.pgm'));  %获取该文件夹中所有pgm格式的图像
img_num = length(I_path_list); %获取图像总数量
%% 记录每张图像的的相关信息
num_BOSSbase = zeros(1,img_num); %记录每张图像的嵌入量 
bpp_BOSSbase = zeros(1,img_num); %记录每张图像的嵌入率
len_BOSSbase = zeros(8,img_num); %记录每张图像各个位平面的压缩比特流长度
room_BOSSbase = zeros(8,img_num);%记录每张图像各个位平面的压缩空间
%% 设置密钥
K_en = 1; %图像加密密钥
K_sh = 2; %图像混洗密钥
K_hide=3; %数据嵌入密钥
%% 设置参数
Block_size = 4; %分块大小（存储分块大小的比特数需要调整，目前设为4bits）
L_fix = 3; %定长编码参数
L = 4; %相同比特流长度参数,方便修改
%% 图像数据集测试
ERROR = 0; %计数，统计存储信息错误的图像数
for i=1:img_num
    %-------------------------------读取图像-------------------------------%
    I_name = I_path_list(i).name; %图像名
    I = imread(strcat(I_file_path,I_name));%读取图像
    origin_I = double(I);
    %----------------空出图像空间并加密混洗图像（内容所有者）----------------%
    [ES_I,PL_len_CBS,PL_room,num_LSB] = Vacate_Encrypt(origin_I,Block_size,L_fix,K_en,K_sh);
    %------净载荷空间大于num比特&&MSB位平面记录了辅助信息的情况下才进行数据嵌入（代表有压缩空间）------%
    [row,col] = size(origin_I); %计算origin_I的行列值
    num = ceil(log2(row))+ceil(log2(col))+2; %记录净压缩空间大小需要的比特数
    if num_LSB>=num && PL_room(8)>=0 %需要num比特记录净压缩空间大小&&MSB位平面记录辅助信息
        %---------------在加密混洗图像中嵌入数据（数据嵌入者）---------------%
        [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D);
        num_emD = length(emD);
        %-----------------在载密图像中提取秘密信息（接收者）-----------------%
        [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
        %-----------------------恢复载密图像（接收者）----------------------%
        [recover_I,re_I] = Image_Recover(stego_I,K_en,K_sh);
        %-----------------------------结果记录-----------------------------%
        [m,n] = size(origin_I);
        num_BOSSbase(i) = num_emD;
        bpp_BOSSbase(i) = num_emD/(m*n);
        for pl=1:8
            len_BOSSbase(pl,i) = PL_len_CBS(pl);
            room_BOSSbase(pl,i) = PL_room(pl);
        end
        %-----------------------------结果判断-----------------------------%
        check1 = isequal(emD,exD);
        check2 = isequal(origin_I,recover_I);
        if check1 == 1  
            disp('提取数据与嵌入数据完全相同！')
        else
            disp('Warning！数据提取错误！')
        end
        if check2 == 1
            disp('重构图像与原始图像完全相同！')
        else
            disp('Warning！图像重构错误！')
        end
        %-----------------------------结果输出-----------------------------%
        if check1 == 1 && check2 == 1
            bpp = bpp_BOSSbase(i);
            disp(['Embedding capacity equal to : ' num2str(num_emD)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['第 ',num2str(i),' 幅图像-------- OK','\n\n']);
        else
            ERROR = ERROR+1;
            if check1 ~= 1 && check2 == 1
                bpp_BOSSbase(i) = -1; %表示提取数据不正确
            elseif check1 == 1 && check2 ~= 1
                bpp_BOSSbase(i) = -2; %表示图像恢复不正确
            else
                bpp_BOSSbase(i) = -3; %表示提取数据和恢复图像都不正确
            end
            fprintf(['第 ',num2str(i),' 幅图像-------- ERROR','\n\n']);
        end
    elseif num_LSB>=num && PL_room(8)<0
        ERROR = ERROR+1;
        num_BOSSbase(i) = num_LSB;
        bpp_BOSSbase(i) = -4; %表示MSB位平面无法存储辅助信息
        for pl=1:8 %记录位平面压缩长度和压缩空间
            len_BOSSbase(pl,i) = PL_len_CBS(pl);
            room_BOSSbase(pl,i) = PL_room(pl);
        end
        disp('MSB位平面无法存储辅助信息！')
        fprintf(['第 ',num2str(i),' 幅图像-------- ERROR','\n\n']);
    else
        ERROR = ERROR+1;
        num_BOSSbase(i) = -1; %表示净压缩空间小于0，无法嵌入数据
        for pl=1:8 %记录位平面压缩长度和压缩空间
            len_BOSSbase(pl,i) = PL_len_CBS(pl);
            room_BOSSbase(pl,i) = PL_room(pl);
        end
        disp('净压缩空间小于0，无法嵌入数据！')
        fprintf(['第 ',num2str(i),' 幅图像-------- ERROR','\n\n']);
    end    
end
%% 保存数据
save('num_BOSSbase')
save('bpp_BOSSbase')
save('len_BOSSbase')
save('room_BOSSbase')