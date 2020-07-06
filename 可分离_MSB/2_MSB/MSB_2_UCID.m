clear
clc
%% 产生二进制秘密数据
num = 10000000;
rand('seed',0); %设置种子
Data = round(rand(1,num)*1); %产生稳定随机数
payload = 10000000;%嵌入容量控制变量
%% 图像数据集信息(ucid.v2),格式:TIFF,数量:1338；
I_file_path = 'D:\ImageDatabase\ucid.v2\'; %测试图像数据集文件夹路径
I_path_list = dir(strcat(I_file_path,'*.tif')); %获取该文件夹中所有pgm格式的图像
img_num = length(I_path_list); %获取图像总数量
%% 记录每张图像的嵌入量
num_UCID = zeros(1,img_num); %嵌入量
bpp_UCID = zeros(1,img_num); %嵌入率
%% 图像数据集测试
for i=1:img_num
    I_name = I_path_list(i).name; %图像名
    I = imread(strcat(I_file_path,I_name));%读取图像
    origin_I = double(I);      
    %-----------图像加密及数据嵌入-----------%
    [ error_location_map,preI ] = Predictor2( origin_I ); %求图像位置图及预测误差
    [ num1,num2 ] = comp( origin_I,preI );
    [ encryptI ] = Encrypted( origin_I );%图像加密函数
    [ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map ); %数据嵌入
    [ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map ); %数据提取及图像重构
    %---------------结果记录----------------%
    [m,n] = size(origin_I);
    num_UCID(i) = numData;
    bpp_UCID(i) = numData/(m*n);
    %---------------结果判断----------------%
    check1 = isequal(emdData,extData);
    check2 = isequal(recoI,I);
    if check1 == 1
        disp('提取数据与嵌入数据完全相同！')
    else
        disp('Warning！数据提取错误！')
    end
    if check2 == 1
        disp('重构图像与原始图像完全相同！')
    else
        disp('Warning！图像重构错误！')
    end
    %---------------结果输出----------------%
    if numData > 0
        if check1 == 1 && check2 == 1
            bpp = bpp_UCID(i);
            disp(['Embedding capacity equal to : ' num2str(numData)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['第 ',num2str(i),' 幅图像-------- OK','\n\n']);
        else
            if check1 ~= 1 && check2 == 1
                bpp_UCID(i) = -2; %表示提取数据不正确
            elseif check1 == 1 && check2 ~= 1
                bpp_UCID(i) = -3; %表示图像恢复不正确
            else
                bpp_UCID(i) = -4; %表示提取数据和恢复图像都不正确
            end
            fprintf(['第 ',num2str(i),' 幅图像-------- ERROR','\n\n']);
        end
    else
        bpp_UCID(i) = -1; %表示没有嵌入数据
        fprintf(['第 ',num2str(i),' 幅图像-------- ERROR','\n\n']);
    end
end
%% 保存数据
save('num_UCID')
save('bpp_UCID')