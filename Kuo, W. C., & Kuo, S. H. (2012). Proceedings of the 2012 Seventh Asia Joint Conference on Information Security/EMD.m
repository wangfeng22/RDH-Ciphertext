function L = EMD(L,T,data)
P = T;
pos = 1;
payload = length(data);
while(pos < payload)
    % 先处理正数
    flag = 0; %前一个P的位置
    for i =1:135168
        if L(i) > P
            L(i) = P + 1;
            continue;
        end
        if L(i) == P && flag ~= 0
            [L,pos] = embed(L,flag,i,data,pos);
            flag = 0;
            if pos >= payload
                return;
            end
        elseif L(i) == P
            flag = i;
        end
    end
    % 后处理负数
    flag = 0;
    P = -P; %先置负数
    for i =1:135168
        if L(i) < P
            L(i) = P - 1;
            continue;
        end
        if L(i) == P && flag ~= 0
            [L,pos] = embed(L,flag,i,data,pos);
            flag = 0;
            if pos >= payload
                return;
            end
        elseif L(i) == P
            flag = i;
        end
    end
    P = -P; %还原
    if pos < payload
        P = P - 1;
    else break;
    end
end
end