clear
clc
%% ������������������
num = 10000000;
rand('seed',0); %��������
Data = round(rand(1,num)*1); %�����ȶ������
payload = 10000000;%Ƕ���������Ʊ���
%% ͼ�����ݼ���Ϣ(ucid.v2),��ʽ:TIFF,����:1338��
I_file_path = 'D:\ImageDatabase\ucid.v2\'; %����ͼ�����ݼ��ļ���·��
I_path_list = dir(strcat(I_file_path,'*.tif')); %��ȡ���ļ���������pgm��ʽ��ͼ��
img_num = length(I_path_list); %��ȡͼ��������
%% ��¼ÿ��ͼ���Ƕ����
num_UCID = zeros(1,img_num); %Ƕ����
bpp_UCID = zeros(1,img_num); %Ƕ����
%% ͼ�����ݼ�����
for i=1:img_num
    I_name = I_path_list(i).name; %ͼ����
    I = imread(strcat(I_file_path,I_name));%��ȡͼ��
    origin_I = double(I);      
    %-----------ͼ����ܼ�����Ƕ��-----------%
    [ error_location_map,preI ] = Predictor2( origin_I ); %��ͼ��λ��ͼ��Ԥ�����
    [ num1,num2 ] = comp( origin_I,preI );
    [ encryptI ] = Encrypted( origin_I );%ͼ����ܺ���
    [ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map ); %����Ƕ��
    [ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map ); %������ȡ��ͼ���ع�
    %---------------�����¼----------------%
    [m,n] = size(origin_I);
    num_UCID(i) = numData;
    bpp_UCID(i) = numData/(m*n);
    %---------------����ж�----------------%
    check1 = isequal(emdData,extData);
    check2 = isequal(recoI,I);
    if check1 == 1
        disp('��ȡ������Ƕ��������ȫ��ͬ��')
    else
        disp('Warning��������ȡ����')
    end
    if check2 == 1
        disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
    else
        disp('Warning��ͼ���ع�����')
    end
    %---------------������----------------%
    if numData > 0
        if check1 == 1 && check2 == 1
            bpp = bpp_UCID(i);
            disp(['Embedding capacity equal to : ' num2str(numData)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['�� ',num2str(i),' ��ͼ��-------- OK','\n\n']);
        else
            if check1 ~= 1 && check2 == 1
                bpp_UCID(i) = -2; %��ʾ��ȡ���ݲ���ȷ
            elseif check1 == 1 && check2 ~= 1
                bpp_UCID(i) = -3; %��ʾͼ��ָ�����ȷ
            else
                bpp_UCID(i) = -4; %��ʾ��ȡ���ݺͻָ�ͼ�񶼲���ȷ
            end
            fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
        end
    else
        bpp_UCID(i) = -1; %��ʾû��Ƕ������
        fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
    end
end
%% ��������
save('num_UCID')
save('bpp_UCID')