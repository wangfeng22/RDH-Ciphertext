function stegodct = recL(oridct,stegoL)
stegoBlockdct = mat2cell(oridct,8 * ones(1,64),8 * ones(1,64));
cnt = 1;
for i = 1:64
    for j = 1:64
        tempL = getZigzag(stegoBlockdct{i,j});
        tempL(5:37) = stegoL(cnt:cnt+32);
        stegoBlockdct{i,j} = antiZigzag(tempL);
        cnt = cnt + 33;
    end
end
stegodct=cell2mat(stegoBlockdct);
end