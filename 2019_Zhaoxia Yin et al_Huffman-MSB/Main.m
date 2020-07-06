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
%% ����ͼ�������Կ�����ݼ�����Կ
Image_key = 1; 
Data_key = 2;
%% ���ò���(����ʵ���޸�)
ref_x = 1; %������Ϊ�ο����ص�����
ref_y = 1; %������Ϊ�ο����ص�����
%% ͼ����ܼ�����Ƕ��
[encrypt_I,stego_I,emD] = Encrypt_Embed(origin_I,D,Image_key,Data_key,ref_x,ref_y);
%% ������ȡ��ͼ��ָ�
num_emD = length(emD);
if num_emD > 0  %��ʾ�пռ�Ƕ������
    %--------�ڼ��ܱ��ͼ������ȡ��Ϣ--------%
    [Side_Information,Refer_Value,Encrypt_exD,Map_I,sign] = Extract_Data(stego_I,num,ref_x,ref_y);
    if sign == 1 %��ʾ����ȫ��ȡ������Ϣ
        %---------------���ݽ���----------------%
        [exD] = Encrypt_Data(Encrypt_exD,Data_key);
        %---------------ͼ��ָ�----------------%
        [recover_I] = Recover_Image(stego_I,Image_key,Side_Information,Refer_Value,Map_I,num,ref_x,ref_y);
        %---------------ͼ��Ա�----------------%
        figure;
        subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
        subplot(222);imshow(encrypt_I,[]);title('����ͼ��');
        subplot(223);imshow(stego_I,[]);title('����ͼ��');
        subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
        %---------------�����¼----------------%
        [m,n] = size(origin_I);
        bpp = num_emD/(m*n);
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
        disp('�޷���ȡȫ��������Ϣ��')
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end
else
    disp('������Ϣ������Ƕ�����������޷��洢���ݣ�') 
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end 
