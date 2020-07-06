clear
clc
% I = imread('测试图像\Airplane.tiff');
% I = imread('测试图像\Lake.tiff');
% I = imread('测试图像\Lena.tiff');
% I = imread('测试图像\Man.tiff');
I = imread('测试图像\Peppers.tiff');

% I = imread('测试图像\Airplane_0.tiff');
% I = imread('测试图像\Baboon.tiff');=- cv
% I = imread('测试图像\Tiffany.tiff');
origin_I = double(I); 
%% 产生二进制秘密数据
num = 10000000;
rand('seed',0); %设置种子
D = round(rand(1,num)*1); %产生稳定随机数
%% 设置密钥
K_en = 1; %图像加密密钥
K_sh = 2; %图像混洗密钥
K_hide=3; %数据嵌入密钥
%% 设置参数
Block_size = 2; %分块大小
L_fix = 3; %定长编码参数
%% 空出图像空间并加密混洗图像（内容所有者）
[ES_I,num_LSB] = Vacate_Encrypt(origin_I,Block_size,L_fix,K_en,K_sh);
%% 在加密混洗图像中嵌入数据（数据嵌入者）
[stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D);
num_emD = length(emD);
%% 在载密图像中提取秘密信息（接收者）
[exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
%% 恢复载密图像（接收者）
[recover_I,re_I] = Image_Recover(stego_I,K_en,K_sh);
%% 图像对比
figure;
subplot(221);imshow(origin_I,[]);title('原始图像');
subplot(222);imshow(ES_I,[]);title('加密图像');
subplot(223);imshow(stego_I,[]);title('载密图像');
subplot(224);imshow(recover_I,[]);title('恢复图像');
%% 计算图像嵌入率
[m,n] = size(origin_I);
bpp = num_emD/(m*n);
%% 结果判断
check1 = isequal(emD,exD);
check2 = isequal(origin_I,recover_I);
psnrvalue = PSNR(origin_I,re_I);
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
    disp(['含有秘密信息的解密图像的PSNR为: ' num2str(psnrvalue)])
    disp(['Embedding capacity equal to : ' num2str(num_emD) ' bits'] )
    disp(['Embedding rate equal to : ' num2str(bpp) ' bpp'])
    fprintf(['该测试图像------------ OK','\n\n']);
else
    fprintf(['该测试图像------------ ERROR','\n\n']);
end
