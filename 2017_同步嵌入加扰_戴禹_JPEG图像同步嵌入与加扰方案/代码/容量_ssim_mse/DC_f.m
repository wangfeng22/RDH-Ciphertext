function b = DC_f(fenkuaijieguo)
a=zeros(1,15);
for i=1:64
    for j=1:64
        if fenkuaijieguo{i,j}(1,1)==0
            a(1)=a(1)+1;
        end
        if abs(fenkuaijieguo{i,j}(1,1))==1
            a(2)=a(2)+1;
        end
        for ii=3:15
            if abs(fenkuaijieguo{i,j}(1,1))>=2^(ii-2)&&abs(fenkuaijieguo{i,j}(1,1))<=(2^(ii-1)-1)
                a(ii)=a(ii)+1;
            end
        end
    end
end
b=find(a==max(a))-1;
