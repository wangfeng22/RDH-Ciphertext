clear;
clc;
addpath('JPEG_Toolbox');
imwrite(imread('Lena.tiff'),'lena_80.jpg','quality',80);
jpeg_info = jpeg_read('lena_80.jpg');%����JPEGͼ��
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������
[M,N] =size( dct_coef );
Block_n = 8 * ones(1,N/8);%���ɳ���Ϊn/8��ȫΪ8��N/8����
Block_m = 8 * ones(1,M/8);
oriBlockdct = mat2cell(dct_coef,Block_n,Block_m);%��ԭ����ͼ�����ָ��N��8*8��Block

rand('seed',1);s1 = randperm(4096);%���ѡ��n��
n = 256*256/64;
newBlockdct = cell(64,64);
rand('seed',2);s2 = randperm(4096);%����n��
newBlockdct(1:64*64) = oriBlockdct(s1(s2(1:64*64)))
crptodct=cell2mat(newBlockdct);
crptoJpeginfo = jpeg_info;
crptoJpeginfo.coef_arrays{1,1} = crptodct;
crptoJpeginfo.image_width = 512;
crptoJpeginfo.image_height = 512;
jpeg_write(crptoJpeginfo,'crpto.jpg');%��������jpegͼ�񣬸��ݽ�����Ϣ���ع�JPEGͼ�񣬻������ͼ��
crptoJPEG = imfinfo( 'crpto.jpg' );
imshow(imread('crpto.jpg'));



