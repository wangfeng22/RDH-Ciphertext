clear
clc
%% ������������������
num = 10000000;
rand('seed',0); %��������
Data = round(rand(1,num)*1); %�����ȶ������
payload = 10000000;%Ƕ���������Ʊ���
%% ͼ�����ݼ���Ϣ(BOSSbase_1.01),��ʽ:PGM,����:10000��
I_file_path = 'D:\ImageDatabase\BOSSbase_1.01\'; %����ͼ�����ݼ��ļ���·��
I_path_list = dir(strcat(I_file_path,'*.pgm'));  %��ȡ���ļ���������pgm��ʽ��ͼ��
img_num = length(I_path_list); %��ȡͼ��������
%% ��¼ÿ��ͼ���Ƕ����
num_BOSSbase = zeros(1,img_num); %Ƕ����
bpp_BOSSbase = zeros(1,img_num); %Ƕ����
%% ͼ�����ݼ�����
for i=1:img_num
    I_name = I_path_list(i).name; %ͼ����
    I = imread(strcat(I_file_path,I_name));%��ȡͼ��
    origin_I = double(I);      
    %-----------ͼ����ܼ�����Ƕ��-----------%
    [ error_location_map ] = Predictor2( origin_I );%ͼ��λ��ͼԤ��
    [ encryptI ] = Encrypted( origin_I );%ͼ����ܺ���
    [ numData,emdData,stegoI,flag_mark,flag ] = embed( encryptI,Data,payload,error_location_map ); %����Ƕ��
    [ numData2,extData,recoI ] = extract( stegoI,payload,flag_mark,error_location_map ); %������ȡ��ͼ���ع�
    %---------------�����¼----------------%
    [m,n] = size(origin_I);
    num_BOSSbase(i) = numData;
    bpp_BOSSbase(i) = numData/(m*n);
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
            bpp = bpp_BOSSbase(i);
            disp(['Embedding capacity equal to : ' num2str(numData)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['�� ',num2str(i),' ��ͼ��-------- OK','\n\n']);
        else
            if check1 ~= 1 && check2 == 1
                bpp_BOSSbase(i) = -2; %��ʾ��ȡ���ݲ���ȷ
            elseif check1 == 1 && check2 ~= 1
                bpp_BOSSbase(i) = -3; %��ʾͼ��ָ�����ȷ
            else
                bpp_BOSSbase(i) = -4; %��ʾ��ȡ���ݺͻָ�ͼ�񶼲���ȷ
            end
            fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
        end
    else
        bpp_BOSSbase(i) = -1; %��ʾû��Ƕ������
        fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
    end
end
%% ��������
save('num_BOSSbase')
save('bpp_BOSSbase')