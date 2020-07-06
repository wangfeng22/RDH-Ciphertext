 clear
clc
%% 读取数据
load('num_BOSSbase.mat'); %读取数据,嵌入容量
load('bpp_BOSSbase.mat'); %读取数据,嵌入率
load('len_BOSSbase.mat'); %读取数据,位平面压缩长度
load('room_BOSSbase.mat');%读取数据,位平面压缩空间
%% 统计图像数据集的平均嵌入率和错误图像ID以及最大嵌入率和最小嵌入率
len = length(num_BOSSbase); %数据集图像个数      
error_Data = 0;
error_Data_Image = zeros(); %存储辅助信息大于总嵌入量的图像ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %存储提取数据或恢复图像不正确的图像ID
total_True = 0;%统计正确提取恢复图像的数目
total_bpp = 0; %计数，统计正确图像的总嵌入率
Best_Image_bpp = 0;%记录数据集中的最大嵌入率
Best_Image_id = 0; %记录图像ID
Worst_Image_bpp = 8;%记录数据集中的最小嵌入率
Worst_Image_id = 0; %记录图像ID
for i=1:len
    if num_BOSSbase(i)==-1 && bpp_BOSSbase(i)==0 %辅助信息大于总嵌入量，不能嵌入数据
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_BOSSbase(i)==-1 || bpp_BOSSbase(i)==-2 || bpp_BOSSbase(i)==-3
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        total_True = total_True + 1;
        total_bpp = total_bpp + bpp_BOSSbase(i);
        if bpp_BOSSbase(i) > Best_Image_bpp
            Best_Image_bpp = bpp_BOSSbase(i);
            Best_Image_id = i;
        end
        if bpp_BOSSbase(i) < Worst_Image_bpp
            Worst_Image_bpp = bpp_BOSSbase(i);
            Worst_Image_id = i;
        end
    end
end
ave_bpp = total_bpp/total_True; %正确图像的平均嵌入率
%% 统计数据集中每个位平面的压缩情况
Comp_BitPlane = zeros(1,8);
for i=1:len
    for j=1:8
        if room_BOSSbase(j,i) ~= 0 %表示位平面有压缩空间，即可压缩
            Comp_BitPlane(j) = Comp_BitPlane(j)+1;
        end
    end
end
%% 统计数据集中每个位平面的平均压缩比
Comp_Ratio = zeros(1,8); %记录位平面的压缩比
for i=1:8
    total_comp_len = 0;
    num_len = 0;
    for j=1:len
        if len_BOSSbase(i,j) ~= 0 % %表示位平面可压缩
            num_len = num_len+1; 
            total_comp_len = total_comp_len + len_BOSSbase(i,j);
        end
    end
    Comp_Ratio(i) = (total_comp_len/num_len)/(512*512);
end
%% 统计数据集中嵌入容量等于3bpp的图像数目
bpp_3_num = 0;
bpp_3_ID = zeros();
for i=1:len
    if bpp_BOSSbase(i) == 3 %表示图像还有压缩空间
        bpp_3_num = bpp_3_num+1;
        bpp_3_ID(bpp_3_num) = i;
    end
end