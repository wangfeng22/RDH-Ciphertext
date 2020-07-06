clear
clc 
load('num_BOSSbase.mat'); %��ȡ����
load('bpp_BOSSbase.mat');
len = length(num_BOSSbase);
error_Data = 0;
error_Data_Image = zeros(); %û�д洢���ݵ�ͼ��ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %�洢��ȡ���ݻ�ָ�ͼ����ȷ��ͼ��ID
num_True = 0; %ͳ����ȷ��ȡ�ָ�ͼ�����Ŀ
num_bpp = 0;
for i=1:len
    if bpp_BOSSbase(i) == -1 %û��Ƕ������
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_BOSSbase(i)==-2 || bpp_BOSSbase(i)==-3 || bpp_BOSSbase(i)==-4
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        num_True = num_True + 1;
        num_bpp = num_bpp +  bpp_BOSSbase(i);
    end
end
ave_bpp = num_bpp/num_True; %��ȷͼ���ƽ��Ƕ����
%% �����Ƕ���ʺ���СǶ����
min_bpp = 10;
max_bpp = 0;
for i=1:len
    if bpp_BOSSbase(i) > max_bpp
        max_bpp = bpp_BOSSbase(i);
    end
    if bpp_BOSSbase(i) < min_bpp
        min_bpp = bpp_BOSSbase(i);
    end
end