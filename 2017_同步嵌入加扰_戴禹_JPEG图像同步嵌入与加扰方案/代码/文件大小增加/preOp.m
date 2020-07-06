function [preI,preError] = preOp(I) %25%像素 预测 75%像素
preI = I;
preError = I; 
[m,n] = size(I);
%黑色块预测
for i = 2 :2 :m-2
    for j = 2 :2 :n-2
        NW = I(i-1,j-1);%对角四个参考像素
        NE = I(i-1,j+1);
        SW = I(i+1,j-1);
        SE = I(i+1,j+1);
        if abs(NE-SW) > abs(NW-SE)
            preI(i,j) = round((NW+SE)/2);
            preError(i,j) = I(i,j) - preI(i,j);
        elseif abs(NE-SW) < abs(NW-SE)
            preI(i,j) = round((NE+SW)/2);
            preError(i,j) = I(i,j) - preI(i,j);
        else
            preI(i,j) = round((NW+NE+SW+SE)/4);
            preError(i,j) = I(i,j) - preI(i,j);
        end
    end
end
%% 阴影块预测 分两段扫描
%第一段
for i = 2:2:m-2 
    for j = 3:2:n-1
        N = preI(i-1,j);%上下左右四个参考像素(一轮时左上左下右上右下)
        W = preI(i,j-1);
        S = preI(i+1,j);
        E = preI(i,j+1);
        if abs(N-S) > abs(W-E)
            preI(i,j) = round((W+E)/2);
            preError(i,j) = I(i,j) - preI(i,j);
        elseif abs(N-S) < abs(W-E)
            preI(i,j) = round((N+S)/2);
            preError(i,j) = I(i,j) - preI(i,j);
        else
            preI(i,j) = round((N+E+W+S)/4);
            preError(i,j) = I(i,j) - preI(i,j);
        end
    end
end
%第二段
for i = 3:2:m-1 
    for j = 2:2:n-2
        N = preI(i-1,j);%上下左右四个参考像素
        W = preI(i,j-1);
        S = preI(i+1,j);
        E = preI(i,j+1);
        if abs(N-S) > abs(W-E)
            preI(i,j) = round((W+E)/2);
            preError(i,j) = I(i,j) - preI(i,j);
        elseif abs(N-S) < abs(W-E)
            preI(i,j) = round((N+S)/2);
            preError(i,j) = I(i,j) - preI(i,j);
        else
            preI(i,j) = round((N+E+W+S)/4);
            preError(i,j) = I(i,j) - preI(i,j);
        end
    end
end
end