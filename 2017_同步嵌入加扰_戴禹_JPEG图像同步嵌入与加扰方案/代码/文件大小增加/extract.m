function [extData,numP] = extract(stegoI,L,e,repreError,b)
[m,n] = size(stegoI);
numP = 0;
extData = [];
%��һ����ȡ
 if L >= 1
     %��һ����ȡ
    for i = 2:2:m-2
       for j = 2:n-1
           if repreError(i,j) >= -e && repreError(i,j) <= e
               numP = numP +1;
               x  = dec2bin(stegoI(i,j),b) - '0';
               extData = [extData x(1:b)];
           end
       end
    end
    %�ڶ�����ȡ
    for i = 3:2:m-1
        for j = 2:2:n-2
           if repreError(i,j) >= -e && repreError(i,j) <= e
               numP = numP +1;
               x  = dec2bin(stegoI(i,j),b) - '0';
               extData = [extData x(1:b)];
           end
        end
    end
 end
 L = L -1;
 %% �ڶ�����ȡ
if L >= 1
    t = 0;
    %ȡ��һ��ο�Ԥ�����
    repreError2 = zeros(m/2,n/2);
    stegoI2 = zeros(m/2,n/2);
    for j = 1:2:n-1
        for i = 1:2:m-1
            t = t +1;
            %I2(t) = stegoI(i,j);
            repreError2(t) = repreError(i,j);
            stegoI2(t) = stegoI(i,j);
        end
    end
    %��һ����ȡ
    for i = 2:2:m/2-2
        for j = 2:n/2-1
           if repreError2(i,j) >= -e && repreError2(i,j) <= e
               numP = numP +1;
               x  = dec2bin(stegoI2(i,j),b) - '0';
               extData = [extData x(1:b)];
           end
        end
    end
    %�ڶ�����ȡ
    for i = 3:2:m/2-1
        for j = 2:2:n/2-2
           if repreError2(i,j) >= -e && repreError2(i,j) <= e
               numP = numP +1;
               x  = dec2bin(stegoI2(i,j),b) - '0';
               extData = [extData x(1:b)];
           end
        end
    end
end
 L = L -1;
%% ��������ȡ
if L >= 1
    t = 0;
    %ȡ��һ��ο�Ԥ�����
    repreError3 = zeros(m/4,n/4);
    stegoI3 = zeros(m/4,n/4);
    for j = 1:4:n-3
        for i = 1:4:m-3
            t = t +1;
            %I2(t) = stegoI(i,j);
            repreError3(t) = repreError(i,j);
            stegoI3(t) = stegoI(i,j);
        end
    end
    %��һ����ȡ
    for i = 2:2:m/4-2
        for j = 2:n/4-1
           if repreError3(i,j) >= -e && repreError3(i,j) <= e
               numP = numP +1;
               x  = dec2bin(stegoI3(i,j),b) - '0';
               extData = [extData x(1:b)];
           end
        end
    end
    %�ڶ�����ȡ
    for i = 3:2:m/4-1
        for j = 2:2:n/4-2
           if repreError3(i,j) >= -e && repreError3(i,j) <= e
               numP = numP +1;
               x  = dec2bin(stegoI3(i,j),b) - '0';
               extData = [extData x(1:b)];
           end
        end
    end
end
end