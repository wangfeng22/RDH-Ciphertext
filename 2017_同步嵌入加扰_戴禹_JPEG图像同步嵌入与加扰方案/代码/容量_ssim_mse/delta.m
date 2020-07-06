function d = delta(a,b,lengthflag)
if lengthflag==1
    v1=a(1,1);
    r2=b(2,1);
    v2=b(1,1);
    r1=a(2,1);
    d=abs(v1)*(r2+1)-abs(v2)*(r1+1);
else if lengthflag==2
    v1=a(1,1);
    r2=a(2,2);
    v2=a(1,2);
    r1=a(2,1);
    v7=b(1,1);
    r8=b(2,2);
    v8=b(1,2);
    r7=b(2,1);
    d=(abs(v1)+abs(v2))*(r8+r7+2)-(abs(v7)+abs(v8))*(r1+r2+2);
    end
end