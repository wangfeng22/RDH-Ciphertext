function [NL,MAX,MIN] = Noise_Level(I,context)
% ����˵��������Ԥ��������ͼ��I��ÿ�����ص�����ˮƽ�Լ�Ԥ�����ݵ����ֵ����Сֵ
% ���룺I��ͼ�����,context��Ԥ�����ظ�����
% �����NL������ˮƽ��,MAX��Ԥ�����ݵ����ֵ��,MIN��Ԥ�����ݵ���Сֵ��
[row,col] = size(I);
block = ceil(sqrt(context+1)); %�ֿ��С(����������ȡ��)
NL = I;
MAX = I;
MIN = I;
for i=1:row-block+1
    for j=1:col-block+1 
        [U] = Context_Pixels(I,context,i,j); %��ǰ���ص�Ԥ������
        max_U = max(U); %���ֵ
        min_U = min(U); %��Сֵ
        nl = max_U - min_U; %����ˮƽ
        NL(i,j) = nl;
        MAX(i,j) = max_U;
        MIN(i,j) = min_U;
    end
end  