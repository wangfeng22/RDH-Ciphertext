function L = EMD(L,T,data)
P = T;
pos = 1;
payload = length(data);
while(pos < payload)
    % �ȴ�������
    flag = 0; %ǰһ��P��λ��
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
    % ������
    flag = 0;
    P = -P; %���ø���
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
    P = -P; %��ԭ
    if pos < payload
        P = P - 1;
    else break;
    end
end
end