function [ numData2,extData,recoI ] = extract( stegoI,payload )
%EXTRACT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[m,n] = size(stegoI);
recoI = stegoI;
rand('seed',1);s = round(rand(512,512)*255);%�ٴ���� �ָ�ÿ�����غ�7λ
numData2 = 0;
extData = zeros();
for i =2:m
   for j = 2 :n
       if numData2 == payload
            break;
       end
       extData(numData2+1) = fix(stegoI(i,j)/128);
       numData2 = numData2 +1;
   end
end

%% ͼ���ع� 
for i = 1:m
    for j = 1:n
        recoI(i,j) = bitxor(stegoI(i,j),s(i,j));
    end
end
error1 = recoI;
error2 = recoI;
numData = 0;
for i = 2:m     %Ԥ��MSB
    for j = 2:n
        if numData == payload
            break;
        end
        error1(i,j) = abs(round((recoI(i-1,j)+recoI(i,j-1))/2) - recoI(i,j));
        error2(i,j) = abs(round((recoI(i-1,j)+recoI(i,j-1))/2) - mod(recoI(i,j)+128,256));
        if error1(i,j) >= error2(i,j)
            recoI(i,j) = mod(recoI(i,j)+128,256);
        end
        numData = numData +1;
    end
end

end

