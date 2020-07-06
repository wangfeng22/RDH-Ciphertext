function [recover_I]=ReShuffling(stego_I,index)
%stego_I��ʾ���Ҿ���index��ʾ��ϴ���У�recover_I��ʾ�ָ�����
[m,n]=size(stego_I);
num = numel(index);
I1 = reshape(stego_I,1,m*n); %��stego_Iת����һά
x_I = zeros(1,m*n); %����һά�ָ�����
for i=1:num
    x = index(i); %���ҵ�����
    x_I(i) = I1(x);
end
recover_I = reshape(x_I,m,n);
end