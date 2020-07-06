function [value,this_end] = Huffman_DeCode(Binary,last_end)
% ������Ʊ�����Binary����һ��Huffman����ת���ɵ�����ֵ
% ���룺Binary��������ӳ�����У�,last_end����һ��ӳ�������λ�ã�
% �����value��ʮ��������ֵ����{0,1,4,5,12,13,14,30,31},end�����ν�����λ�ã�
len = length(Binary);
i = last_end+1;
t = 0; %����
if i <= len
    if i+1<=len && Binary(i)==0 %��0
        t = t + 1;
        if Binary(i+1) == 0 %��00��ʾ0
            t = t + 1;
            value = 0;
        elseif Binary(i+1) == 1 %��01��ʾ1
            t = t + 1;
            value = 1;
        end
    else  % Binary(i)==1
        if i+2<=len && Binary(i+1)==0 %��10
            t = t + 2;
            if Binary(i+2) == 0  %��100��ʾ4
                t = t + 1;
                value = 4;
            elseif Binary(i+2) == 1 %��101��ʾ5
                t = t + 1;
                value = 5;
            end
        else % Binary(i+1)==1
            if i+3<=len && Binary(i+2)==0  %��110
                t = t + 3;
                if Binary(i+3) == 0  %��1100��ʾ12
                    t = t + 1;
                    value = 12;
                elseif Binary(i+3) == 1  %��1101��ʾ13
                    t = t + 1;
                    value = 13;
                end
            else % Binary(i+2)==1
                if i+3 <= len
                    t = t + 3;
                    if Binary(i+3) == 0  %��1110��ʾ14
                        t = t + 1;
                        value = 14;
                    elseif i+4<=len && Binary(i+3)==1  %��1111
                        t = t + 1;
                        if Binary(i+4) == 0  %��11110��ʾ30
                            t = t + 1;
                            value = 30;
                        elseif Binary(i+4) == 1  %��11111��ʾ31
                            t = t + 1;
                            value = 31;
                        end
                    else
                        t = 0;   
                        value = -1; %��ʾ������Ϣ���Ȳ������޷��ָ���һ��Huffman����
                    end
                else
                    t = 0;
                    value = -1; %��ʾ������Ϣ���Ȳ������޷��ָ���һ��Huffman����
                end
            end
        end
    end
else
    t = 0;               
    value = -1; %��ʾ������Ϣ���Ȳ������޷��ָ���һ��Huffman����
end
this_end = last_end + t;
end

