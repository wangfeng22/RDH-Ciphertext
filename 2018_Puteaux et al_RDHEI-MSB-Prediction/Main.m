clear
clc
% I = imread('测试图像\Airplane.tiff');
I = imread('测试图像\Lena.tiff');
% I = imread('测试图像\Man.tiff');
% I = imread('测试图像\Jetplane.tiff');
% I = imread('测试图像\Baboon.tiff');
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
%% 产生二进制秘密数据
num = 10000000;
rand('seed',0); %设置种子
Data = round(rand(1,num)*1); %产生稳定随机数
payload = 10000000;
%% 设置密钥
K_e = 1; %图像加密密钥
% K_dh = 2; %数据嵌入密钥
%% 生成图像的MSB错误预测位置图
[error_location_map] = Error_Predictor(origin_I);
%% 根据图像加密密钥K_e加密原始图像,将error_location_map嵌入到加密图像中
[encrypt_I] = Encrypt_Image(origin_I,K_e);
%% 数据嵌入
[stego_I,emD,marked_block] = Embed_Data(encrypt_I,Data,error_location_map); 
%% 数据提取和图像恢复
num = numel(emD); %嵌入的秘密信息个数
[recover_I,exD] = Extract_Recover(stego_I,num,K_e,marked_block,error_location_map);
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(encrypt_I,[]);title('加密图像');
subplot(223);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
%% 判断结果是否正确
check1 = isequal(emD,exD);
check2 = isequal(recover_I,origin_I);
if check1 == 1
    disp('提取数据与嵌入数据完全相同！')
else
    disp('Warning！数据提取错误！')
end
if check2 == 1
    disp('重构图像与原始图像完全相同！')
else
    disp('Warning！图像重构错误！')
end
%% 结果输出
if check1 == 1 && check2 == 1
    [m,n] = size(I);
    bpp = num/(m*n);
    disp(['Embedding capacity equal to : ' num2str(num)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['该测试图像------------ OK','\n\n']);
else
    fprintf(['该测试图像------------ ERROR','\n\n']);
end