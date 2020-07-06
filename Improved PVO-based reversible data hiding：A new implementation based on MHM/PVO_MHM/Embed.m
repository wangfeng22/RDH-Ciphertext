function [stego_I,emD] = Embed(origin_I,D)
% ����˵������������ϢǶ�뵽ԭʼͼ���У���������ͼ��
% ���룺origin_I��ԭʼͼ��,D���������ݣ�
% �����stego_I������ͼ��,emD��Ƕ�����Ϣ��
[row,col] = size(origin_I);
num = length(D); 
%% ���ò���,��ʼԤ�����ظ���
context = 15;
%% ���������Ϣ������ԭʼͼ��
[change_ori_I,LSB,LM] = Overflow(origin_I);
len_LSB = length(LSB);
PS = len_LSB + num; %��Ҫ��Ƕ������
%% �����Ų�������������
[context,Offsets,index,opt_R_S,NL,MAX,MIN] = Optimal(change_ori_I,PS,context);
%% ��������������Ų���
R_S = Offsets{index};
for i=1:32
    R_S(1,i) = R_S(1,i) + opt_R_S(1,i);
    R_S(2,i) = R_S(2,i) + opt_R_S(2,i);
end
%% Ƕ��LSB����������
stego_I_0 = change_ori_I; %Ƕ��������Ϣ֮�������ͼ��
% len_LSB = length(LSB);
num_LSB = 0;
num_emD = 0;
block = ceil(sqrt(context+1)); %�ֿ��С(����������ȡ��)
for i=1:row-block+1             
    for j=1:col-block+1
        if num_emD >= num
            break;
        end
        t = NL(i,j); %����ˮƽ          
        max = MAX(i,j); %Ԥ�����ݵ����ֵ        
        min = MIN(i,j); %Ԥ�����ݵ���Сֵ          
        rt = R_S(1,t+1);%��Сֵ�Ĳ�������                     
        st = R_S(2,t+1);%���ֵ�Ĳ�������
        if stego_I_0(i,j) == max + st %Ƕ��0���䣬Ƕ��1��1
            if num_LSB < len_LSB  %��Ƕ�����Ϣ
                num_LSB = num_LSB+1;
                data = LSB(num_LSB);
            else  %�ȱ���ϢǶ�����֮����Ƕ��������Ϣ   
                num_emD = num_emD+1;
                data = D(num_emD);
            end
            stego_I_0(i,j) = stego_I_0(i,j) + data;
        elseif stego_I_0(i,j) == min + rt %Ƕ��0���䣬Ƕ��1��1
            if num_LSB < len_LSB
                num_LSB = num_LSB+1;
                data = LSB(num_LSB);
            else     
                num_emD = num_emD+1;
                data = D(num_emD);
            end
            stego_I_0(i,j) = stego_I_0(i,j) - data;
        elseif stego_I_0(i,j) > max + st %+1
            stego_I_0(i,j) = stego_I_0(i,j) + 1;
        elseif stego_I_0(i,j) < min + rt %-1
            stego_I_0(i,j) = stego_I_0(i,j) - 1;
        end  
        end_x = i;
        end_y = j;
    end
end
%% Ƕ�븨����Ϣ:opt_R_S,context,index,(end_x,end_y),LM
[stego_I_1] = Side_Embed(stego_I_0,opt_R_S,context,index,end_x,end_y,LM);
%% ��¼����ͼ���Ƕ�������
stego_I = stego_I_1;
emD=D(1:num_emD);
end