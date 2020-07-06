function [index] = Offset_Select(I,context,NL,MAX,MIN,Offsets,PS)
% ����˵�������54�鲹�����������ŵ�һ�鲹������
% ���룺I��ͼ�����,context��Ԥ�����ظ�����,NL������ˮƽ��,MAX��Ԥ�����ݵ����ֵ��,MIN��Ԥ�����ݵ���Сֵ��,Offsets��54�鲹��������,PS����Ҫ��Ƕ��������
% �����index�����Ų���������������
[row,col] = size(I);
block = ceil(sqrt(context+1)); %�ֿ��С(����������ȡ��)
group = length(Offsets);
%% �ֱ����54������е�Ƕ������������ʧ��
EC = zeros(1,group); %��¼ÿ�������Ƕ������
ED = zeros(1,group); %��¼ÿ�����������ʧ��
for g=1:group
    r_s = Offsets{g};
    sum_EC = 0;
    sum_ED = 0;
    for i=1:row-block+1
        for j=1:col-block+1
            t = NL(i,j);    %����ˮƽ
            max = MAX(i,j); %Ԥ�����ݵ����ֵ
            min = MIN(i,j); %Ԥ�����ݵ���Сֵ     
            rt = r_s(1,t+1);%��Сֵ�Ĳ�������   
            st = r_s(2,t+1);%���ֵ�Ĳ������� 
            if I(i,j)-min == rt || I(i,j)-max == st
                sum_EC = sum_EC+1;
                sum_ED = sum_ED+0.5;
            elseif I(i,j)-min < rt || I(i,j)-max > st
                sum_ED = sum_ED+1;
            end      
        end
    end
    EC(g) = sum_EC;
    ED(g) = sum_ED;
end
%% ��54���е����Ų�������
ED_EC = inf; %��¼��Сʧ��Ƕ���
index = -1; %��ʾ�洢��������
for g=1:group
    temp = ED(g)/EC(g);
    if EC(g)>=PS && temp<ED_EC       
        ED_EC = temp;       
        index = g;
    end
end
end