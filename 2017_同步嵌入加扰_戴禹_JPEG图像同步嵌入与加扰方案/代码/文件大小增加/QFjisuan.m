clear
clc
%JPEG�������ߵĵ�ǰ·�� ����ʵ�����
addpath(genpath('G:\������Ŀ\JPEGʵ�鱨��_P71514007_����\JPEG_Toolbox'));
I = imread('Lena.tiff');
I1=imread('Airplane.tiff');
I2=imread('Baboon.tiff');
I3=imread('Boat.tiff');
I4=imread('Lake.tiff');
I5=imread('Tiffany.tiff');
QF2=50:10:90;

for i123=1:5
    QF=QF2(i123);
    imwrite(I,['Pic',num2str(1),num2str(i123),'.jpg'],'jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��    
end

for i123=1:5
    QF=QF2(i123);
    imwrite(I1,['Pic',num2str(2),num2str(i123),'.jpg'],'jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I2,['Pic',num2str(3),num2str(i123),'.jpg'],'jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I3,['Pic',num2str(4),num2str(i123),'.jpg'],'jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I4,['Pic',num2str(5),num2str(i123),'.jpg'],'jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��    
end
for i123=1:5
    QF=QF2(i123);
    imwrite(I5,['Pic',num2str(6),num2str(i123),'.jpg'],'jpeg','quality',QF);%������������Ϊ quality ��JPEGͼ��    
end