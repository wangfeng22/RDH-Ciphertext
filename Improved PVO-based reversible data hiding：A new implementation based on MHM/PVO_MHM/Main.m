clear
clc
I = imread('lena.tiff');
% I = imread('Baboon.tiff');
% I = imread('Barbara.tiff');
origin_I = double(I); 
%% ������������������
num = 50000;
rand('seed',0); %��������
D = round(rand(1,num)*1); %�����ȶ������
%% Ƕ������
[stego_I,emD] = Embed(origin_I,D);
%% ��ȡ����
[recover_I,exD] = Extract(stego_I);
%% ͼ��Ա�
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(stego_I,[]);title('����ͼ��');
subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
psnrvalue = PSNR(origin_I,stego_I)
if isequal(emD,exD) == 1
    disp('Ƕ����������ȡ����һ��!');
else 
    disp('Ƕ����ȡ���̴���!');
end
if isequal(origin_I,recover_I) == 1
    disp('ԭʼͼ����ָ�ͼ��һ��!'); 
else 
    disp('�ָ�ͼ����̴���!');
end
