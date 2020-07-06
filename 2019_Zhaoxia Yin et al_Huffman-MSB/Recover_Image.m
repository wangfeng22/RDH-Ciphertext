function [recover_I] = Recover_Image(stego_I,Image_key,Side_Information,Refer_Value,Map_I,num,ref_x,ref_y)
% ����˵����������ȡ�ĸ�����Ϣ�ָ�ͼ��
% ���룺stego_I������ͼ��,Image_key��ͼ�������Կ��,Side_Information��������Ϣ��,Refer_Value���ο�������Ϣ��,Map_I��λ��ͼ��,num��������Ϣ�ĳ��ȣ�,ref_x,ref_y���ο����ص���������
% �����recover_I���ָ�ͼ��
[row,col] = size(stego_I); %ͳ��stego_I��������
%% ����Refer_Value�ָ�ǰref_y�С�ǰref_x�еĲο�����
refer_I = stego_I;
t = 0; %����
for i=1:row
    for j=1:ref_y
        bin2_8 = Refer_Value(t+1:t+8);
        [value] = Binary_Decimalism(bin2_8); %��8λ����������ת����ʮ��������
        refer_I(i,j) = value;
        t = t + 8;
    end
end
for i=1:ref_x
    for j=ref_y+1:col
        bin2_8 = Refer_Value(t+1:t+8);
        [value] = Binary_Decimalism(bin2_8); %��8λ����������ת����ʮ��������
        refer_I(i,j) = value;
        t = t + 8;
    end
end
%% ��ͼ��refer_I����ͼ�������Կ����
[decrypt_I] = Encrypt_Image(refer_I,Image_key);
%% ����Side_Information��Map_I��num�ָ�����λ�õ�����
recover_I = decrypt_I;
num_S = length(Side_Information);
num_D = num_S + num; %Ƕ����Ϣ������
re = 0; %����
for i=ref_x+1:row
    for j=ref_y+1:col
        if re >= num_D %Ƕ����Ϣ�ı���λȫ���ָ����
            break;
        end
        %---------��ǰ���ص��Ԥ��ֵ---------%
        a = recover_I(i-1,j);
        b = recover_I(i-1,j-1);
        c = recover_I(i,j-1);
        if b <= min(a,c)
            pv = max(a,c);
        elseif b >= max(a,c)
            pv = min(a,c);
        else
            pv = a + c - b;
        end
        %--��ԭʼֵ��Ԥ��ֵת����8λ����������--%
        x = recover_I(i,j);
        [bin2_x] = Decimalism_Binary(x);
        [bin2_pv] = Decimalism_Binary(pv);
        %--------��ʾ������ص���Ҫ�ָ� 1 bit MSB--------%
        if Map_I(i,j) == 0  %Map=0��ʾԭʼ����ֵ�ĵ�1MSB����Ԥ��ֵ�෴
            if bin2_pv(1) == 0 
                bin2_x(1) = 1; 
            else  
                bin2_x(1) = 0;
            end
            [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
            recover_I(i,j) = value;
            re = re + 1; %�ָ�1bit  
        %--------��ʾ������ص���Ҫ�ָ� 2 bit MSB--------%
        elseif Map_I(i,j) == 1  %Map=1��ʾԭʼ����ֵ�ĵ�2MSB����Ԥ��ֵ�෴
            if re+2 <= num_D
                if bin2_pv(2) == 0
                    bin2_x(2) = 1;
                else
                    bin2_x(2) = 0;
                end
                bin2_x(1) = bin2_pv(1);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 2; %�ָ�2bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit 
            end
        %--------��ʾ������ص���Ҫ�ָ� 3 bit MSB--------%
        elseif Map_I(i,j) == 2  %Map=2��ʾԭʼ����ֵ�ĵ�3MSB����Ԥ��ֵ�෴
            if re+2 <= num_D
                if bin2_pv(3) == 0 
                    bin2_x(3) = 1; 
                else                    
                    bin2_x(3) = 0;
                end
                bin2_x(1:2) = bin2_pv(1:2);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 3; %�ָ�3bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end    
        %--------��ʾ������ص���Ҫ�ָ� 4 bit MSB--------%
        elseif Map_I(i,j) == 3  %Map=3��ʾԭʼ����ֵ�ĵ�4MSB����Ԥ��ֵ�෴
            if re+3 <= num_D
                if bin2_pv(4) == 0 
                    bin2_x(4) = 1; 
                else                    
                    bin2_x(4) = 0;
                end
                bin2_x(1:3) = bin2_pv(1:3);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 4; %�ָ�4bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end  
        %--------��ʾ������ص���Ҫ�ָ� 5 bit MSB--------%
        elseif Map_I(i,j) == 4  %Map=4��ʾԭʼ����ֵ�ĵ�5MSB����Ԥ��ֵ�෴
            if re+4 <= num_D
                if bin2_pv(5) == 0 
                    bin2_x(5) = 1; 
                else                    
                    bin2_x(5) = 0;
                end
                bin2_x(1:4) = bin2_pv(1:4);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 5; %�ָ�5bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end    
        %--------��ʾ������ص���Ҫ�ָ� 6 bit MSB--------%
        elseif Map_I(i,j) == 5  %Map=5��ʾԭʼ����ֵ�ĵ�6MSB����Ԥ��ֵ�෴
            if re+5 <= num_D
                if bin2_pv(6) == 0 
                    bin2_x(6) = 1; 
                else                    
                    bin2_x(6) = 0;
                end
                bin2_x(1:5) = bin2_pv(1:5);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 6; %�ָ�6bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end 
        %--------��ʾ������ص���Ҫ�ָ� 7 bit MSB--------%
        elseif Map_I(i,j) == 6  %Map=6��ʾԭʼ����ֵ�ĵ�7MSB����Ԥ��ֵ�෴
            if re+6 <= num_D
                if bin2_pv(7) == 0 
                    bin2_x(7) = 1; 
                else                    
                    bin2_x(7) = 0;
                end
                bin2_x(1:6) = bin2_pv(1:6);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 7; %�ָ�7bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end 
        %--------��ʾ������ص���Ҫ�ָ� 8 bit MSB--------%
        elseif Map_I(i,j) == 7  %Map=7��ʾԭʼ����ֵ�ĵ�8MSB����Ԥ��ֵ�෴
            if re+7 <= num_D
                if bin2_pv(8) == 0 
                    bin2_x(8) = 1; 
                else                    
                    bin2_x(8) = 0;
                end
                bin2_x(1:7) = bin2_pv(1:7);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 8; %�ָ�8bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end  
        %--------��ʾ������ص���Ҫ�ָ� 8 bit MSB--------%
        elseif Map_I(i,j) == 8  %Map=8��ʾԭʼ����ֵ������Ԥ��ֵ
            if re+8 <= num_D
                bin2_x(1:8) = bin2_pv(1:8);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + 8; %�ָ�8bit
            else 
                t = num_D - re; %ʣ��ָ���bit��
                bin2_x(1:t) = bin2_pv(1:t);
                [value] = Binary_Decimalism(bin2_x); %��8λ����������ת����ʮ��������
                recover_I(i,j) = value;
                re = re + t; %�ָ�tbit
            end
        end
    end
end
end