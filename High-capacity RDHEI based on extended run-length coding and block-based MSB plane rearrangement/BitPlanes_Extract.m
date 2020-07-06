function [Plane] = BitPlanes_Extract(I,pl)
% ����˵������ͼ��I����ȡ��pl��λƽ��
% ���룺I��ͼ�����,pl��λƽ�棩
% �����Plane��λƽ�����

[row,col] = size(I);
Plane = zeros(row,col);
for i=1:row
    for j=1:col
        value = I(i,j); %��ǰλ�õ�����ֵ
        [bin2_8] = BinaryConversion_10_2(value); %������ֵvalueת����8λ��������
        index = 8 - pl + 1; %���ص�pl��λƽ�������
        Plane(i,j) = bin2_8(index); %��¼��pl��λƽ���ֵ
    end
end