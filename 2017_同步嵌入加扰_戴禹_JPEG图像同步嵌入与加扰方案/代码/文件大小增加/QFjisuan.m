clear
clc
%JPEG解析工具的当前路径 根据实际情况
addpath(genpath('G:\科研项目\JPEG实验报告_P71514007_戴禹\JPEG_Toolbox'));
I = imread('Lena.tiff');
I1=imread('Airplane.tiff');
I2=imread('Baboon.tiff');
I3=imread('Boat.tiff');
I4=imread('Lake.tiff');
I5=imread('Tiffany.tiff');
QF2=50:10:90;

for i123=1:5
    QF=QF2(i123);
    imwrite(I,['Pic',num2str(1),num2str(i123),'.jpg'],'jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像    
end

for i123=1:5
    QF=QF2(i123);
    imwrite(I1,['Pic',num2str(2),num2str(i123),'.jpg'],'jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I2,['Pic',num2str(3),num2str(i123),'.jpg'],'jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I3,['Pic',num2str(4),num2str(i123),'.jpg'],'jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I4,['Pic',num2str(5),num2str(i123),'.jpg'],'jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I5,['Pic',num2str(6),num2str(i123),'.jpg'],'jpeg','quality',QF);%生成质量因子为 quality 的JPEG图像    
end