clear
clc
addpath(genpath('C:\Users\Administrator\Desktop\JPEG\jpegtbx_1.4'));%���ù�����
%I = imread('����ͼ��\Pepper.tiff');
%I = imread('����ͼ��\Boat.tiff');
I = imread('����ͼ��\Lena.tiff');
%I = imread('����ͼ��\Baboon.tiff');
%I = imread('����ͼ��\Truck.tiff');
%I = imread('����ͼ��\Elaine.tiff');
%I = imread('����ͼ��\Airplane.tiff');
%I = imread('����ͼ��\Couple.tiff');
QF=71;
imwrite(I,'origin.jpg','jpeg','quality',QF); %������������Ϊ71��jpegͼ��
num = 500000;
% for seed=1:100 %ѭ��100����������ȡƽ��ֵ
seed=1;
rand('seed',seed); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% �����ȶ���ϴ��Կ
rand('seed',0); %�������ӣ������ȶ���Կ   
index_DC = randperm(64*64);
for i=1:64*64  %��һ��λ�ò���
    if index_DC(i)==1
        index_DC(i) = index_DC(1);
        index_DC(1) = 1;
    end
end
%% ����JPEG�ļ�
origin_jpeg = imread('origin.jpg');  %��ȡԭʼjpegͼ��
origin_jpeg_info = jpeg_read('origin.jpg'); %����jpegͼ��
%% ����Ƕ��ͼ���
[emD,stego_jpeg_info,Side] = Embedding(D,index_DC,origin_jpeg_info);
jpeg_write(stego_jpeg_info,'stego.jpg'); %��������jpegͼ��
stego_jpeg = imread('stego.jpg'); %��ȡ����jpegͼ�� 
%% ������ȡ
stego_jpeg_info = jpeg_read('stego.jpg');%��������jpegͼ��
[exD] = Extract(stego_jpeg_info,index_DC);
%% ͼ��ָ�
stego_jpeg_info = jpeg_read('stego.jpg');%��������jpegͼ��
[recover_jpeg_info] = Recover(stego_jpeg_info,Side,index_DC);
jpeg_write(recover_jpeg_info,'recover.jpg');%����ָ�jpegͼ��
recover_jpeg = imread('recover.jpg');%��ȡ�ָ�jpegͼ��
%% �ļ���С�ʹ洢����������Ϣ
%--�����ļ���С��������--%
origin_filesize = imfinfo('origin.jpg');
stego_filesize = imfinfo('stego.jpg');
origin_filesize_set(seed) = origin_filesize.FileSize;
stego_filesize_set(seed) = stego_filesize.FileSize;
% %------����洢����------%
% [~,num_emD] = size(emD);
% num_D(seed) = num_emD;
% %-----�������Ϣ��Ŀ-----%
% [~,num_Side] = size(Side);
% num_S(seed) = num_Side;
% end
% origin_sum=0;%ԭʼ��С����
% stego_sum=0; %���ܴ�С����
% num_D_sum=0; %�洢��������
% num_S_sum=0; %����Ϣ����
% for x=1:100
%     origin_sum = origin_sum + origin_filesize_set(seed);
%     stego_sum = stego_sum + stego_filesize_set(seed);
%     num_D_sum = num_D_sum + num_D(seed);
%     num_S_sum = num_S_sum + num_S(seed);
% end
% num_D_average = num_D_sum/100; %ƽ��Ƕ����
% num_S_average = num_S_sum/100; %ƽ������Ϣ��
% origin = origin_sum/100;
% origin_filesize_set(101) = origin;
% stego = stego_sum/100;
% stego_filesize_set(101) = stego;
JPEG_increased_fs = (stego_filesize_set - origin_filesize_set); %��λ���ֽڣ�
%% ͼ��Ա�
figure;
subplot(121);imshow(origin_jpeg);title('jpegԭʼͼ��');
subplot(122);imshow(stego_jpeg);title('jpeg����ͼ��');
figure;
subplot(121);imshow(origin_jpeg);title('jpegԭʼͼ��');
subplot(122);imshow(recover_jpeg);title('jpeg�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
isequal(emD,exD)
isequal(origin_jpeg,recover_jpeg)