function [ imageEn,Ed2,EA,ED2,Ed11,Ed12 ] = Image_encryption( imageOri )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[row,col]=size(imageOri);
imageD1=zeros(row,col);
for i=8:-1:1
    A_bitplane=bitget(imageOri,i);
    imageD1=imageD1+double(bitshift(A_bitplane,8-i));
end
Ed11=4;
Ed12=4;
M1=row/Ed11;
N1=col/Ed12;
ED2=randperm(M1*N1);%产生指定范围不重复的向量
ED2=reshape(ED2,M1,N1);
Block_row = Ed11 * ones(1,M1);%生成长度为row/Ed11的全Ed11矩阵
Block_col = Ed12 * ones(1,N1);
imageD1Block = mat2cell(imageD1,Block_row,Block_col);%把原来的图像矩阵分割成Ed11*Ed12的Block
imageD2=cell(M1,N1);
for i=1:M1
    for j=1:N1
        m1=ceil(ED2(i,j)/M1);
        if (mod(ED2(i,j),M1))==0
            n1=N1;
        else
            n1=mod(ED2(i,j),M1);
        end
        imageD2{m1,n1}=imageD1Block{i,j};
    end
end
imageD2=cell2mat(imageD2);
% Arnold transform
Ed2=2;
M2=row/Ed2;
N2=col/Ed2;
C=3;%变换周期
EA=1+(C-2)*round(rand(M2,N2));
Block_row = Ed2 * ones(1,M2);%生成长度为row/Ed11的全Ed11矩阵
Block_col = Ed2 * ones(1,N2);
imageD2Block = mat2cell(imageD2,Block_row,Block_col);%把原来的图像矩阵分割成Ed11*Ed12的Block
imageAD=cell(M2,N2);
for i=1:M2
    for j=1:N2
       imageAD{i,j}= Arnold_Disorder(imageD2Block{i,j},EA(i,j));
    end
end
imageEn=cell2mat(imageAD);
end

