function [PE_I] = Predictor_Error(origin_I)  
% ����˵��������origin_I��Ԥ�����
% ���룺origin_I��ԭʼͼ��
% �����PE_I��ԭʼͼ���Ԥ����
[row,col] = size(origin_I); %����origin_I������ֵ
PE_I = origin_I;  %�����洢origin_IԤ��ֵ������
for i=2:row  %��һ����Ϊ�ο����أ�����Ԥ��
    for j=2:col  %��һ����Ϊ�ο����أ�����Ԥ��
        a = origin_I(i-1,j);
        b = origin_I(i-1,j-1);
        c = origin_I(i,j-1);
        if b <= min(a,c)
            pv = max(a,c);
        elseif b >= max(a,c)
            pv = min(a,c);
        else
            pv = a + c - b;
        end
        PE_I(i,j) = origin_I(i,j) - pv;
    end
end