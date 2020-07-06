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
D = round(rand(1,num)*1); %�����ȶ������
%% ���ò���
Image_key = 1; %ͼ�������Կ
Data_key = 2; %���ݼ�����Կ
pa_1 = 5; %�����еĦ���������ǿ�Ƕ����bit��
pa_2 = 2; %�����еĦ£�������ǲ���Ƕ����bit��
%% ����ͼ��
[encrypt_I,Shuffle,R] = Encrypt_Image(origin_I,Image_key);
%% ����Ƕ��
[stego_I,emD,num_emD] = Embed_Data(encrypt_I,D,Data_key,pa_1,pa_2);
%% ������ȡ��ͼ��ָ�
[m,n] = size(origin_I);      
bpp = num_emD/(m*n);
if num_emD > 0  %��ʾ�пռ�Ƕ������
    %--------�ڼ��ܱ��ͼ������ȡ��Ϣ--------%
    [Side_Info,Encrypt_exD,PE_I,pa_1,pa_2] = Extract_Data(stego_I,num_emD);
    %---------------��������----------------%
    [exD] = Encrypt_Data(Encrypt_exD,Data_key);
    %---------------ͼ��ָ�----------------%
    [recover_I] = Recover_Image(stego_I,Image_key,Side_Info,PE_I,pa_1,pa_2);
    %---------------ͼ��Ա�----------------%
    figure;
    subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
    subplot(222);imshow(encrypt_I,[]);title('����ͼ��');
    subplot(223);imshow(stego_I,[]);title('����ͼ��');
    subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
    %---------------����ж�----------------%
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
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
    %---------------������----------------%
    if check1 == 1 && check2 == 1
        disp(['Embedding capacity equal to : ' num2str(num_emD)])
        disp(['Embedding rate equal to : ' num2str(bpp)])
        fprintf(['�ò���ͼ��------------ OK','\n\n']);
    else
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end
else
    disp('������Ϣ������Ƕ�����������޷��洢���ݣ�') 
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    disp(['Embedding rate equal to : ' num2str(bpp)])
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end

