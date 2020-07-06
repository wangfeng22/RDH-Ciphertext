function [error_location_map] = Error_Predictor(origin_I)
% ����˵��������ԭʼͼ���MSB����Ԥ��λ��ͼ
% ���룺origin_I��ԭʼͼ��
% �����error_location_map��MSB����Ԥ��λ��ͼ��

[row,col] = size(origin_I); %ͳ��ͼ���������
%% ����ԭʼͼ���MSB����Ԥ��λ��ͼ
error_location_map = zeros(row,col);
for i = 2 : row  %��һ�е�һ��Ϊ�ο�����
    for j = 2 : col
        %-----------------------���㵱ǰ���ص�Ԥ��ֵ-----------------------%
%         if abs(origin_I(i-1,j)-origin_I(i,j)) < abs(origin_I(i,j-1)-origin_I(i,j))
%             pred = origin_I(i-1,j);
%         else
%             pred = origin_I(i,j-1);
%         end
        pred = round((origin_I(i-1,j)+origin_I(i,j-1))/2);
        %-------------------------MSBԤ������ж�-------------------------%
        inv = mod((origin_I(i,j)+128),256); %���㵱ǰ����ֵMSB��ת���ֵ
        error1 = abs( pred - origin_I(i,j) ); %Ԥ��ֵ��ԭʼֵ֮��ľ���ֵ
        error2 = abs( pred - inv ); %Ԥ��ֵ��MSB��תֵ֮��ľ���ֵ
        if error1 < error2
            error_location_map(i,j) = 0; %0��ʾ�޴���Ԥ��ֵ�ӽ���ԭʼֵ����Ƕ����Ϣ
        else
            error_location_map(i,j) = 1; %1��ʾ�д���Ԥ��ֵ�ӽ��ڷ�תֵ������Ƕ����Ϣ
        end
    end
end