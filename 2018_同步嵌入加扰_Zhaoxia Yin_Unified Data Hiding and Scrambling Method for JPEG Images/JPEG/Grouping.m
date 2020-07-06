function [Q,G,k] = Grouping(P)
%P表示分块RLE序列对，Q表示排序,G表示分组情况,k表示分组数
[~,L]=size(P); %统计分块RLE序列对的个数
g_P = zeros(3,L); %暂存分组情况及RLE序列对个数
%% 先将P排序，表示为Q
Q = P; %用来记录排序后的RLE序列对
e = zeros(1,L); %用来记录差值
for i=1:L  %计算差值
    e(i) = abs(P(1,i))-abs(P(2,i));
end
for i=1:L  %冒泡排序
    for j=i+1:L 
        if e(i)>e(j)  %比较差值,小的放前面 
            m = Q(1,i); %交换RLE序列对
            n = Q(2,i);
            Q(1,i) = Q(1,j);
            Q(2,i) = Q(2,j);
            Q(1,j) = m;
            Q(2,j) = n;
            x = e(i);  %交换差值
            e(i) = e(j);
            e(j) = x;
        elseif e(i)==e(j)
            if Q(1,i)>Q(1,j) %比较零值个数,小的放前面 
                 m = Q(1,i); %交换RLE序列对
                 n = Q(2,i);
                 Q(1,i) = Q(1,j);
                 Q(2,i) = Q(2,j);
                 Q(1,j) = m;
                 Q(2,j) = n;  
                 x = e(i);  %交换差值
                 e(i) = e(j);
                 e(j) = x;
            elseif Q(1,i)==Q(1,j)
                if Q(2,i)>Q(2,j) %比较AC系数值,小的放前面 
                    m = Q(1,i);  %交换RLE序列对 
                    n = Q(2,i);
                    Q(1,i) = Q(1,j);
                    Q(2,i) = Q(2,j);
                    Q(1,j) = m;
                    Q(2,j) = n;
                    x = e(i);  %交换差值
                    e(i) = e(j);
                    e(j) = x;
                end
            end
        end
    end
end
%% 分组，并统计个数
k = 0; %分组的数量
num = 1; %每个分组RLE数目 
if L==1  %分块只有一个RLE
     k=k+1;     
     g_P(1,k) = Q(1,1);      
     g_P(2,k) = Q(2,1);      
     g_P(3,k) = 1;
else % L > 1   
    for j=1:L  
        if j < L        
            if Q(1,j)==Q(1,j+1) && Q(2,j)==Q(2,j+1)            
                num = num+1;       
            else %前后两个RLE序列对不一样          
                k=k+1; %分组数量加1           
                g_P(1,k) = Q(1,j);           
                g_P(2,k) = Q(2,j);           
                g_P(3,k) = num;        
                num = 1; %计数重置       
            end           
        elseif j==L
            if Q(1,j-1)==Q(1,j) && Q(2,j-1)==Q(2,j) %最后两个RLE一样
                k=k+1;          
                g_P(1,k) = Q(1,j);           
                g_P(2,k) = Q(2,j);            
                g_P(3,k) = num;       
            else  %最后两个RLE不一样          
                k=k+1;          
                g_P(1,k) = Q(1,j);           
                g_P(2,k) = Q(2,j);            
                g_P(3,k) = num;  
            end           
        end        
    end
end
G = g_P(1:3,1:k); %获取已记录的分组情况
end