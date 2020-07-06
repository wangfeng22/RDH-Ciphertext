function result = fenkuai(dctmatrix)
result=cell(64,64);
k=1;
for j=0:8:504
    for i=0:8:504
        result{k}=dctmatrix(i+1:i+8,j+1:j+8);
        k=k+1;
    end
end