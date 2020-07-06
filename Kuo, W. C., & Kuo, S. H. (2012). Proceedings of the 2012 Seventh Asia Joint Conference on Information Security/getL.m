function L = getL(oridct)
    L = zeros(1,135168);
    oriBlockdct = mat2cell(oridct,8 * ones(1,64),8 * ones(1,64));
    cnt = 1;
    for i = 1:64
        for j = 1:64
            tempL = getZigzag(oriBlockdct{i,j});
            L(cnt:cnt+32) = tempL(5:37);
            cnt = cnt + 33;
        end
    end
end