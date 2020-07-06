clear;clc;
addpath('JPEG_Toolbox');
jpeg_info = jpeg_read('lena_70.jpg');%解析JPEG图像
dct_coef = jpeg_info.coef_arrays{1,1};%获取dct系数
quant_tables = jpeg_info.quant_tables{1,1};%获取量化表
ori_jpg = imfinfo( 'lena_70.jpg' );
oriLength = ori_jpg.F                                                                                                                                                                                                                                               ileSize*8;%原始文件大小
[M,N] =size( dct_coef );
Block_n = 8 * ones(1,N/8);%生成长度为n/8的全8矩阵[8,8,8,8...]
Block_m = 8 * ones(1,M/8);
oriBlockdct = mat2cell(dct_coef,Block_n,Block_m);%把原来的图像矩阵分割成N个8*8的Block
%% QIAN2018加密算法（设加密图像尺寸为256*256）
rand('seed',1);s1 = randperm(4096);%随机选择n块
n = 256*256/64;
newBlockdct = cell(32,32);
rand('seed',2);s2 = randperm(1024);%置乱n块
newBlockdct(1:32*32) =oriBlockdct(s1(s2(1:32*32)));
crptodct=cell2mat(newBlockdct);
crptoJpeginfo = jpeg_info;
crptoJpeginfo.coef_arrays{1,1} = crptodct;
crptoJpeginfo.image_width = 256;
crptoJpeginfo.image_height = 256;
jpeg_write(crptoJpeginfo,'crpto.jpg');%保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像
crptoJPEG = imfinfo( 'crpto.jpg' );
imshow(imread('crpto.jpg'));
%% QIAN2016加密算法（设加密图像尺寸为256*256）
% 对选中的块加密其附加位（也就是DCT系数）
