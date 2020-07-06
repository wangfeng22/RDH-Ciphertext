function [RI] = BitPlanes_Embed(I,Plane,pl)
% ����˵������λƽ�����PlaneǶ�뵽ͼ��I�еĵ�pl��λƽ��
% ���룺I��ԭʼͼ�����,Plane��λƽ�����,pl��λƽ�棩
% �����RI���滻λƽ����ͼ�����

RI = I;
[row,col] = size(I);   
index = 8 - pl + 1; %���ص�pl��λƽ�������
for i=1:row
    for j=1:col
        value = I(i,j); %ԭʼ����ֵ
        [bin2_8] = BinaryConversion_10_2(value); %������ֵvalueת����8λ��������
        bin2_8(index) = Plane(i,j); %�滻��Ӧλƽ��ı���ֵ
        [value] = BinaryConversion_2_10(bin2_8); %���滻λƽ��Ķ�����ת����ʮ������
        RI(i,j) = value;
    end
end