function [P] = GetRLE(AC)
%AC��ʾ�ֿ�dctϵ������P��ʾ��Ӧ��RLE���ж�
[m,n] = size(AC); %ͳ��AC�����������
R = zeros(2,m*n); %�������RLE���жԵ�������
L = 0; %ͳ��RLE���жԵĸ���
num_0 = 0; %ͳ����������acϵ��֮��0�ĸ���
for k=3:m+n
    if mod(k,2) == 1 %����б�����·�����
        if k <= 9
            for i=1:k-1
                j = k-i;
                if AC(i,j) == 0 %��RLE���ж�
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %��������  
                end 
            end
        else
            for i=k-8:8
                j = k-i;
                if AC(i,j) == 0 %��RLE���ж�
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %��������  
                end
            end
        end  
    else % mod(k,2)==0  ż��б�����Ϸ�����
        if k <= 9 
            for j=1:k-1
                i = k-j;
                if AC(i,j) == 0 %��RLE���ж�
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %��������  
                end 
            end   
        else
            for j=k-8:8
                i = k-j;
                if AC(i,j) == 0 %��RLE���ж�
                    num_0 = num_0 + 1;
                else  %AC(i,j)~=0
                    L = L + 1;
                    R(1,L) = num_0;
                    R(2,L) = AC(i,j);
                    num_0 = 0; %��������  
                end 
            end 
        end
    end
end
P = R(1:2,1:L); %��ȡ�Ѽ�¼��RLE���ж�
end