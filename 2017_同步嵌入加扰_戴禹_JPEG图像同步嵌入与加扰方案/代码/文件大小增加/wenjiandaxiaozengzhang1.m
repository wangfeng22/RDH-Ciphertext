clc
clear
Data = round(rand(1,10000000)*1);%��Ƕ������
% I = double(imread('Lena.tiff'));
L = 1; %Ƕ�������1 2 3��
addpath(genpath('G:\������Ŀ\JPEGʵ�鱨��_P71514007_����\JPEG_Toolbox'));
I11 = imread('Lena.tiff');
I1=imread('Airplane.tiff');
I2=imread('Baboon.tiff');
I3=imread('Boat.tiff');
I4=imread('Lake.tiff');
I5=imread('Tiffany.tiff');


% fenkuaijieguo=fenkuai(dct_coef);      %64*64��
DC=zeros(64,64);
% for i=1:64
%     for j=1:64
%         DC(i,j)=fenkuaijieguo{i,j}(1,1);
%     end
% end
payload=0;
%  I=fenkuaijieguo{1,1};
aaaa=0;
a = 2; %���ֵ�����ʶ����
% e1 = [1,5,9,13,17,21,25]; %Ƕ������ѡ��  ���ֵ��Χֵ
I=DC;
%ע�⣬Ƕ������ֻ��һ��ģ�
QF2=[50,60,70,80,90];

for iiii=1:6
    %     iiii=1;
    for iii=1:5
    QF=QF2(iii);
    imwrite(I11,'Lena.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
    imwrite(I1,'Airplane.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
    imwrite(I2,'Baboon.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
    imwrite(I3,'Boat.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
    imwrite(I4,'Lake.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
    imwrite(I5,'Tiffany.jpg','jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��
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
    fenkuaijieguo=fenkuai(dct_coef{iiii});      %64*64��
    b=DC_f(fenkuaijieguo);
        e=1;
        for i=1:64
            for j=1:64
                DC(i,j)=fenkuaijieguo{i,j}(1,1);
            end
        end
        I=DC;
        %%  Ƕ�벿��
        [preI,preError] = preOp(I);%����Ԥ�����
        [stegoI,numPixel,numData,emData,repreError,repreI] = embed(preI,preError,Data,e,I,L,b);
        payload=payload+numData;
        %% ��ȡ����
        [extData,numP] = extract(stegoI,L,e,repreError,b);
        %% ͼ���ع�
        %         isequal(repreError,preError)
        [stegopreI1,reImg] = reImgOp2(stegoI,L,repreError,e,preI);
        payload=payload-numP*2;
        v = isequal(emData,extData);
        if v == 1
            %                     disp('��ȡ������Ƕ��������ȫһ�£�');
            
        else
            %                     disp('warning��������ȡ����');
            aaaa=aaaa+1;
        end
        %
        v2 = psnr(reImg,I);
        if v2 == -1
            %                     disp('�ָ�ͼ����ԭͼ����ȫһ�£�');
        else
            %                     disp('warning��ͼ��һ�¡�');
            aaaa=aaaa+1;
        end
                loading(iiii,iii)=payload;
                payload=0;
            isequal(reImg,DC)
        %         SSIM()
        %             a=repmat((1:10)',1,2)
        stream = RandStream('mrg32k3a','seed',13);
        savedState = stream.State;
        v1 = randperm(stream,4096);
        x=reshape(stegoI,1,4096);
        luan = x(v1);
        
        huifu(v1)=luan;
        isequal(huifu,x)
        v3=reshape(luan,64,64);
        v4=reshape(huifu,64,64);
        isequal(stegoI,v4)
%         
%         xxxx=intersect(DC,v3);
%         v3=stegoI;
        for i=1:64
            for j=1:64
                fenkuaijieguo{i,j}(1,1)=v3(i,j);
            end
        end
        for i=1:64
            for j=1:64
                stimg1(8*i-7:i*8,8*j-7:j*8)=fenkuaijieguo{i,j};
            end
        end
        
        jpeg_info_stego = jpeg_info;
        jpeg_info_stego.coef_arrays{1,1} = stimg1;
        jpeg_write(jpeg_info_stego,['stego_Lena',num2str(iiii),num2str(iii),'.jpg']);%��������jpegͼ��
        
    end
end

