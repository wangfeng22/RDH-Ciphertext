function [side]=Getside(payload,positions)
side=zeros(1,81);
%data = dec2bin(face);%����Ƕ������ת���ɶ�������ʽ
%data = strcat(char(data)', '');%����ת�����ַ�����
% data = cellstr(data)';
%data = str2num(data(:));%����ת������������

b = num2bin(quantizer([18 0]),payload);
b=strcat(char(b)','');
b=str2num(b(:));
side(1:18)=b;
len=length(positions);
for i=1:len
    side(positions(i)+18)=1;
end
end