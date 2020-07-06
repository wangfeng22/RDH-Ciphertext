clear;
clc;
addpath JPEG_Toolbox\;
addpath img\;
rng(100,'twister');
payload = 5000;
T = 1;
data = round(rand(1,payload)*1); %�������01���أ���ΪǶ�������
imwrite(imread('boat.tiff'),'ori.jpg','jpeg','quality',80); %������������ΪXX��JPEGͼ��
jpeg_info_ori = jpeg_read('ori.jpg'); %����JPEGͼ��
jpeg_info_stego = jpeg_info_ori; %�ļ�����һ�ݣ���Ϊ����ͼ��
quant_tables = jpeg_info_ori.quant_tables{1,1}; %��ȡ������
oridct = jpeg_info_ori.coef_arrays{1,1}; %��ȡdctϵ��

%% section I
oriL = getL(oridct);
stegoL = EMD(oriL,T,data);
stegodct = recL(oridct,stegoL);
jpeg_info_stego.coef_arrays{1,1} = stegodct; %�޸ĺ��dctϵ����д��JPEG��Ϣ
jpeg_write(jpeg_info_stego,'stego.jpg');%��������jpegͼ�񣬸��ݽ�����Ϣ���ع�JPEGͼ�񣬻������ͼ��

%% section II
ori_jpeg = imread('ori.jpg');%��ȡԭʼjpegͼ��
stego_jpeg = imread('stego.jpg');%��ȡ����jpegͼ��
figure;
subplot(1,2,1);imshow(ori_jpeg);title('original');%��ʾԭʼͼ��
subplot(1,2,2);imshow(stego_jpeg);title('stego');%��ʾ����ͼ��

psnrValue = psnr(ori_jpeg,stego_jpeg);

fid = fopen('stego.jpg','rb');
bit1 = fread(fid,'ubit1');
fclose(fid);
fid = fopen('ori.jpg','rb');
bit2 = fread(fid,'ubit1');
fclose(fid);
increaseFile = length(bit1)-length(bit2);