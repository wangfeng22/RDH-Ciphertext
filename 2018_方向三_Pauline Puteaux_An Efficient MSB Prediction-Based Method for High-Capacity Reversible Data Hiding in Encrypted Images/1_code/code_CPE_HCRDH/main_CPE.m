clear
clc
Data = round(rand(1,1000000)*1);%随机产生01比特，作为嵌入的数据
x = 1;%设置嵌入效率
payload =round(511*511*x);%嵌入容量控制变量
I = double(imread('Lena_Gray.tiff'));
[ error_location_map,preI ] = Predictor1( I,payload );%图像预处理函数
% [ error_location_map1,preI ] = Predictor1( preI );%
[ encryptI ] = Encrypted( preI );%图像加密函数
[ numData,emdData,stegoI ] = embed( encryptI,Data,payload );%数据嵌入函数
[ numData2,extData,recoI ] = extract( stegoI,payload );%数据提取函数

disp('=====>end<=====')
check1 = isequal(emdData,extData);
check2 = isequal(recoI,preI);
PSNR = psnr(I,recoI);
xx = ['PSNR of reconstructed Image and original Image :' num2str(PSNR)];
disp(xx)
if check1 == 1
    disp('The extracted data is exactly the same as the embedded data !');
    disp('Embedding rate equal to 1 bpp !')
elseif v ~= 1
    disp('warning! Extraction data is inconsistent with embedded data !');
end
