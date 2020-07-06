function [stego_I,emD,marked_block] = Embed_Data(encrypt_I,Data,error_location_map)
% ����˵�����ڼ���ͼ����Ƕ��������Ϣ
% ���룺encrypt_I������ͼ��,Data����Ƕ���������Ϣ��,error_location_map��MSB����Ԥ��λ��ͼ��
% �����stego_I������ͼ��,emD��Ƕ���������Ϣ��,marked_block��MSB����Ԥ��ķֿ���ͼ��

[row,col] = size(encrypt_I); %����stegoI������ֵ
stego_I = encrypt_I;  %�����洢����ͼ�������
num = numel(Data); %������Ϣ����
%% ��8������Ϊһ���ֿ�������MSB����Ԥ��λ��ͼ��ͳ�Ʋ���Ƕ��Ŀ�
flag_block = zeros(row,col/8); %�ֿ��С1*8
for i = 1:row  
    for j = 1:8:col
        sumblock = sum(error_location_map(i,j:j+7));
        if sumblock > 0
            flag_block(i,(j+7)/8) = 1;
        end
    end
end
%% �ڴ����ǰ����ӱ�ǿ� ��ǿ�Ҳ����Ƕ��
marked_block = flag_block;
for i = 1:row 
    for j = 1:col/8
        if flag_block(i,j) == 1
            if j == 1
                marked_block(i,j+1) = 1;
            elseif j == col/8
                marked_block(i,j-1) = 1;
            else
                marked_block(i,j+1) = 1;
                marked_block(i,j-1) = 1;
            end     
        end
    end
end
%% Ƕ����Ϣ����һ�е�һ�в�Ƕ�룩
num_emD = 0; %������Ƕ��������Ϣ�ĸ���
for i = 2:row  
    for j = 1:8:col
        if marked_block(i,(j+7)/8) == 0
            if j == 1 %��һ�в�Ƕ��
                for k = j+1:j+7
                    if num_emD == num
                        break;
                    end
                    stego_I(i,k) = Data(num_emD+1)*128 + mod(encrypt_I(i,k),128); %MSBǶ��
                    num_emD = num_emD +1;
                end
            else
                for k = j:j+7
                    if num_emD == num
                        break;
                    end
                    stego_I(i,k) = Data(num_emD+1)*128 + mod(encrypt_I(i,k),128); %MSBǶ��
                    num_emD = num_emD +1;
                end
            end
        end
    end
end
%% ͳ��Ƕ���������Ϣ
emD = Data(1:num_emD);
end