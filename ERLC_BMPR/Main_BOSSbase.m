clear
clc
%% ������������������
num_D = 2000000;
rand('seed',0); %��������
D = round(rand(1,num_D)*1); %�����ȶ������
%% ͼ�����ݼ���Ϣ(BOSSbase_1.01),��ʽ:PGM,����:10000��
I_file_path = 'D:\ImageDatabase\BOSSbase_1.01\'; %����ͼ�����ݼ��ļ���·��
I_path_list = dir(strcat(I_file_path,'*.pgm'));  %��ȡ���ļ���������pgm��ʽ��ͼ��
img_num = length(I_path_list); %��ȡͼ��������
%% ��¼ÿ��ͼ��ĵ������Ϣ
num_BOSSbase = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ���� 
bpp_BOSSbase = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ����
len_BOSSbase = zeros(8,img_num); %��¼ÿ��ͼ�����λƽ���ѹ������������
room_BOSSbase = zeros(8,img_num);%��¼ÿ��ͼ�����λƽ���ѹ���ռ�
%% ������Կ
K_en = 1; %ͼ�������Կ
K_sh = 2; %ͼ���ϴ��Կ
K_hide=3; %����Ƕ����Կ
%% ���ò���
Block_size = 4; %�ֿ��С���洢�ֿ��С�ı�������Ҫ������Ŀǰ��Ϊ4bits��
L_fix = 3; %�����������
L = 4; %��ͬ���������Ȳ���,�����޸�
%% ͼ�����ݼ�����
ERROR = 0; %������ͳ�ƴ洢��Ϣ�����ͼ����
for i=1:img_num
    %-------------------------------��ȡͼ��-------------------------------%
    I_name = I_path_list(i).name; %ͼ����
    I = imread(strcat(I_file_path,I_name));%��ȡͼ��
    origin_I = double(I);
    %----------------�ճ�ͼ��ռ䲢���ܻ�ϴͼ�����������ߣ�----------------%
    [ES_I,PL_len_CBS,PL_room,num_LSB] = Vacate_Encrypt(origin_I,Block_size,L_fix,K_en,K_sh);
    %------���غɿռ����num����&&MSBλƽ���¼�˸�����Ϣ������²Ž�������Ƕ�루������ѹ���ռ䣩------%
    [row,col] = size(origin_I); %����origin_I������ֵ
    num = ceil(log2(row))+ceil(log2(col))+2; %��¼��ѹ���ռ��С��Ҫ�ı�����
    if num_LSB>=num && PL_room(8)>=0 %��Ҫnum���ؼ�¼��ѹ���ռ��С&&MSBλƽ���¼������Ϣ
        %---------------�ڼ��ܻ�ϴͼ����Ƕ�����ݣ�����Ƕ���ߣ�---------------%
        [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D);
        num_emD = length(emD);
        %-----------------������ͼ������ȡ������Ϣ�������ߣ�-----------------%
        [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
        %-----------------------�ָ�����ͼ�񣨽����ߣ�----------------------%
        [recover_I,re_I] = Image_Recover(stego_I,K_en,K_sh);
        %-----------------------------�����¼-----------------------------%
        [m,n] = size(origin_I);
        num_BOSSbase(i) = num_emD;
        bpp_BOSSbase(i) = num_emD/(m*n);
        for pl=1:8
            len_BOSSbase(pl,i) = PL_len_CBS(pl);
            room_BOSSbase(pl,i) = PL_room(pl);
        end
        %-----------------------------����ж�-----------------------------%
        check1 = isequal(emD,exD);
        check2 = isequal(origin_I,recover_I);
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
        %-----------------------------������-----------------------------%
        if check1 == 1 && check2 == 1
            bpp = bpp_BOSSbase(i);
            disp(['Embedding capacity equal to : ' num2str(num_emD)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['�� ',num2str(i),' ��ͼ��-------- OK','\n\n']);
        else
            ERROR = ERROR+1;
            if check1 ~= 1 && check2 == 1
                bpp_BOSSbase(i) = -1; %��ʾ��ȡ���ݲ���ȷ
            elseif check1 == 1 && check2 ~= 1
                bpp_BOSSbase(i) = -2; %��ʾͼ��ָ�����ȷ
            else
                bpp_BOSSbase(i) = -3; %��ʾ��ȡ���ݺͻָ�ͼ�񶼲���ȷ
            end
            fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
        end
    elseif num_LSB>=num && PL_room(8)<0
        ERROR = ERROR+1;
        num_BOSSbase(i) = num_LSB;
        bpp_BOSSbase(i) = -4; %��ʾMSBλƽ���޷��洢������Ϣ
        for pl=1:8 %��¼λƽ��ѹ�����Ⱥ�ѹ���ռ�
            len_BOSSbase(pl,i) = PL_len_CBS(pl);
            room_BOSSbase(pl,i) = PL_room(pl);
        end
        disp('MSBλƽ���޷��洢������Ϣ��')
        fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
    else
        ERROR = ERROR+1;
        num_BOSSbase(i) = -1; %��ʾ��ѹ���ռ�С��0���޷�Ƕ������
        for pl=1:8 %��¼λƽ��ѹ�����Ⱥ�ѹ���ռ�
            len_BOSSbase(pl,i) = PL_len_CBS(pl);
            room_BOSSbase(pl,i) = PL_room(pl);
        end
        disp('��ѹ���ռ�С��0���޷�Ƕ�����ݣ�')
        fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
    end    
end
%% ��������
save('num_BOSSbase')
save('bpp_BOSSbase')
save('len_BOSSbase')
save('room_BOSSbase')