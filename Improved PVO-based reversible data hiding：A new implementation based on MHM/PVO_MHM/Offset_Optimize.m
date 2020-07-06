function [opt_R_S] = Offset_Optimize(I,context,NL,MAX,MIN,R_S,PS)
% ����˵�����Բ���������һ���Ż�
% ���룺I��ͼ�����,context��Ԥ�����ظ�����,NL������ˮƽ��,MAX��Ԥ�����ݵ����ֵ��,MIN��Ԥ�����ݵ���Сֵ��,R_S��ԭ���Ĳ���������,PS����Ҫ��Ƕ��������
% �����opt_R_S���Ż�������
opt_R_S = zeros(2,32);
[row,col] = size(I);
block = ceil(sqrt(context+1)); %�ֿ��С(����������ȡ��)
for h=1:32
    ED_EC = inf; %��¼��Сʧ��Ƕ���
    for vr=-2:+1:1
        for vs=-2:+1:1
            sum_EC = 0;
            sum_ED = 0;
            for i=1:row-block+1
                for j=1:col-block+1
                    t = NL(i,j); %����ˮƽ
                    max = MAX(i,j); %Ԥ�����ݵ����ֵ
                    min = MIN(i,j); %Ԥ�����ݵ���Сֵ 
                    rt = R_S(1,t+1);%��Сֵ�Ĳ�������           
                    st = R_S(2,t+1);%���ֵ�Ĳ�������
                    if t < h-1 %��������
                        rt = rt + opt_R_S(1,t+1);
                        st = st + opt_R_S(2,t+1);
                    elseif t == h-1
                        rt = rt + vr; 
                        st = st + vs; 
                    end
                    if I(i,j)-min == rt || I(i,j)-max == st 
                        sum_EC = sum_EC+1; 
                        sum_ED = sum_ED+0.5;
                    elseif I(i,j)-min < rt || I(i,j)-max > st
                        sum_ED = sum_ED+1;
                    end  
                end
            end
            temp = sum_ED/sum_EC;
            if temp<ED_EC && sum_EC>=PS
                ED_EC = temp;
                opt_R_S(1,h) = vr;
                opt_R_S(2,h) = vs;
            end
        end
    end
end
opt_R_S = opt_R_S(1:2,1:32); %ֻȡǰ32��ֱ��ͼ�Ĳ���
end