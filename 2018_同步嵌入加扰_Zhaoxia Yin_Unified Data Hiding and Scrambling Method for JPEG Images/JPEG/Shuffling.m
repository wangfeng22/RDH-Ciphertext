function [stego_I]=Shuffling(origin_I,index)
%origin_I表示原始矩阵，index表示混洗序列，stego_I表示混洗之后的矩阵
[m,n]=size(origin_I);
Shuffle = reshape(index,m,n); %换成矩阵,以列排序
x_I = zeros(1,numel(Shuffle)); %构建一维混洗容器
for j=1:n
    for i=1:m
        x = Shuffle(i,j); %（i,j）置乱的位置坐标为x
        x_I(x) = origin_I(i,j);
    end
end
stego_I=reshape(x_I,m,n);
end