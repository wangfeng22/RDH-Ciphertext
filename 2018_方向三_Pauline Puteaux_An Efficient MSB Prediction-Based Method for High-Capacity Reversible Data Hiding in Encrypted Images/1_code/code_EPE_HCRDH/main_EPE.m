clear
clc
Data = round(rand(1,1000000)*1);%随机产生01比特，作为嵌入的数据
payload =100;%嵌入容量控制变量
I = double(imread('Lena_Gray.tiff'));
[ error_location_map ] = Predictor2( I );%图像预处理函数
[ encryptI ] = Encrypted( I );%图像加密函数
[ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map );
[ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map );
disp('=====>end<=====')
check1 = isequal(emdData,extData);

PSNR = psnr(recoI,I);
xx = ['PSNR of reconstructed Image and original Image :' num2str(PSNR)];
disp(xx)
if PSNR == -1
    disp('The original image has been reconstructed perfectly !')
end
if check1 == 1
    ef = numData/(511*511);
    disp('The extracted data is exactly the same as the embedded data !');
    disp(['Embedding rate equal to ' ])
elseif check1 ~= 1
    disp('warning! Extraction data is inconsistent with embedded data !');
end