function [recover_I,exD] = Extract_Recover( stego_I,num,K_e,marked_block,error_location_map)
% ����˵����������ͼ������ȡ������Ϣ���ָ�ԭʼͼ��
% ���룺stego_I������ͼ��,num��Ƕ���������Ϣ��Ŀ��,K_e��ͼ�������Կ��,marked_block��MSB����Ԥ��ķֿ���ͼ��,error_location_map��MSB����Ԥ��λ��ͼ��
% �����recover_I���ָ�ͼ��,exD����ȡ�����ݣ�

[row,col] = size(stego_I); %ͳ��ͼ���������
exD = zeros();
num_exD = 0; %����
%% ������ȡ
for i = 2:row 
    for j = 1:8:col
        if marked_block(i,(j+7)/8) == 0
            if j == 1 
                for k = j+1:j+7
                    if num_exD == num
                        break;
                    end
                    exD(num_exD+1) = fix(stego_I(i,k)/128); %���㷽��ȡ��
                    num_exD = num_exD +1;
                end
            else
                for k = j:j+7
                    if num_exD == num
                        break;
                    end
                    exD(num_exD+1) = fix(stego_I(i,k)/128); %���㷽��ȡ��
                    num_exD = num_exD +1;
                end
            end
        end
    end
end
%% ����ͼ�������Կ����ͼ��stego_I
encrypt_I = stego_I;
rand('seed',K_e); %��������
E = round(rand(row,col)*255); %�������row*col����
for i=1:row
    for j=1:col
        encrypt_I(i,j) = bitxor(stego_I(i,j),E(i,j));
    end
end
%% ͼ������MSB�Ļָ�
recover_I = encrypt_I;
for i = 2 : row  %��һ�е�һ��Ϊ�ο�����
    for j = 2 : col
        %-----------------------���㵱ǰ���ص�Ԥ��ֵ-----------------------%
        pred = round((recover_I(i-1,j)+recover_I(i,j-1))/2);
        %------------------------ԭʼMSB��Ԥ��ָ�-------------------------%
        inv = mod((recover_I(i,j)+128),256); %���㵱ǰ����ֵMSB��ת���ֵ
        error1 = abs( pred - recover_I(i,j) );
        error2 = abs( pred - inv ); 
        if error_location_map(i,j) == 0
            if error1 < error2
                recover_I(i,j) = recover_I(i,j);
            else
                recover_I(i,j) = inv;
            end
        elseif error_location_map(i,j) == 1
            if error1 < error2
                recover_I(i,j) = inv;
            else
                recover_I(i,j) = recover_I(i,j);
            end
        end  
    end
end