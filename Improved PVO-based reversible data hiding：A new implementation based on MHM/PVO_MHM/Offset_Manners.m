function [Offsets] = Offset_Manners(r_s)
% ����˵��������54�鲹������
% ���룺��ʼ����������
% �����54�鲹������
Offsets = cell(0);
num = 0; %����
for i=-4:+1:31 %��ʾ����λ�� 
    if mod(i,2) == 0 %ż��ֻ��һ�����
        r_s_0 = r_s;        
        for j=0:31  %ֻ����ǰ32��ֱ��ͼ
            if i>=0 && j>=i+1
                r_s_0(1,j+1) = floor(i/2);   
                r_s_0(2,j+1) = -floor(i/2);
            elseif i<0 && j>=i+1
                r_s_0(1,j+1) = floor(i/2);   
                r_s_0(2,j+1) = -floor(i/2);
            end
        end   
        num = num+1;
        Offsets{num} = r_s_0;
    elseif mod(i,2) == 1 %�������������
        r_s_1 = r_s;
        r_s_2 = r_s;
        for j=0:31  %ֻ����ǰ32��ֱ��ͼ
            if i>=0 && j>=i+1
                r_s_1(1,j+1) = floor(i/2)+1;
                r_s_1(2,j+1) = -floor(i/2);  
                r_s_2(1,j+1) = floor(i/2);
                r_s_2(2,j+1) = -floor(i/2)-1;
            elseif i<0 && j>=i+1
                r_s_1(1,j+1) = floor(i/2)+1;
                r_s_1(2,j+1) = -floor(i/2);  
                r_s_2(1,j+1) = floor(i/2);
                r_s_2(2,j+1) = -floor(i/2)-1;
            end
        end   
        num = num+1;
        Offsets{num} = r_s_1;
        num = num+1;
        Offsets{num} = r_s_2;
    end
end