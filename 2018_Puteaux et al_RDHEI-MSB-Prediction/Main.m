clear
clc
% I = imread('����ͼ��\Airplane.tiff');
I = imread('����ͼ��\Lena.tiff');
% I = imread('����ͼ��\Man.tiff');
% I = imread('����ͼ��\Jetplane.tiff');
% I = imread('����ͼ��\Baboon.tiff');
% I = imread('����ͼ��\Tiffany.tiff');
origin_I = double(I); 
%% ������������������
num = 10000000;
rand('seed',0); %��������
Data = round(rand(1,num)*1); %�����ȶ������
payload = 10000000;
%% ������Կ
K_e = 1; %ͼ�������Կ
% K_dh = 2; %����Ƕ����Կ
%% ����ͼ���MSB����Ԥ��λ��ͼ
[error_location_map] = Error_Predictor(origin_I);
%% ����ͼ�������ԿK_e����ԭʼͼ��,��error_location_mapǶ�뵽����ͼ����
[encrypt_I] = Encrypt_Image(origin_I,K_e);
%% ����Ƕ��
[stego_I,emD,marked_block] = Embed_Data(encrypt_I,Data,error_location_map); 
%% ������ȡ��ͼ��ָ�
num = numel(emD); %Ƕ���������Ϣ����
[recover_I,exD] = Extract_Recover(stego_I,num,K_e,marked_block,error_location_map);
%% ͼ��Ա�
figure;
subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
subplot(222);imshow(encrypt_I,[]);title('����ͼ��');
subplot(223);imshow(stego_I,[]);title('����ͼ��');
subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
%% �жϽ���Ƿ���ȷ
check1 = isequal(emD,exD);
check2 = isequal(recover_I,origin_I);
if check1 == 1
    disp('��ȡ������Ƕ��������ȫ��ͬ��')
else
    disp('Warning��������ȡ����')
end
if check2 == 1
    disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
else
    disp('Warning��ͼ���ع�����')
end
%% ������
if check1 == 1 && check2 == 1
    [m,n] = size(I);
    bpp = num/(m*n);
    disp(['Embedding capacity equal to : ' num2str(num)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['�ò���ͼ��------------ OK','\n\n']);
else
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end