function [P] = GetRLE(AC)
%AC表示分块dct系数矩阵，P表示对应的RLE序列对
[m,n] = size(AC); %统计AC矩阵的行列数
R = zeros(2,m*n); %构建存放RLE序列对的最大矩阵
L = 0; %统计RLE序列对的个数
num_0 = 0; %统计两个非零ac系数之间0的个数
for k=3:m+n
    if mod(k,2) == 1 %奇数斜向左下方遍历
        if k <= 9
            for i=1:k-1
                j = k-i;
                if AC(i,j) == 0 %非RLE序列对
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %计数重置  
                end 
            end
        else
            for i=k-8:8
                j = k-i;
                if AC(i,j) == 0 %非RLE序列对
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %计数重置  
                end
            end
        end  
    else % mod(k,2)==0  偶数斜向右上方遍历
        if k <= 9 
            for j=1:k-1
                i = k-j;
                if AC(i,j) == 0 %非RLE序列对
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %计数重置  
                end 
            end   
        else
            for j=k-8:8
                i = k-j;
                if AC(i,j) == 0 %非RLE序列对
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %计数重置  
                end 
            end 
        end
    end
end
P = R(1:2,1:L); %获取已记录的RLE序列对
end