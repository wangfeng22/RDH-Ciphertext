function [recover_I]=ReShuffling(stego_I,index)
%stego_I表示置乱矩阵，index表示混洗序列，recover_I表示恢复矩阵
[m,n]=size(stego_I);
num = numel(index);
I1 = reshape(stego_I,1,m*n); %将stego_I转换成一维
x_I = zeros(1,m*n); %构建一维恢复容器
for i=1:num
    x = index(i); %置乱的坐标
    x_I(i) = I1(x);
end
recover_I = reshape(x_I,m,n);
end