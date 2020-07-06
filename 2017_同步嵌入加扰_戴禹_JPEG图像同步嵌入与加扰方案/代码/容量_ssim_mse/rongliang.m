clc
clear
Data = round(rand(1,10000000)*1);%待嵌入数据
% I = double(imread('Lena.tiff'));
L = 1; %嵌入层数（1 2 3）
addpath(genpath('G:\科研项目\JPEG实验报告_P71514007_戴禹\JPEG_Toolbox'));
jpeg_info = jpeg_read('Lena.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{1} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Airplane.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{2} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Baboon.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{3} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Boat.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{4} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Lake.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{5} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Tiffany.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{6} = jpeg_info.coef_arrays{1,1};%获取dct系数
DC=zeros(64,64);

payload=0;
%  I=fenkuaijieguo{1,1};
aaaa=0;
a = 2; %误差值分类标识长度
e1 = [1,5,9,13,17,21,25]; %嵌入像素选择  误差值范围值
I=DC;
%注意，嵌入容量只有一块的！


for iiii=1:6
    fenkuaijieguo=fenkuai(dct_coef{iiii});
    for iii=1:7
        e=e1(iii);
        for i=1:64
            for j=1:64
                DC(i,j)=fenkuaijieguo{i,j}(1,1);
            end
        end
        I=DC;
        bb = DC_f(fenkuaijieguo);
        %%  嵌入部分
        [preI,preError] = preOp(I);%计算预测误差
        [stegoI,numPixel,numData,emData,repreError,repreI] = embed(preI,preError,Data,e,I,L,bb);
        payload=payload+numData;
        %% 提取部分
        [extData,numP] = extract(stegoI,L,e,repreError,bb);
        %% 图像重构
        %         isequal(repreError,preError)
        [stegopreI1,reImg] = reImgOp2(stegoI,L,repreError,e,preI);
        payload=payload-numP*2;
        
        loading(iiii,iii)=payload;
        payload=0;
        
        for i=1:64
            for j=1:64
                fenkuaijieguo{i,j}(1,1)=reImg(i,j);
            end
        end
        for i=1:64
            for j=1:64
                stimg1(8*i-7:i*8,8*j-7:j*8)=fenkuaijieguo{i,j};
            end
        end
        
        [mssim, ~,~,~] = SSIM(dct_coef{iiii}, stimg1);
        ssim(iiii,iii)=mssim;
        mseing(iiii,iii)=mse(dct_coef{iiii}, stimg1);
        psnring(iiii,iii)=psnr(dct_coef{iiii}, stimg1);
    end
end

