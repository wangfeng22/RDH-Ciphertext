function [n] = GetSideInfo(P)
%P��ʾ�ֿ�RLE���жԣ�n��ʾ����Ϣ
[~,L]=size(P);  %ͳ�Ʒֿ�RLE���жԵĸ���
dV_P = zeros(1,L); %������¼ÿ��RLE���жԵĲ�ֵ
n = zeros(1,L); %�洢ÿ��RLE���жԵı���Ϣ
%% ����RLE��ֵ,����ֵ���
for j=1:L  
    dV_P(j) = abs(P(1,j))-abs(P(2,j));
end
%% �������Ϣ
i=1;%����
for j=1:L
    sort_P = P(1:2,j:L); %ɾ��P��ǰ��j-1��
    e = dV_P(j:L); %sort_P������RLE��Ӧ�Ĳ�ֵ
    num = 1; %������¼RLE���ж�������λ��
    %---�ж�sort_P(1,1)������ڵڼ�λ---%
    for m=2:L-j+1 
        if e(1)>e(m) %���ݲ�ֵe�Ĵ�С����
            num = num+1;      
        elseif e(1)==e(m) %��ֵe��ȵ������
            if sort_P(1,1)>sort_P(1,m) %������ֵ��������
                num = num+1;
            elseif sort_P(1,1)==sort_P(1,m) %��ֵ����Ҳ��ȵ������
                if sort_P(2,1)>sort_P(2,m)  %����ACϵ����С����
                    num = num+1;
                else %sort_P(2,1)<=sort_P(2,m)
                    continue;  %ACϵ��ֵС
                end
            else %sort_P(1,1)<sort_P(1,m)
                continue;  %0ֵ������
            end
        else %e(1)<e(m)
            continue;  %��ֵС
        end
    end
    n(i) = num;
    i=i+1;
end