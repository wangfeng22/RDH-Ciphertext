clear;
clc;
addpath('JPEG_Toolbox');
imwrite(imread('Lena.tiff'),'lena_80.jpg','quality',80);
jpeg_info = jpeg_read('lena_80.jpg');%解析JPEG图像
dct_coef = jpeg_info.coef_arrays{1,1};%获取dct系数
quant_tables = jpeg_info.quant_tables{1,1};%获取量化表、
[M,N] =size( dct_coef );
Block_n = 8 * ones(1,N/8);%生成长度为n/8的全为8的N/8向量
Block_m = 8 * ones(1,M/8);
oriBlockdct = mat2cell(dct_coef,Block_n,Block_m);%把原来的图像矩阵分割成N个8*8的Block

rand('seed',1);s1 = randperm(4096);%随机选择n块
n = 256*256/64;
newBlockdct = cell(64,64);
rand('seed',2);s2 = randperm(4096);%置乱n块
newBlockdct(1:64*64) = oriBlockdct(s1(s2(1:64*64)))
crptodct=cell2mat(newBlockdct);
crptoJpeginfo = jpeg_info;
crptoJpeginfo.coef_arrays{1,1} = crptodct;
crptoJpeginfo.image_width = 512;
crptoJpeginfo.image_height = 512;
jpeg_write(crptoJpeginfo,'crpto.jpg');%保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像
crptoJPEG = imfinfo( 'crpto.jpg' );
imshow(imread('crpto.jpg'));



