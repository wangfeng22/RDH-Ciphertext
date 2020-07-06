function [ imageDec ] = Image_Decryption( imageRev,Ed2,EA,ED2,Ed11,Ed12)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[row,col]=size(imageRev);
imageDec=zeros(row,col);
M2=row/Ed2;
N2=col/Ed2;
Block_row = Ed2 * ones(1,M2);%生成长度为row/Ed11的全Ed11矩阵
Block_col = Ed2 * ones(1,N2);
imageD2Block = mat2cell(imageRev,Block_row,Block_col);%把原来的图像矩阵分割成Ed11*Ed12的Block
imageAD=cell(M2,N2);
for i=1:M2
    for j=1:N2
        imageAD{i,j}= Arnold_recover(imageD2Block{i,j},EA(i,j));
    end
end
imageAD=cell2mat(imageAD);
M1=row/Ed11;
N1=col/Ed12;
Block_row = Ed11 * ones(1,M1);%生成长度为row/Ed11的全Ed11矩阵
Block_col = Ed12 * ones(1,N1);
imageD1Block = mat2cell(imageAD,Block_row,Block_col);%把原来的图像矩阵分割成Ed11*Ed12的Block
imageD2=cell(M1,N1);
for i=1:M1
    for j=1:N1
        if j==N1
            ED2_num=i*M1;
            [x,y]=find(ED2==ED2_num);
            imageD2{x,y}=imageD1Block{i,j};
        else
            ED2_num=M1*(i-1)+j;
            [x,y]=find(ED2==ED2_num);
            imageD2{x,y}=imageD1Block{i,j};
        end
    end
end
imageD2=cell2mat(imageD2);
for i=1:8
    A_bitplane=bitget(imageD2,i);
    imageDec=imageDec+double(bitshift(A_bitplane,8-i));
end

end

