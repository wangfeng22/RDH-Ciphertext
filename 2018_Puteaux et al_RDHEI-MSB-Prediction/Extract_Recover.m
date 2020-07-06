function [recover_I,exD] = Extract_Recover( stego_I,num,K_e,marked_block,error_location_map)
% 函数说明：从载密图像中提取秘密信息并恢复原始图像
% 输入：stego_I（载密图像）,num（嵌入的秘密信息数目）,K_e（图像加密密钥）,marked_block（MSB错误预测的分块标记图）,error_location_map（MSB错误预测位置图）
% 输出：recover_I（恢复图像）,exD（提取的数据）

[row,col] = size(stego_I); %统计图像的行列数
exD = zeros();
num_exD = 0; %计数
%% 数据提取
for i = 2:row 
    for j = 1:8:col
        if marked_block(i,(j+7)/8) == 0
            if j == 1 
                for k = j+1:j+7
                    if num_exD == num
                        break;
                    end
                    exD(num_exD+1) = fix(stego_I(i,k)/128); %朝零方向取整
                    num_exD = num_exD +1;
                end
            else
                for k = j:j+7
                    if num_exD == num
                        break;
                    end
                    exD(num_exD+1) = fix(stego_I(i,k)/128); %朝零方向取整
                    num_exD = num_exD +1;
                end
            end
        end
    end
end
%% 根据图像加密密钥解密图像stego_I
encrypt_I = stego_I;
rand('seed',K_e); %设置种子
E = round(rand(row,col)*255); %随机生成row*col矩阵
for i=1:row
    for j=1:col
        encrypt_I(i,j) = bitxor(stego_I(i,j),E(i,j));
    end
end
%% 图像像素MSB的恢复
recover_I = encrypt_I;
for i = 2 : row  %第一行第一列为参考像素
    for j = 2 : col
        %-----------------------计算当前像素的预测值-----------------------%
        pred = round((recover_I(i-1,j)+recover_I(i,j-1))/2);
        %------------------------原始MSB的预测恢复-------------------------%
        inv = mod((recover_I(i,j)+128),256); %计算当前像素值MSB翻转后的值
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