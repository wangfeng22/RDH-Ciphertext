function [recover_I,exD] = Extract(stego_I)
% ����˵������ȡ������Ϣ���ָ�ԭʼͼ��
% ���룺stego_I������ͼ��
% �����recover_I���ָ�ͼ��,exD��������Ϣ��
[row,col] = size(stego_I);
%% ����ȡ���һ��һ�еĸ�����Ϣ
[recover_I_0,opt_R_S,context,index,end_x,end_y,LM] = Side_Extract(stego_I);
%% ��ʼ����������
r_s = zeros(2,256); %��ʼ��ȫΪ0,����256��ֱ��ͼ
r_s(1,1) = -1;
[Offsets] = Offset_Manners(r_s);
%% �����Ų�������
R_S = Offsets{index};
for i=1:32
    R_S(1,i) = R_S(1,i) + opt_R_S(1,i);
    R_S(2,i) = R_S(2,i) + opt_R_S(2,i);
end
%% ��ȡLSB��������Ϣ
recover_I_1 = recover_I_0;
Data = zeros(); %��¼Ƕ���ȫ����Ϣ
num = 0;
for i=end_x:-1:1
    if i == end_x
        for j=end_y:-1:1
            [U] = Context_Pixels(recover_I_1,context,i,j);
            bi = max(U); %���ֵ   
            ai = min(U); %��Сֵ  
            t = bi - ai;%����ˮƽ
            rt = R_S(1,t+1); %��Сֵ�Ĳ�������                        
            st = R_S(2,t+1); %���ֵ�Ĳ�������  
            if recover_I_1(i,j) == bi+st %Ƕ�������ݣ�0
                num = num + 1;
                Data(num) = 0;      
            elseif recover_I_1(i,j) == bi+st+1 %Ƕ�������ݣ�1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;
                num = num + 1;
                Data(num) = 1;    
            elseif recover_I_1(i,j) == ai+rt  %Ƕ�������ݣ�0
                num = num + 1;
                Data(num) = 0;                     
            elseif recover_I_1(i,j) == ai+rt-1  %Ƕ�������ݣ�1
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
                num = num + 1;
                Data(num) = 1;     
            elseif recover_I_1(i,j) > bi+st+1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;               
            elseif recover_I_1(i,j) < ai+rt-1     
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
            end
        end
    else
        block = ceil(sqrt(context+1)); %�ֿ��С(����������ȡ��)
        for j=col-block+1:-1:1
            [U] = Context_Pixels(recover_I_1,context,i,j);
            bi = max(U); %���ֵ   
            ai = min(U); %��Сֵ  
            t = bi - ai;%����ˮƽ
            rt = R_S(1,t+1); %��Сֵ�Ĳ�������                        
            st = R_S(2,t+1); %���ֵ�Ĳ�������  
            if recover_I_1(i,j) == bi+st %Ƕ�������ݣ�0
                num = num + 1;
                Data(num) = 0;      
            elseif recover_I_1(i,j) == bi+st+1 %Ƕ�������ݣ�1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;
                num = num + 1;
                Data(num) = 1;    
            elseif recover_I_1(i,j) == ai+rt  %Ƕ�������ݣ�0
                num = num + 1;
                Data(num) = 0;                     
            elseif recover_I_1(i,j) == ai+rt-1  %Ƕ�������ݣ�1
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
                num = num + 1;
                Data(num) = 1;     
            elseif recover_I_1(i,j) > bi+st+1
                recover_I_1(i,j) = recover_I_1(i,j) - 1;               
            elseif recover_I_1(i,j) < ai+rt-1     
                recover_I_1(i,j) = recover_I_1(i,j) + 1;
            end
        end
    end
end
%% ����LSB��������Ϣ
Data = fliplr(Data); %����
len = length(LM);
x = ceil(log2(row));
y = ceil(log2(col));
num_LSB = len+128+4+6+x+y;
LSB = Data(1:num_LSB);
exD = Data(num_LSB+1:num);
%% Ƕ��LSB
recover_I_2 = recover_I_1;
% num_LSB = length(LSB);
if num_LSB<=row
    for i=1:num_LSB
        recover_I_2(i,col) = recover_I_2(i,col) + LSB(i);
    end
else
    for i=1:row
        recover_I_2(i,col) = recover_I_2(i,col) + LSB(i);
    end
    for j=1:num_LSB-row
        recover_I_2(row,j) = recover_I_2(row,j) + LSB(row+j);
    end
end
%% ����ͼ��
recover_I = recover_I_2;
s = 0; %��¼���������صĸ���
for i=1:18
    s = s + LM(i)*(2^(i-1)); 
end
if s ~= 0
    for i=1:s
        loc = 0; %��¼���λ��
        for j=1:18
            bit = LM(i*18+j);
            loc = loc + bit*(2^(j-1)); 
        end
        loc_x = ceil(loc/col); %����ȡ��
        loc_y = loc - (loc_x-1)*col;
        if recover_I(loc_x,loc_y) == 1
            recover_I(loc_x,loc_y) = 0;
        elseif recover_I(loc_x,loc_y) == 254
            recover_I(loc_x,loc_y) = 255;
        end
    end
end
end
