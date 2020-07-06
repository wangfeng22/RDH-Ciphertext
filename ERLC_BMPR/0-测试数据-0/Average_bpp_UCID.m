clear
clc
%% ��ȡ����
load('num_UCID.mat'); %��ȡ����,Ƕ������
load('bpp_UCID.mat'); %��ȡ����,Ƕ����
load('len_UCID.mat'); %��ȡ����,λƽ��ѹ������
load('room_UCID.mat');%��ȡ����,λƽ��ѹ���ռ�
%% ͳ��ͼ�����ݼ���ƽ��Ƕ���ʺʹ���ͼ��ID�Լ����Ƕ���ʺ���СǶ����
len = length(num_UCID); %���ݼ�ͼ�����
error_Data = 0;
error_Data_Image = zeros(); %�洢������Ϣ������Ƕ������ͼ��ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %�洢��ȡ���ݻ�ָ�ͼ����ȷ��ͼ��ID
total_True = 0;%ͳ����ȷ��ȡ�ָ�ͼ�����Ŀ
total_bpp = 0; %������ͳ����ȷͼ�����Ƕ����
Best_Image_bpp = 0;%��¼���ݼ��е����Ƕ����
Best_Image_id = 0; %��¼ͼ��ID
Worst_Image_bpp = 8;%��¼���ݼ��е���СǶ����
Worst_Image_id = 0; %��¼ͼ��ID
for i=1:len
    if num_UCID(i)==-1 && bpp_UCID(i)==0 %������Ϣ������Ƕ����������Ƕ������
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_UCID(i)==-1 || bpp_UCID(i)==-2 || bpp_UCID(i)==-3
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        total_True = total_True + 1;
        total_bpp = total_bpp + bpp_UCID(i);
        if bpp_UCID(i) > Best_Image_bpp
            Best_Image_bpp = bpp_UCID(i);
            Best_Image_id = i;
        end
        if bpp_UCID(i) < Worst_Image_bpp
            Worst_Image_bpp = bpp_UCID(i);
            Worst_Image_id = i;
        end
    end
end
ave_bpp = total_bpp/total_True; %��ȷͼ���ƽ��Ƕ����
%% ͳ�����ݼ���ÿ��λƽ���ѹ�����
Comp_BitPlane = zeros(1,8);
for i=1:len
    for j=1:8
        if room_UCID(j,i) ~= 0 %��ʾλƽ����ѹ���ռ䣬����ѹ��
            Comp_BitPlane(j) = Comp_BitPlane(j)+1;
        end
    end
end
%% ͳ�����ݼ���ÿ��λƽ���ƽ��ѹ����
Comp_Ratio = zeros(1,8); %��¼λƽ���ѹ����
for i=1:8
    total_comp_len = 0;
    num_len = 0;
    for j=1:len
        if len_UCID(i,j) ~= 0 % %��ʾλƽ���ѹ��
            num_len = num_len+1; 
            total_comp_len = total_comp_len + len_UCID(i,j);
        end
    end
    Comp_Ratio(i) = (total_comp_len/num_len)/(512*384);
end
%% ͳ�����ݼ���Ƕ����������3bpp��ͼ����Ŀ
bpp_3_num = 0;
bpp_3_ID = zeros();
for i=1:len
    if bpp_UCID(i) == 3 %��ʾͼ����ѹ���ռ�
        bpp_3_num = bpp_3_num+1;
        bpp_3_ID(bpp_3_num) = i;
    end
end