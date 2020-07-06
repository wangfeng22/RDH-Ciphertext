function [stegopreI1,reImg] = reImgOp2(stegoI,L,repreError,e,preI)
[m,n] = size(stegoI);
reImg = stegoI;
%第三层恢复
if L == 3
    t = 0;
    stegoI3 = zeros(m/4,n/4);
    %取出第三层 载密图像
    for j = 1:4:n-3
        for i = 1:4:m-3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
            t = t +1;
%             %I2(t) = stegoI(i,j);
%             repreError3(t) = repreError(i,j);
            stegoI3(t) = stegoI(i,j);
        end
    end
    [stegopreI3,~] = preOp(stegoI3);%计算预测误差
    %载密预测值回归到顶层预测值中
    t = 0;
    for j = 1:4:n-3
        for i = 1:4:m-3
            t = t +1;
            stegoI(i,j) = stegopreI3(t);
        end
    end
L = L -1;
end

%% 第二层恢复
if L == 2
    %取出第二层载密图像
    t = 0;
    stegoI2 = zeros(m/2,n/2);
    for j = 1:2:n-1
        for i = 1:2:m-1
            t = t +1;
            stegoI2(t) = stegoI(i,j);
        end
    end
    [stegopreI2,~] = preOp(stegoI2);%计算预测误差
    %载密预测值回归到顶层预测值中
    t = 0;
    for j = 1:2:n-1
        for i = 1:2:m-1
            t = t +1;
            %I2(t) = stegoI(i,j);
            stegoI(i,j) = stegopreI2(t);
        end
    end
L = L -1;
end

%% 第一层恢复
if L == 1
    [stegopreI1,~] = preOp(stegoI);%计算预测值
end

%% 加上 误差值区间中值  重构
for i = 1:m
    for j = 1:n
        if e>=1 && e <=4
           if repreError(i,j) >= -e && repreError(i,j)<= -1
               repreError(i,j) = round((-e-1)/2);
           elseif repreError(i,j) ==0
               repreError(i,j) = 0;
           elseif repreError(i,j) >= 1 && repreError(i,j)<= e
               repreError(i,j) = round((1+e)/2);
           end
       elseif e>=5 && e <=13
           if repreError(i,j) >= -e && repreError(i,j)<= -2
               repreError(i,j) = round((-e-2)/2);
           elseif repreError(i,j) >= -1 && repreError(i,j)<= 1
               repreError(i,j) = round((-1+1)/2);
           elseif repreError(i,j) >= 2 && repreError(i,j)<= e
               repreError(i,j) = round((2+e)/2);
           end
       elseif e>=14 && e <=22
           if repreError(i,j) >= -e && repreError(i,j)<= -3
               repreError(i,j) = round((-e-3)/2);
           elseif repreError(i,j) >= -2 && repreError(i,j)<= 2
               repreError(i,j) = round((-2+2)/2);
           elseif repreError(i,j) >= 3 && repreError(i,j)<= e
               repreError(i,j) = round((3+e)/2);
           end
       elseif e>=23 && e <=31
           if repreError(i,j) >= -e && repreError(i,j)<= -4
              repreError(i,j) = round((-e-4)/2);
           elseif repreError(i,j) >= -3 && repreError(i,j)<= 3
               repreError(i,j) = round((-3+3)/2);
           elseif repreError(i,j) >= 4 && repreError(i,j)<= e
               repreError(i,j) = round((4+e)/2);
           end
       elseif e == 0
           if repreError(i,j) == 0
              repreError(i,j) = 0;
           end
        end  
        %%全图遍历和分块此处不同！
        if (mod(i,2)==1&&mod(j,2)==1)||i==1||j==1||i==64||j==64
        reImg(i,j) = repreError(i,j);
        else
        reImg(i,j) = repreError(i,j) + stegopreI1(i,j);
        end
       %reImg(i,j) = repreError(i,j) + preI(i,j);
    end
end
end