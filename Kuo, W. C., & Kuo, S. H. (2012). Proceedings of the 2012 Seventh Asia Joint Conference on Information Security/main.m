clear;
clc;
addpath JPEG_Toolbox\;
addpath img\;
rng(100,'twister');
payload = 5000;
T = 1;
data = round(rand(1,payload)*1); %随机产生01比特，作为嵌入的数据
imwrite(imread('boat.tiff'),'ori.jpg','jpeg','quality',80); %生成质量因子为XX的JPEG图像
jpeg_info_ori = jpeg_read('ori.jpg'); %解析JPEG图像
jpeg_info_stego = jpeg_info_ori; %文件复制一份，作为载密图像
quant_tables = jpeg_info_ori.quant_tables{1,1}; %获取量化表
oridct = jpeg_info_ori.coef_arrays{1,1}; %获取dct系数

%% section I
oriL = getL(oridct);
stegoL = EMD(oriL,T,data);
stegodct = recL(oridct,stegoL);
jpeg_info_stego.coef_arrays{1,1} = stegodct; %修改后的dct系数，写回JPEG信息
jpeg_write(jpeg_info_stego,'stego.jpg');%保存载密jpeg图像，根据解析信息，重构JPEG图像，获得载密图像

%% section II
ori_jpeg = imread('ori.jpg');%读取原始jpeg图像
stego_jpeg = imread('stego.jpg');%读取载密jpeg图像
figure;
subplot(1,2,1);imshow(ori_jpeg);title('original');%显示原始图像
subplot(1,2,2);imshow(stego_jpeg);title('stego');%显示载密图像

psnrValue = psnr(ori_jpeg,stego_jpeg);

fid = fopen('stego.jpg','rb');
bit1 = fread(fid,'ubit1');
fclose(fid);
fid = fopen('ori.jpg','rb');
bit2 = fread(fid,'ubit1');
fclose(fid);
increaseFile = length(bit1)-length(bit2);