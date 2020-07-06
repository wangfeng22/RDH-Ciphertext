function [L,pos] = embed(L,pos1,pos2,data,pos)
    %fprintf('%d\n',pos);
    P = L(pos1);
    c = data(pos) * 2 + data(pos+1);
    %排除为0的情况
    if P > 0
        switch c
            case f(P,P)
                L(pos1) = P;L(pos2) = P;
            case f(P+1,P)
                L(pos1) = P+1;L(pos2) = P;
            case f(P,P+1)
                L(pos1) = P;L(pos2) = P+1;
            case f(P+1,P+1)
                L(pos1) = P+1;L(pos2) = P+1;
        end
    elseif P < 0
        switch c
            case f(P,P)
                L(pos1) = P;L(pos2) = P;
            case f(P-1,P)
                L(pos1) = P-1;L(pos2) = P;
            case f(P,P-1)
                L(pos1) = P;L(pos2) = P-1;
            case f(P-1,P-1)
                L(pos1) = P-1;L(pos2) = P-1;
        end
    end
    pos = pos + 2;
end