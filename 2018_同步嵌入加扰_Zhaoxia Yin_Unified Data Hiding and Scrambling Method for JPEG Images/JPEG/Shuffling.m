function [stego_I]=Shuffling(origin_I,index)
%origin_I��ʾԭʼ����index��ʾ��ϴ���У�stego_I��ʾ��ϴ֮��ľ���
[m,n]=size(origin_I);
Shuffle = reshape(index,m,n); %���ɾ���,��������
x_I = zeros(1,numel(Shuffle)); %����һά��ϴ����
for j=1:n
    for i=1:m
        x = Shuffle(i,j); %��i,j�����ҵ�λ������Ϊx
        x_I(x) = origin_I(i,j);
    end
end
stego_I=reshape(x_I,m,n);
end