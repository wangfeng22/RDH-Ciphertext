function [ numData,emdData,stegoI ] = embed( encryptI,Data,payload )
%EMBED 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n] = size(encryptI);
stegoI = encryptI;
numData = 0;
for i = 2:m
    for j = 2:n
        if numData == payload
            break;
        end
        stegoI(i,j) = Data(numData+1)*128 + mod(encryptI(i,j),128);%MSB嵌入
        numData = numData +1;
    end
end
emdData = Data(1:numData);%嵌入的数据
% imshow(uint8(stegoI));
end

