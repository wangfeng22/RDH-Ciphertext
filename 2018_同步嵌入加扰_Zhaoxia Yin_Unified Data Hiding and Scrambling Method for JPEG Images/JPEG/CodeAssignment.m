function [b,c,n]=CodeAssignment(k)
%k表示分组的数量,c表示代码赋值的结果,n表示代码比特数
%b表示从所有n-1比特二进制数前面开始选取的数量
c = zeros(1,k); %记录代码赋值之后代表的十进制大小
x = log2(k);
n = ceil(x); %向上取整
if mod(x,1) ~=0
    a = 2*(k-2^(floor(x))); %向下取整
    b = 2^(floor(x)+1)-k;
else %k正好是2的整数x次方
    x=x-1; 
    a = 2*(k-2^x);
    b = 2^(x+1)-k;   
end
for i=1:b %选取b个（n-1）比特的二进制数  
    c(i) = i-1; %从前面开始选
end
j = k;
for i=1:a  %选取a个n比特的二进制数  
    c(j) = 2^n-i; %从后面开始选
    j = j-1;
end