function [ numData,emdData,stegoI ] = embed( encryptI,Data,payload )
%EMBED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[m,n] = size(encryptI);
stegoI = encryptI;
numData = 0;
for i = 2:m
    for j = 2:n
        if numData == payload
            break;
        end
        stegoI(i,j) = Data(numData+1)*128 + mod(encryptI(i,j),128);%MSBǶ��
        numData = numData +1;
    end
end
emdData = Data(1:numData);%Ƕ�������
% imshow(uint8(stegoI));
end

