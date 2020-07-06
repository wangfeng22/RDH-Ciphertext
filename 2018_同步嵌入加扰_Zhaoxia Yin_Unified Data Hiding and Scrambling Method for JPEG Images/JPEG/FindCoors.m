function [x0,y0] = FindCoors(x,y,num0)
%(x,y)表示起始坐标，num0表示零值个数
xy = x + y;
for i=0:num0
    if mod(xy,2) == 1 %奇数斜向左下方遍历
        if x~=8 && y~=1
            x = x+1;
            y = y-1;
        else
            if xy <= 8 %向下移
                x = x+1;
                xy = xy+1;
            else %xy>=9,向右移
                y = y+1;
                xy = xy+1;
            end
        end  
    else %mod(xy,2)==0 偶数斜向右上方遍历
        if x~=1 && y~=8
            x = x-1;
            y = y+1;
        else
            if xy <= 8 %向右移
                y = y+1;
                xy = xy+1;
            else %xy>=9,向下移
                x = x+1;
                xy = xy+1;
            end
        end  
    end
end
x0 = x;   
y0 = y;
end