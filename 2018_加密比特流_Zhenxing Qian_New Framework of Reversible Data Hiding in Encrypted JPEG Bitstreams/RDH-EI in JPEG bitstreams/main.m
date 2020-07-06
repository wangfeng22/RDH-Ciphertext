clear;clc;
addpath('JPEG_Toolbox');
jpeg_info = jpeg_read('lena_70.jpg');%����JPEGͼ��
dct_coef = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
quant_tables = jpeg_info.quant_tables{1,1};%��ȡ������
ori_jpg = imfinfo( 'lena_70.jpg' );
oriLength = ori_jpg.F                                                                                                                                                                                                                                               ileSize*8;%ԭʼ�ļ���С
[M,N] =size( dct_coef );
Block_n = 8 * ones(1,N/8);%���ɳ���Ϊn/8��ȫ8����[8,8,8,8...]
Block_m = 8 * ones(1,M/8);
oriBlockdct = mat2cell(dct_coef,Block_n,Block_m);%��ԭ����ͼ�����ָ��N��8*8��Block
%% QIAN2018�����㷨�������ͼ��ߴ�Ϊ256*256��
rand('seed',1);s1 = randperm(4096);%���ѡ��n��
n = 256*256/64;
newBlockdct = cell(32,32);
rand('seed',2);s2 = randperm(1024);%����n��
newBlockdct(1:32*32) =oriBlockdct(s1(s2(1:32*32)));
crptodct=cell2mat(newBlockdct);
crptoJpeginfo = jpeg_info;
crptoJpeginfo.coef_arrays{1,1} = crptodct;
crptoJpeginfo.image_width = 256;
crptoJpeginfo.image_height = 256;
jpeg_write(crptoJpeginfo,'crpto.jpg');%��������jpegͼ�񣬸��ݽ�����Ϣ���ع�JPEGͼ�񣬻������ͼ��
crptoJPEG = imfinfo( 'crpto.jpg' );
imshow(imread('crpto.jpg'));
%% QIAN2016�����㷨�������ͼ��ߴ�Ϊ256*256��
% ��ѡ�еĿ�����丽��λ��Ҳ����DCTϵ����
