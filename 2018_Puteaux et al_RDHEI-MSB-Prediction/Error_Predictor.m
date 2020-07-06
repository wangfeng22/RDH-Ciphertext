function [error_location_map] = Error_Predictor(origin_I)
% 函数说明：生成原始图像的MSB错误预测位置图
% 输入：origin_I（原始图像）
% 输出：error_location_map（MSB错误预测位置图）

[row,col] = size(origin_I); %统计图像的行列数
%% 生成原始图像的MSB错误预测位置图
error_location_map = zeros(row,col);
for i = 2 : row  %第一行第一列为参考像素
    for j = 2 : col
        %-----------------------计算当前像素的预测值-----------------------%
%         if abs(origin_I(i-1,j)-origin_I(i,j)) < abs(origin_I(i,j-1)-origin_I(i,j))
%             pred = origin_I(i-1,j);
%         else
%             pred = origin_I(i,j-1);
%         end
        pred = round((origin_I(i-1,j)+origin_I(i,j-1))/2);
        %-------------------------MSB预测错误判断-------------------------%
        inv = mod((origin_I(i,j)+128),256); %计算当前像素值MSB翻转后的值
        error1 = abs( pred - origin_I(i,j) ); %预测值与原始值之差的绝对值
        error2 = abs( pred - inv ); %预测值与MSB翻转值之差的绝对值
        if error1 < error2
            error_location_map(i,j) = 0; %0表示无错，即预测值接近于原始值，可嵌入信息
        else
            error_location_map(i,j) = 1; %1表示有错，即预测值接近于翻转值，不可嵌入信息
        end
    end
end