clc
clear
Data = round(rand(1,10000000)*1);%待嵌入数据
% I = double(imread('Lena.tiff'));
L = 1; %嵌入层数（1 2 3）
addpath(genpath('G:\科研项目\JPEG实验报告_P71514007_戴禹\JPEG_Toolbox'));
I11 = imread('Lena.tiff');
I1=imread('Airplane.tiff');
I2=imread('Baboon.tiff');
I3=imread('Boat.tiff');
I4=imread('Lake.tiff');
I5=imread('Tiffany.tiff');


% fenkuaijieguo=fenkuai(dct_coef);      %64*64块
DC=zeros(64,64);
% for i=1:64
%     for j=1:64
%         DC(i,j)=fenkuaijieguo{i,j}(1,1);
%     end
% end
payload=0;
%  I=fenkuaijieguo{1,1};
aaaa=0;
a = 2; %误差值分类标识长度
% e1 = [1,5,9,13,17,21,25]; %嵌入像素选择  误差值范围值
I=DC;
%注意，嵌入容量只有一块的！
QF2=[50,60,70,80,90];

for iiii=1:6
    %     iiii=1;
    for iii=1:5
    QF=QF2(iii);
    imwrite(I11,'Lena.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
    imwrite(I1,'Airplane.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
    imwrite(I2,'Baboon.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
    imwrite(I3,'Boat.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
    imwrite(I4,'Lake.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
    imwrite(I5,'Tiffany.jpg','jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像
    jpeg_info = jpeg_read('Lena.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
    dct_coef{1} = jpeg_info.coef_arrays{1,1};%获取dct系数
    jpeg_info = jpeg_read('Airplane.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
    dct_coef{2} = jpeg_info.coef_arrays{1,1};%获取dct系数
    jpeg_info = jpeg_read('Baboon.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
    dct_coef{3} = jpeg_info.coef_arrays{1,1};%获取dct系数
    jpeg_info = jpeg_read('Boat.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
    dct_coef{4} = jpeg_info.coef_arrays{1,1};%获取dct系数
    jpeg_info = jpeg_read('Lake.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
    dct_coef{5} = jpeg_info.coef_arrays{1,1};%获取dct系数
    jpeg_info = jpeg_read('Tiffany.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
    dct_coef{6} = jpeg_info.coef_arrays{1,1};%获取dct系数
    fenkuaijieguo=fenkuai(dct_coef{iiii});      %64*64块
    b=DC_f(fenkuaijieguo);
        e=1;
        for i=1:64
            for j=1:64
                DC(i,j)=fenkuaijieguo{i,j}(1,1);
            end
        end
        I=DC;
        %%  嵌入部分
        [preI,preError] = preOp(I);%计算预测误差
        [stegoI,numPixel,numData,emData,repreError,repreI] = embed(preI,preError,Data,e,I,L,b);
        payload=payload+numData;
        %% 提取部分
        [extData,numP] = extract(stegoI,L,e,repreError,b);
        %% 图像重构
        %         isequal(repreError,preError)
        [stegopreI1,reImg] = reImgOp2(stegoI,L,repreError,e,preI);
        payload=payload-numP*2;
        v = isequal(emData,extData);
        if v == 1
            %                     disp('提取数据与嵌入数据完全一致！');
            
        else
            %                     disp('warning！数据提取错误。');
            aaaa=aaaa+1;
        end
        %
        v2 = psnr(reImg,I);
        if v2 == -1
            %                     disp('恢复图像与原图像完全一致！');
        else
            %                     disp('warning！图像不一致。');
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
        jpeg_write(jpeg_info_stego,['stego_Lena',num2str(iiii),num2str(iii),'.jpg']);%保存载密jpeg图像
        
    end
end

