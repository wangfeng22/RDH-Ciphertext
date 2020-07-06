function [encrypt_I,Shuffle,R] = Encrypt_Image(origin_I,Image_key)
% ����˵������ͼ��origin_I����̬ͬ����
% ���룺origin_I��ԭʼͼ��,Image_key��ͼ�������Կ��
% �����encrypt_I������ͼ��
[row,col] = size(origin_I); %����origin_I������ֵ
encrypt_I = origin_I;  %�����洢����ͼ�������
%% ������ԿImage_key�����ֿ��ϴ����
m = floor(row/3);
n = floor(col/3);
rand('seed',Image_key);   
index = randperm(m*n);
for i=1:m
    for j=1:n
        Shuffle(i,j) = index((i-1)*n+j);  
    end
end
%% ����TSS��Tent-Sine system��������ʼ����
[r,x0] = TSS(Image_key);
%% ��ͼ����зֿ��ϴ����ÿ���ֿ����ؽ���̬ͬ����
R = zeros(m,n); %��¼ÿ���ֿ�����̬ͬ���ܵ�ֵ
if x0 < 0.5 %����x0��Ӧ��x1��ֵ
    xi = mod((r*x0)/2+((4-r)*sin(pi*x0)/4),1); %pi��ʾ��
else % x0��0.5
    xi = mod((r*(1-x0))/2+((4-r)*sin(pi*x0)/4),1); %pi��ʾ��
end
origin_Block = zeros(3,3); %������¼3*3�ֿ������
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
        %-------------------���ϴ��ǰ�ֿ��Ӧ�ķֿ�λ��------------------%
        pos_x = ceil(Shuffle(i,j)/n);
        if mod(Shuffle(i,j),n) == 0
            pos_y = n;
        else
            pos_y = mod(Shuffle(i,j),n); %(r,c)��ʾ��ϴ��ֿ��Ӧ��ԭʼλ��
        end 
        %------------------------���Ӧλ�õķֿ�--------------------------%
        row_B = 1;
        col_B = 1;
        for x=(pos_x-1)*3+1:pos_x*3  
            for y=(pos_y-1)*3+1:pos_y*3
                origin_Block(row_B,col_B) = origin_I(x,y);
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end
        %------------------------�Էֿ�����̬ͬ����-------------------------%
        encrypt_Block = origin_Block; %������¼���ֿܷ������
        for x=1:3
            for y=1:3
                encrypt_Block(x,y) = mod(origin_Block(x,y)+R(i,j),256);
            end
        end
        %----------------------�����ֿܷ�ŵ���ǰλ��-----------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*3+1:i*3  
            for y=(j-1)*3+1:j*3
                encrypt_I(x,y) = encrypt_Block(row_B,col_B); %��¼���ֿܷ������
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end    
    end
end
%% ��ͼ��û��ǡ�÷ֿ飬��������Ķ��ж���Ҳ����̬ͬ����
res_row = mod(row,3); %�������
res_col = mod(col,3); %�������
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
            for y=(j-1)*3+1:j*3
                encrypt_I(x,y) = mod(origin_I(x,y)+R(i,j),256); 
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
        for x=(i-1)*3+1:i*3
            for y=col-res_col+1:col
                encrypt_I(x,y) = mod(origin_I(x,y)+R(i,j),256); 
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
            encrypt_I(x,y) = mod(origin_I(x,y)+R(i,j),256);
        end
    end
end
