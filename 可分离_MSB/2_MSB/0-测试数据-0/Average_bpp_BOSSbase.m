clear
clc 
load('num_BOSSbase.mat'); %读取数据
load('bpp_BOSSbase.mat');
len = length(num_BOSSbase);
error_Data = 0;
error_Data_Image = zeros(); %没有存储数据的图像ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %存储提取数据或恢复图像不正确的图像ID
num_True = 0; %统计正确提取恢复图像的数目
num_bpp = 0;
for i=1:len
    if bpp_BOSSbase(i) == -1 %没有嵌入数据
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_BOSSbase(i)==-2 || bpp_BOSSbase(i)==-3 || bpp_BOSSbase(i)==-4
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        num_True = num_True + 1;
        num_bpp = num_bpp +  bpp_BOSSbase(i);
    end
end
ave_bpp = num_bpp/num_True; %正确图像的平均嵌入率
%% 求最大嵌入率和最小嵌入率
min_bpp = 10;
max_bpp = 0;
for i=1:len
    if bpp_BOSSbase(i) > max_bpp
        max_bpp = bpp_BOSSbase(i);
    end
    if bpp_BOSSbase(i) < min_bpp
        min_bpp = bpp_BOSSbase(i);
    end
end