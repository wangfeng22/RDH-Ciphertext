clear
clc
% I = imread('����ͼ��\Airplane.tiff'); %Jetplane
% I = imread('����ͼ��\Lake.tiff');
I = imread('����ͼ��\Lena.tiff');
% I = imread('����ͼ��\Man.tiff');
% I = imread('����ͼ��\Peppers.tiff');

% I = imread('����ͼ��\Airplane_0.tiff');
% I = imread('����ͼ��\Baboon.tiff');
% I = imread('����ͼ��\Tiffany.tiff');

% I = imread('����ͼ��\gpic1.tif'); %�ߴ磺512*384
% I = imread('����ͼ��\gpic2.tif'); %�ߴ磺384*512
%I = imread('����ͼ��\gpic1049.tif');%�ߴ磺384*512
origin_I = double(I); 
%% ������������������
num_D = 3000000;
rand('seed',0); %��������
D = round(rand(1,num_D)*1); %�����ȶ������
%% ������Կ
K_en = 1; %ͼ�������Կ
K_sh = 2; %ͼ���ϴ��Կ
K_hide=3; %����Ƕ����Կ
%% ���ò���
Block_size = 4; %�ֿ��С
L_fix = 3; %�����������
%% �ճ�ͼ��ռ䲢���ܻ�ϴͼ�����������ߣ�
[ES_I,PL_len_CBS,PL_room,num_LSB] = Vacate_Encrypt(origin_I,Block_size,L_fix,K_en,K_sh);
%% ���غɿռ����num����&&MSBλƽ���¼�˸�����Ϣ������²Ž�������Ƕ�루������ѹ���ռ䣩
[row,col] = size(origin_I); %����origin_I������ֵ
num = ceil(log2(row))+ceil(log2(col))+2; %��¼��ѹ���ռ��С��Ҫ�ı�����
if num_LSB>=num && PL_room(8)>=0 %��Ҫnum���ؼ�¼��ѹ���ռ��С&&MSBλƽ���¼������Ϣ
    %% �ڼ��ܻ�ϴͼ����Ƕ�����ݣ�����Ƕ���ߣ�
    [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D);
    num_emD = length(emD);
    %% ������ͼ������ȡ������Ϣ�������ߣ�
    [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
    %% �ָ�����ͼ�񣨽����ߣ�
    [recover_I,re_I] = Image_Recover(stego_I,K_en,K_sh);
    %% ͼ��Ա�
    figure;
    subplot(221);imshow(origin_I,[]);title('ԭʼͼ��');
    subplot(222);imshow(ES_I,[]);title('����ͼ��');
    subplot(223);imshow(stego_I,[]);title('����ͼ��');
    subplot(224);imshow(recover_I,[]);title('�ָ�ͼ��');
    %% ����ͼ��Ƕ����
    [m,n] = size(origin_I);
    bpp = num_emD/(m*n);
    %% ����ж�
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
    psnrvalue = PSNR(origin_I,re_I);
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
        disp(['����������Ϣ�Ľ���ͼ���PSNRΪ: ' num2str(psnrvalue)])
        disp(['Embedding capacity equal to : ' num2str(num_emD) ' bits'] )
        disp(['Embedding rate equal to : ' num2str(bpp) ' bpp'])
        fprintf(['�ò���ͼ��------------ OK','\n\n']);
    else
        disp('������ȡ��ͼ��ָ�����')
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end    
elseif num_LSB>=num && PL_room(8)<0
    disp('MSBλƽ���޷��洢������Ϣ��')
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
else
    disp('��ѹ���ռ�С��0���޷�Ƕ�����ݣ�')
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end