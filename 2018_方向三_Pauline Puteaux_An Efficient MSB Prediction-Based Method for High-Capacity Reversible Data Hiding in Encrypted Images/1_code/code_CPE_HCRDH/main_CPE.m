clear
clc
Data = round(rand(1,1000000)*1);%�������01���أ���ΪǶ�������
x = 1;%����Ƕ��Ч��
payload =round(511*511*x);%Ƕ���������Ʊ���
I = double(imread('Lena_Gray.tiff'));
[ error_location_map,preI ] = Predictor1( I,payload );%ͼ��Ԥ������
% [ error_location_map1,preI ] = Predictor1( preI );%
[ encryptI ] = Encrypted( preI );%ͼ����ܺ���
[ numData,emdData,stegoI ] = embed( encryptI,Data,payload );%����Ƕ�뺯��
[ numData2,extData,recoI ] = extract( stegoI,payload );%������ȡ����

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
