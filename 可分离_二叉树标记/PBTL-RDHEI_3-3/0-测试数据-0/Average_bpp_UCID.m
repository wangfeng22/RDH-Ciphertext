clear
clc 
load('num_UCID.mat'); %��ȡ����
load('bpp_UCID.mat');
len = length(num_UCID);
error_Data = 0;
error_Data_Image = zeros(); %�洢������Ϣ������Ƕ������ͼ��ID
error_Side = 0;
error_Side_Image = zeros(); %�洢�޷���ȡȫ��������Ϣ��ͼ��ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %�洢��ȡ���ݻ�ָ�ͼ����ȷ��ͼ��ID
num_True = 0; %ͳ����ȷ��ȡ�ָ�ͼ�����Ŀ
num_bpp = 0;
for i=1:len
    if num_UCID(i) == -1 %������Ϣ������Ƕ����������Ƕ������
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_UCID(i) == -1 %��ʾ��Ƕ����Ϣ���޷���ȡ
        error_Side = error_Side + 1;
        error_Side_Image(error_Side) = i;
    elseif bpp_UCID(i)==-2 || bpp_UCID(i)==-3 || bpp_UCID(i)==-4
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        num_True = num_True + 1;
        num_bpp = num_bpp +  bpp_UCID(i);
    end
end
ave_bpp = num_bpp/num_True; %��ȷͼ���ƽ��Ƕ����