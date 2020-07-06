function [Q,G,k] = Grouping(P)
%P��ʾ�ֿ�RLE���жԣ�Q��ʾ����,G��ʾ�������,k��ʾ������
[~,L]=size(P); %ͳ�Ʒֿ�RLE���жԵĸ���
g_P = zeros(3,L); %�ݴ���������RLE���жԸ���
%% �Ƚ�P���򣬱�ʾΪQ
Q = P; %������¼������RLE���ж�
e = zeros(1,L); %������¼��ֵ
for i=1:L  %�����ֵ
    e(i) = abs(P(1,i))-abs(P(2,i));
end
for i=1:L  %ð������
    for j=i+1:L 
        if e(i)>e(j)  %�Ƚϲ�ֵ,С�ķ�ǰ�� 
            m = Q(1,i); %����RLE���ж�
            n = Q(2,i);
            Q(1,i) = Q(1,j);
            Q(2,i) = Q(2,j);
            Q(1,j) = m;
            Q(2,j) = n;
            x = e(i);  %������ֵ
            e(i) = e(j);
            e(j) = x;
        elseif e(i)==e(j)
            if Q(1,i)>Q(1,j) %�Ƚ���ֵ����,С�ķ�ǰ�� 
                 m = Q(1,i); %����RLE���ж�
                 n = Q(2,i);
                 Q(1,i) = Q(1,j);
                 Q(2,i) = Q(2,j);
                 Q(1,j) = m;
                 Q(2,j) = n;  
                 x = e(i);  %������ֵ
                 e(i) = e(j);
                 e(j) = x;
            elseif Q(1,i)==Q(1,j)
                if Q(2,i)>Q(2,j) %�Ƚ�ACϵ��ֵ,С�ķ�ǰ�� 
                    m = Q(1,i);  %����RLE���ж� 
                    n = Q(2,i);
                    Q(1,i) = Q(1,j);
                    Q(2,i) = Q(2,j);
                    Q(1,j) = m;
                    Q(2,j) = n;
                    x = e(i);  %������ֵ
                    e(i) = e(j);
                    e(j) = x;
                end
            end
        end
    end
end
%% ���飬��ͳ�Ƹ���
k = 0; %���������
num = 1; %ÿ������RLE��Ŀ 
if L==1  %�ֿ�ֻ��һ��RLE
     k=k+1;     
     g_P(1,k) = Q(1,1);      
     g_P(2,k) = Q(2,1);      
     g_P(3,k) = 1;
else % L > 1   
    for j=1:L  
        if j < L        
            if Q(1,j)==Q(1,j+1) && Q(2,j)==Q(2,j+1)            
                num = num+1;       
            else %ǰ������RLE���жԲ�һ��          
                k=k+1; %����������1           
                g_P(1,k) = Q(1,j);           
                g_P(2,k) = Q(2,j);           
                g_P(3,k) = num;        
                num = 1; %��������       
            end           
        elseif j==L
            if Q(1,j-1)==Q(1,j) && Q(2,j-1)==Q(2,j) %�������RLEһ��
                k=k+1;          
                g_P(1,k) = Q(1,j);           
                g_P(2,k) = Q(2,j);            
                g_P(3,k) = num;       
            else  %�������RLE��һ��          
                k=k+1;          
                g_P(1,k) = Q(1,j);           
                g_P(2,k) = Q(2,j);            
                g_P(3,k) = num;  
            end           
        end        
    end
end
G = g_P(1:3,1:k); %��ȡ�Ѽ�¼�ķ������
end