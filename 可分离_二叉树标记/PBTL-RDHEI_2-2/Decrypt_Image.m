function [recover_I] = Decrypt_Image(encrypt_I,Image_key)
% ����˵������ͼ��encrypt_I����̬ͬ����
% ���룺encrypt_I������ͼ��,Image_key��ͼ�������Կ��
% �����recover_I������ͼ��
[row,col] = size(encrypt_I); %����encrypt_I������ֵ
recover_I = encrypt_I;  %�����洢������ͼ�������
%% ������ԿImage_key�����ֿ��ϴ����
m = floor(row/2);
n = floor(col/2);
rand('seed',Image_key);   
index = randperm(m*n);
for i=1:m
    for j=1:n
        Shuffle(i,j) = index((i-1)*n+j);  
    end
end
%% ����TSS��Tent-Sine system��������ʼ����
[r,x0] = TSS(Image_key);
%% ��ͼ����зֿ�����ؽ���̬ͬ���ܲ����ֿ�Ż�ԭ����λ��
R = zeros(m,n); %��¼ÿ���ֿ�����̬ͬ���ܵ�ֵ
if x0 < 0.5 %����x0��Ӧ��x1��ֵ
    xi = mod((r*x0)/2+((4-r)*sin(pi*x0)/4),1); %pi��ʾ��
else % x0��0.5
    xi = mod((r*(1-x0))/2+((4-r)*sin(pi*x0)/4),1); %pi��ʾ��
end
encrypt_Block = zeros(2,2); %������¼2*2�ֿ������
for i=1:m
    for j=1:n   
        %---------------------����x(i)��Ӧ��x(i+1)��ֵ---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
        else % xi��0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
        end   
        %-------------------����xi_1��ǰ�ֿ�̬ͬ���ܵ�ֵ------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;  
        %-----------------------��ǰλ�õķֿ�---------------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*2+1:i*2  
            for y=(j-1)*2+1:j*2
                encrypt_Block(row_B,col_B) = encrypt_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %------------------------�Էֿ�����̬ͬ����-------------------------%
        recover_Block = encrypt_Block; %������¼���ֿܷ������
        for x=1:2
            for y=1:2
                recover_Block(x,y) = mod(encrypt_Block(x,y)-R(i,j),256);
            end
        end
        %-------------------���ϴ��ǰ�ֿ��Ӧ�ķֿ�λ��------------------%
        pos_x = ceil(Shuffle(i,j)/n);
        if mod(Shuffle(i,j),n) == 0
            pos_y = n;
        else
            pos_y = mod(Shuffle(i,j),n); %(r,c)��ʾ��ϴ��ֿ��Ӧ��ԭʼλ��
        end 
        %-------------------�����ֿܷ�Ż���ԭ����λ��----------------------%
        row_B = 1;
        col_B = 1;
        for x=(pos_x-1)*2+1:pos_x*2  
            for y=(pos_y-1)*2+1:pos_y*2
                recover_I(x,y) = recover_Block(row_B,col_B); %��¼���ֿܷ������
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end    
    end
end
%% ��ͼ��û��ǡ�÷ֿ飬��������Ķ��ж���Ҳ����̬ͬ����
res_row = mod(row,2); %�������
res_col = mod(col,2); %�������
%---------------------������������н��зֿ�̬ͬ����----------------------%
if res_row ~= 0
    i = m + 1;
    for j=1:n  %���зֿ����
        %---------------------����x(i)��Ӧ��x(i+1)��ֵ---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
        else % xi��0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
        end
        %------------------����xi_1��ǰ�ֿ�̬ͬ���ܵ�ֵ-------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;
        %---------------�Գߴ�Ϊres_row*3�ķֿ�����̬ͬ����-----------------%       
        for x=row-res_row+1:row
            for y=(j-1)*2+1:j*2
                recover_I(x,y) = mod(encrypt_I(x,y)-R(i,j),256); 
            end    
        end   
    end 
end
%---------------------������������н��зֿ�̬ͬ����----------------------%
if res_col ~= 0
    j = n + 1;
    for i=1:m  %���зֿ����
        %---------------------����x(i)��Ӧ��x(i+1)��ֵ---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
        else % xi��0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
        end
        %------------------����xi_1��ǰ�ֿ�̬ͬ���ܵ�ֵ-------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;
        %---------------�Գߴ�Ϊ3*res_col�ķֿ�����̬ͬ����-----------------%       
        for x=(i-1)*2+1:i*2
            for y=col-res_col+1:col
                recover_I(x,y) = mod(encrypt_I(x,y)-R(i,j),256);
            end    
        end   
    end
end 
%-------------------���������С�ֿ��н��зֿ�̬ͬ����---------------------%
if res_row~=0 && res_col~=0
    i = m + 1;
    j = n + 1;
    %-----------------------����x(i)��Ӧ��x(i+1)��ֵ-----------------------%
    if xi < 0.5
        xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
    else % xi��0.5
        xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi��ʾ��
    end
    %--------------------����xi_1��ǰ�ֿ�̬ͬ���ܵ�ֵ---------------------%
    R(i,j) = floor(mod(xi_1*(2^40),256));
    %-------------�Գߴ�Ϊres_row*res_col��С�ֿ�����̬ͬ����---------------%
    for x=row-res_row+1:row
        for y=col-res_col+1:col
            recover_I(x,y) = mod(encrypt_I(x,y)-R(i,j),256);
        end
    end
end
