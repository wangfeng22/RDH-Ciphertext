function [x0,y0] = FindCoors(x,y,num0)
%(x,y)��ʾ��ʼ���꣬num0��ʾ��ֵ����
xy = x + y;
for i=0:num0
    if mod(xy,2) == 1 %����б�����·�����
        if x~=8 && y~=1
            x = x+1;
            y = y-1;
        else
            if xy <= 8 %������
                x = x+1;
                xy = xy+1;
            else %xy>=9,������
                y = y+1;
                xy = xy+1;
            end
        end  
    else %mod(xy,2)==0 ż��б�����Ϸ�����
        if x~=1 && y~=8
            x = x-1;
            y = y+1;
        else
            if xy <= 8 %������
                y = y+1;
                xy = xy+1;
            else %xy>=9,������
                x = x+1;
                xy = xy+1;
            end
        end  
    end
end
x0 = x;   
y0 = y;
end