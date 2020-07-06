clear
clc

shuju=dir('C:\Users\win8\Desktop\²âÊÔ´úÂë');
shujupic=shuju(15:44);
shujupic2=shuju(64:93);
per=zeros(1,30);
for i=1:30
    a=shujupic(i).bytes;
    b=shujupic2(i).bytes;
    per(i)=b-a;
end
per2=reshape(per,5,6)'/1000;
