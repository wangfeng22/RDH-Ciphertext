function [stegoI,numPixel,numData,emData,repreError,repreI] = embed(preI,preError,Data,e,I,L,b)
numPixel = 0;
numData = 0;
stegoI = I;
[m,n] = size(preError);
%第一段嵌入
for i = 2:2:m-2
    for j = 2:n-1
      %% 误差值分类标记
%       error = preError(i,j);
% %       [numPixel,d1d2] = errorFlag(error,numPixel);
       if e>=1 && e <=4
           if preError(i,j) >= -e && preError(i,j)<= -1
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) ==0
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 1 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e>=5 && e <=13
           if preError(i,j) >= -e && preError(i,j)<= -2
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) >= -1 && preError(i,j)<= 1
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 2 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e>=14 && e <=22
           if preError(i,j) >= -e && preError(i,j)<= -3
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) >= -2 && preError(i,j)<= 2
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 3 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e>=23 && e <=31
           if preError(i,j) >= -e && preError(i,j)<= -4
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) >= -3 && preError(i,j)<= 3
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 4 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e == 0
           if preError(i,j) == 0
               d1d2 = [1,0];
               numPixel = numPixel +1;
           end
       end
       %% 数据嵌入
       if preError(i,j) >= -e && preError(i,j) <= e
           data_8 = Data((numPixel-1)*b+1:numPixel*b); %嵌入的数据
           stegoI(i,j) = bin2dec(num2str(data_8));  %转换十进制赋值
           numData = numData + b;
%              data_8 = Data((numPixel-1)*8+1:numPixel*8);
%              stegoI(i,j) = bin2dec(num2str(data_8));
%              numData = numData + 8;
%        else
%             x = dec2bin(stegoI(i,j),8) - '0';
%             x(1:2) = [0,0]; %设置00表示没嵌入数据
%             stegoI(i,j) = bin2dec(num2str(x));
       end
    end
end
%% 第二段嵌入
for i = 3:2:m-1
    for j = 2:2:n-2
      %% 误差值分类标记
%        error = preError(i,j);
%       [numPixel,d1d2] = errorFlag(error,numPixel,e);
       if e>=1 && e <=4
           if preError(i,j) >= -e && preError(i,j)<= -1
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) ==0
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 1 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e>=5 && e <=13
           if preError(i,j) >= -e && preError(i,j)<= -2
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) >= -1 && preError(i,j)<= 1
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 2 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e>=14 && e <=22
           if preError(i,j) >= -e && preError(i,j)<= -3
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) >= -2 && preError(i,j)<= 2
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 3 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e>=23 && e <=31
           if preError(i,j) >= -e && preError(i,j)<= -4
               d1d2 = [0,1];
               numPixel = numPixel +1;
           elseif preError(i,j) >= -3 && preError(i,j)<= 3
               d1d2 = [1,0];
               numPixel = numPixel +1;
           elseif preError(i,j) >= 4 && preError(i,j)<= e
               d1d2 = [1,1];
               numPixel = numPixel +1;
           end
       elseif e == 0
             if preError(i,j) == 0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
             end
       end
       %% 数据嵌入
       if preError(i,j) >= -e && preError(i,j) <= e
           data_8 = Data((numPixel-1)*b+1:numPixel*b); %嵌入的数据
           stegoI(i,j) = bin2dec(num2str(data_8));  %转换十进制赋值
           numData = numData + b;
%            data_8 = Data((numPixel-1)*8+1:numPixel*8);
%            stegoI(i,j) = bin2dec(num2str(data_8));
%            numData = numData + 8;
       end
    end
end
L = L -1; %
%% 二层嵌入
if L >= 1
    t = 0;
    %取出一层参考像素
    I2 = zeros(m/2,n/2);
    for j = 1:2:n-1
        for i = 1:2:m-1
            t = t +1;
            I2(t) = stegoI(i,j);
%             I2(t) = I(i,j);
        end
    end
    stegoI2 = I2;
    %计算预测误差
    [preI2,preError2] = preOp(I2);
    %第一段嵌入
    for i = 2:2:m/2-2
        for j = 2:n/2-1
          %% 误差值分类标记
    %       error = preError(i,j);
    % %       [numPixel,d1d2] = errorFlag(error,numPixel);
           if e>=1 && e <=4
               if preError2(i,j) >= -e && preError2(i,j)<= -1
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) ==0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 1 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=5 && e <=13
               if preError2(i,j) >= -e && preError2(i,j)<= -2
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= -1 && preError2(i,j)<= 1
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 2 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=14 && e <=22
               if preError2(i,j) >= -e && preError2(i,j)<= -3
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= -2 && preError2(i,j)<= 2
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 3 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=23 && e <=31
               if preError2(i,j) >= -e && preError2(i,j)<= -4
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= -3 && preError2(i,j)<= 3
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 4 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e == 0
               if preError2(i,j) == 0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               end
           end
           %% 数据嵌入
           if preError2(i,j) >= -e && preError2(i,j) <= e
               data_8 = Data((numPixel-1)*b+1:numPixel*b); %嵌入的数据
               stegoI2(i,j) = bin2dec(num2str(data_8));  %转换十进制赋值
               numData = numData + b;
%               data_8 = Data((numPixel-1)*8+1:numPixel*8);
%               stegoI(i,j) = bin2dec(num2str(data_8));
%               numData = numData + 8;
           end
        end
    end
    %% 第二段嵌入
    for i = 3:2:m/2-1
        for j = 2:2:n/2-2
          %% 误差值分类标记
    %        error = preError(i,j);
    %       [numPixel,d1d2] = errorFlag(error,numPixel,e);
           if e>=1 && e <=4
               if preError2(i,j) >= -e && preError2(i,j)<= -1
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) ==0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 1 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=5 && e <=13
               if preError2(i,j) >= -e && preError2(i,j)<= -2
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= -1 && preError2(i,j)<= 1
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 2 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=14 && e <=22
               if preError2(i,j) >= -e && preError2(i,j)<= -3
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= -2 && preError2(i,j)<= 2
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 3 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=23 && e <=31
               if preError2(i,j) >= -e && preError2(i,j)<= -4
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= -3 && preError2(i,j)<= 3
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError2(i,j) >= 4 && preError2(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e == 0
                 if preError2(i,j) == 0
                       d1d2 = [1,0];
                       numPixel = numPixel +1;
                 end
           end
           %% 数据嵌入
           if preError2(i,j) >= -e && preError2(i,j) <= e
               data_8 = Data((numPixel-1)*b+1:numPixel*b); %嵌入的数据
               stegoI2(i,j) = bin2dec(num2str(data_8));  %转换十进制赋值
               numData = numData + b;
%               data_8 = Data((numPixel-1)*8+1:numPixel*8);
%               stegoI(i,j) = bin2dec(num2str(data_8));
%               numData = numData + 8;
           end
        end
    end
    %二层嵌入数据归为到顶层图像中
    t = 0;
    for j = 1:2:n-1
        for i = 1:2:m-1
            t = t +1;
            %I2(t) = stegoI(i,j);
            stegoI(i,j) = stegoI2(t);
            preError(i,j) = preError2(t);%预测误差回归顶层
            preI(i,j) = preI2(t);
        end
    end
end %if L

%% 第三层嵌入
L = L -1; %
if L >= 1
     t = 0;
    %取出二层参考像素
    I3 = zeros(m/4,n/4);
   % I4 = zeros(m/4,n/4);
    for j = 1:4:n-3
        for i = 1:4:m-3
            t = t +1;
           % I4(t) = stegoI(i,j);
            I3(t) = I(i,j);
        end
    end
    stegoI3 = I3;
    %计算预测误差
    [preI3,preError3] = preOp(I3);
    %第一段嵌入
    for i = 2:2:m/4-2
        for j = 2:n/4-1
          %% 误差值分类标记
    %       error = preError(i,j);
    % %       [numPixel,d1d2] = errorFlag(error,numPixel);
           if e>=1 && e <=4
               if preError3(i,j) >= -e && preError3(i,j)<= -1
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) ==0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 1 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=5 && e <=13
               if preError3(i,j) >= -e && preError3(i,j)<= -2
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= -1 && preError3(i,j)<= 1
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 2 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=14 && e <=22
               if preError3(i,j) >= -e && preError3(i,j)<= -3
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= -2 && preError3(i,j)<= 2
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 3 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=23 && e <=31
               if preError3(i,j) >= -e && preError3(i,j)<= -4
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= -3 && preError3(i,j)<= 3
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 4 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e == 0
               if preError3(i,j) == 0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               end
           end
           %% 数据嵌入
           if preError3(i,j) >= -e && preError3(i,j) <= e
               data_8 = Data((numPixel-1)*b+1:numPixel*b); %嵌入的数据
               stegoI3(i,j) = bin2dec(num2str(data_8));  %转换十进制赋值
               numData = numData + b;
%                data_8 = Data((numPixel-1)*8+1:numPixel*8);
%                stegoI(i,j) = bin2dec(num2str(data_8));
%                numData = numData + 8;
           end
        end
    end
    %% 第二段嵌入
    for i = 3:2:m/4-1
        for j = 2:2:n/4-2
          %% 误差值分类标记
    %        error = preError(i,j);
    %       [numPixel,d1d2] = errorFlag(error,numPixel,e);
           if e>=1 && e <=4
               if preError3(i,j) >= -e && preError3(i,j)<= -1
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) ==0
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 1 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=5 && e <=13
               if preError3(i,j) >= -e && preError3(i,j)<= -2
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= -1 && preError3(i,j)<= 1
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 2 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=14 && e <=22
               if preError3(i,j) >= -e && preError3(i,j)<= -3
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= -2 && preError3(i,j)<= 2
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 3 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e>=23 && e <=31
               if preError3(i,j) >= -e && preError3(i,j)<= -4
                   d1d2 = [0,1];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= -3 && preError3(i,j)<= 3
                   d1d2 = [1,0];
                   numPixel = numPixel +1;
               elseif preError3(i,j) >= 4 && preError3(i,j)<= e
                   d1d2 = [1,1];
                   numPixel = numPixel +1;
               end
           elseif e == 0
                 if preError3(i,j) == 0
                       d1d2 = [1,0];
                       numPixel = numPixel +1;
                 end
           end
           %% 数据嵌入
           if preError3(i,j) >= -e && preError3(i,j) <= e
               data_8 = Data((numPixel-1)*b+1:numPixel*b); %嵌入的数据
               stegoI3(i,j) = bin2dec(num2str(data_8));  %转换十进制赋值
               numData = numData + b;
%               data_8 = Data((numPixel-1)*8+1:numPixel*8);
%               stegoI(i,j) = bin2dec(num2str(data_8));
%               numData = numData + 8;
           end
        end
    end
     %二层嵌入数据归为到顶层图像中
     t = 0;
   for j = 1:4:n-3
        for i = 1:4:m-3
            t = t +1;
            stegoI(i,j) = stegoI3(t);
            preError(i,j) = preError3(t);%预测误差回归顶层
            preI(i,j) = preI3(t);
        end
    end
end%if L
emData = Data(1:numData);
repreError = preError;
repreI = preI;
end%function