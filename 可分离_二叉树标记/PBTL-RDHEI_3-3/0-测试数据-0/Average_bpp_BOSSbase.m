clear
clc 
load('num_BOSSbase.mat'); %读取数据
load('bpp_BOSSbase.mat');
len = length(num_BOSSbase);
error_Data = 0;
error_Data_Image = zeros(); %存储辅助信息大于总嵌入量的图像ID
error_Side = 0;
error_Side_Image = zeros(); %存储无法提取全部辅助信息的图像ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %存储提取数据或恢复图像不正确的图像ID
num_True = 0; %统计正确提取恢复图像的数目
num_bpp = 0;
for i=1:len
    if num_BOSSbase(i) == -1 %辅助信息大于总嵌入量，不能嵌入数据
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_BOSSbase(i) == -1 %表示能嵌入信息但无法提取
        error_Side = error_Side + 1;
        error_Side_Image(error_Side) = i;
    elseif bpp_BOSSbase(i)==-2 || bpp_BOSSbase(i)==-3 || bpp_BOSSbase(i)==-4
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        num_True = num_True + 1;
        num_bpp = num_bpp +  bpp_BOSSbase(i);
    end
end
ave_bpp = num_bpp/num_True; %正确图像的平均嵌入率