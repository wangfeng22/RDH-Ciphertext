function [n] = GetSideInfo(P)
%P表示分块RLE序列对，n表示边信息
[~,L]=size(P);  %统计分块RLE序列对的个数
dV_P = zeros(1,L); %用来记录每个RLE序列对的差值
n = zeros(1,L); %存储每个RLE序列对的边信息
%% 计算RLE差值,绝对值相减
for j=1:L  
    dV_P(j) = abs(P(1,j))-abs(P(2,j));
end
%% 计算边信息
i=1;%计数
for j=1:L
    sort_P = P(1:2,j:L); %删除P中前面j-1列
    e = dV_P(j:L); %sort_P中所有RLE对应的差值
    num = 1; %用来记录RLE序列对排序后的位置
    %---判断sort_P(1,1)排序后在第几位---%
    for m=2:L-j+1 
        if e(1)>e(m) %根据差值e的大小升序
            num = num+1;      
        elseif e(1)==e(m) %差值e相等的情况下
            if sort_P(1,1)>sort_P(1,m) %根据零值个数升序
                num = num+1;
            elseif sort_P(1,1)==sort_P(1,m) %零值个数也相等的情况下
                if sort_P(2,1)>sort_P(2,m)  %根据AC系数大小升序
                    num = num+1;
                else %sort_P(2,1)<=sort_P(2,m)
                    continue;  %AC系数值小
                end
            else %sort_P(1,1)<sort_P(1,m)
                continue;  %0值个数少
            end
        else %e(1)<e(m)
            continue;  %差值小
        end
    end
    n(i) = num;
    i=i+1;
end