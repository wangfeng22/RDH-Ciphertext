clc
clear
Data = round(rand(1,10000000)*1);%��Ƕ������
% I = double(imread('Lena.tiff'));
L = 1; %Ƕ�������1 2 3��
addpath(genpath('G:\������Ŀ\JPEGʵ�鱨��_P71514007_����\JPEG_Toolbox'));
jpeg_info = jpeg_read('Lena.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
dct_coef{1} = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
jpeg_info = jpeg_read('Airplane.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
dct_coef{2} = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
jpeg_info = jpeg_read('Baboon.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
dct_coef{3} = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
jpeg_info = jpeg_read('Boat.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
dct_coef{4} = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
jpeg_info = jpeg_read('Lake.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
dct_coef{5} = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
jpeg_info = jpeg_read('Tiffany.jpg');%����JPEGͼ�� jpeg_read�����ǽ��������еĺ��� ֱ�ӵ���
dct_coef{6} = jpeg_info.coef_arrays{1,1};%��ȡdctϵ��
DC=zeros(64,64);

payload=0;
%  I=fenkuaijieguo{1,1};
aaaa=0;
a = 2; %���ֵ�����ʶ����
e1 = [1,5,9,13,17,21,25]; %Ƕ������ѡ��  ���ֵ��Χֵ
I=DC;
%ע�⣬Ƕ������ֻ��һ��ģ�


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
        %%  Ƕ�벿��
        [preI,preError] = preOp(I);%����Ԥ�����
        [stegoI,numPixel,numData,emData,repreError,repreI] = embed(preI,preError,Data,e,I,L,bb);
        payload=payload+numData;
        %% ��ȡ����
        [extData,numP] = extract(stegoI,L,e,repreError,bb);
        %% ͼ���ع�
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

