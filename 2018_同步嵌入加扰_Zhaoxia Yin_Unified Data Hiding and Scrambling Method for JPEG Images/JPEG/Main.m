clear
clc
addpath(genpath('C:\Users\Administrator\Desktop\JPEG\jpegtbx_1.4'));%调用工具箱
%I = imread('测试图像\Pepper.tiff');
%I = imread('测试图像\Boat.tiff');
I = imread('测试图像\Lena.tiff');
%I = imread('测试图像\Baboon.tiff');
%I = imread('测试图像\Truck.tiff');
%I = imread('测试图像\Elaine.tiff');
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Couple.tiff');
QF=71;
imwrite(I,'origin.jpg','jpeg','quality',QF); %生成质量因子为71的jpeg图像
num = 500000;
% for seed=1:100 %循环100组秘密数据取平均值
seed=1;
rand('seed',seed); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 产生稳定混洗秘钥
rand('seed',0); %设置种子，产生稳定秘钥   
index_DC = randperm(64*64);
for i=1:64*64  %第一个位置不变
    if index_DC(i)==1
        index_DC(i) = index_DC(1);
        index_DC(1) = 1;
    end
end
%% 解析JPEG文件
origin_jpeg = imread('origin.jpg');  %读取原始jpeg图像
origin_jpeg_info = jpeg_read('origin.jpg'); %解析jpeg图像
%% 数据嵌入和加扰
[emD,stego_jpeg_info,Side] = Embedding(D,index_DC,origin_jpeg_info);
jpeg_write(stego_jpeg_info,'stego.jpg'); %保存载密jpeg图像
stego_jpeg = imread('stego.jpg'); %读取载密jpeg图像 
%% 数据提取
stego_jpeg_info = jpeg_read('stego.jpg');%解析载密jpeg图像
[exD] = Extract(stego_jpeg_info,index_DC);
%% 图像恢复
stego_jpeg_info = jpeg_read('stego.jpg');%解析载密jpeg图像
[recover_jpeg_info] = Recover(stego_jpeg_info,Side,index_DC);
jpeg_write(recover_jpeg_info,'recover.jpg');%保存恢复jpeg图像
recover_jpeg = imread('recover.jpg');%读取恢复jpeg图像
%% 文件大小和存储容量、边信息
%--计算文件大小的增加量--%
origin_filesize = imfinfo('origin.jpg');
stego_filesize = imfinfo('stego.jpg');
origin_filesize_set(seed) = origin_filesize.FileSize;
stego_filesize_set(seed) = stego_filesize.FileSize;
% %------计算存储容量------%
% [~,num_emD] = size(emD);
% num_D(seed) = num_emD;
% %-----计算边信息数目-----%
% [~,num_Side] = size(Side);
% num_S(seed) = num_Side;
% end
% origin_sum=0;%原始大小总量
% stego_sum=0; %加密大小总量
% num_D_sum=0; %存储容量总数
% num_S_sum=0; %边信息总数
% for x=1:100
%     origin_sum = origin_sum + origin_filesize_set(seed);
%     stego_sum = stego_sum + stego_filesize_set(seed);
%     num_D_sum = num_D_sum + num_D(seed);
%     num_S_sum = num_S_sum + num_S(seed);
% end
% num_D_average = num_D_sum/100; %平均嵌入量
% num_S_average = num_S_sum/100; %平均边信息数
% origin = origin_sum/100;
% origin_filesize_set(101) = origin;
% stego = stego_sum/100;
% stego_filesize_set(101) = stego;
JPEG_increased_fs = (stego_filesize_set - origin_filesize_set); %单位（字节）
%% 图像对比
figure;
subplot(121);imshow(origin_jpeg);title('jpeg原始图像');
subplot(122);imshow(stego_jpeg);title('jpeg载密图像');
figure;
subplot(121);imshow(origin_jpeg);title('jpeg原始图像');
subplot(122);imshow(recover_jpeg);title('jpeg恢复图像');
%% 判断结果是否正确
isequal(emD,exD)
isequal(origin_jpeg,recover_jpeg)