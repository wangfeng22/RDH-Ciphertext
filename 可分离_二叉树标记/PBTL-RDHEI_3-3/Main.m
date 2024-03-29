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
D = round(rand(1,num)*1); %产生稳定随机数
%% 设置参数
Image_key = 1; %图像加密密钥
Data_key = 2; %数据加密密钥
pa_1 = 5; %论文中的α，用来标记可嵌入块的bit数
pa_2 = 2; %论文中的β，用来标记不可嵌入块的bit数
%% 加密图像
[encrypt_I,Shuffle,R] = Encrypt_Image(origin_I,Image_key);
%% 数据嵌入
[stego_I,emD,num_emD] = Embed_Data(encrypt_I,D,Data_key,pa_1,pa_2);
%% 数据提取及图像恢复
[m,n] = size(origin_I);      
bpp = num_emD/(m*n);
if num_emD > 0  %表示有空间嵌入数据
    %--------在加密标记图像中提取信息--------%
    [Side_Info,Encrypt_exD,PE_I,pa_1,pa_2] = Extract_Data(stego_I,num_emD);
    %---------------解密数据----------------%
    [exD] = Encrypt_Data(Encrypt_exD,Data_key);
    %---------------图像恢复----------------%
    [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I,pa_1,pa_2);
    %---------------图像对比----------------%
    figure;
    subplot(221);imshow(origin_I,[]);title('原始图像');
    subplot(222);imshow(encrypt_I,[]);title('加密图像');
    subplot(223);imshow(stego_I,[]);title('载密图像');
    subplot(224);imshow(recover_I,[]);title('恢复图像');
    %---------------结果判断----------------%
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
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
    %---------------结果输出----------------%
    if check1 == 1 && check2 == 1
        disp(['Embedding capacity equal to : ' num2str(num_emD)])
        disp(['Embedding rate equal to : ' num2str(bpp)])
        fprintf(['该测试图像------------ OK','\n\n']);
    else
        fprintf(['该测试图像------------ ERROR','\n\n']);
    end
else
    disp('辅助信息大于总嵌入量，导致无法存储数据！') 
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['该测试图像------------ ERROR','\n\n']);
end

