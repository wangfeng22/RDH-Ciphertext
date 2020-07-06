function [recover_I] = Decrypt_Image(encrypt_I,Image_key)
% 函数说明：对图像encrypt_I进行同态解密
% 输入：encrypt_I（加密图像）,Image_key（图像加密密钥）
% 输出：recover_I（解密图像）
[row,col] = size(encrypt_I); %计算encrypt_I的行列值
recover_I = encrypt_I;  %构建存储解密密图像的容器
%% 根据密钥Image_key构建分块混洗矩阵
m = floor(row/2);
n = floor(col/2);
rand('seed',Image_key);   
index = randperm(m*n);
for i=1:m
    for j=1:n
        Shuffle(i,j) = index((i-1)*n+j);  
    end
end
%% 根据TSS（Tent-Sine system）产生初始参数
[r,x0] = TSS(Image_key);
%% 将图像进行分块的像素进行同态解密并将分块放回原来的位置
R = zeros(m,n); %记录每个分块像素同态解密的值
if x0 < 0.5 %先求x0对应的x1的值
    xi = mod((r*x0)/2+((4-r)*sin(pi*x0)/4),1); %pi表示π
else % x0≥0.5
    xi = mod((r*(1-x0))/2+((4-r)*sin(pi*x0)/4),1); %pi表示π
end
encrypt_Block = zeros(2,2); %用来记录2*2分块的像素
for i=1:m
    for j=1:n   
        %---------------------先求x(i)对应的x(i+1)的值---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        else % xi≥0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        end   
        %-------------------根据xi_1求当前分块同态解密的值------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;  
        %-----------------------求当前位置的分块---------------------------%
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
        %------------------------对分块像素同态解密-------------------------%
        recover_Block = encrypt_Block; %用来记录解密分块的像素
        for x=1:2
            for y=1:2
                recover_Block(x,y) = mod(encrypt_Block(x,y)-R(i,j),256);
            end
        end
        %-------------------求混洗后当前分块对应的分块位置------------------%
        pos_x = ceil(Shuffle(i,j)/n);
        if mod(Shuffle(i,j),n) == 0
            pos_y = n;
        else
            pos_y = mod(Shuffle(i,j),n); %(r,c)表示混洗后分块对应的原始位置
        end 
        %-------------------将解密分块放回其原来的位置----------------------%
        row_B = 1;
        col_B = 1;
        for x=(pos_x-1)*2+1:pos_x*2  
            for y=(pos_y-1)*2+1:pos_y*2
                recover_I(x,y) = recover_Block(row_B,col_B); %记录加密分块的像素
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end    
    end
end
%% 若图像没有恰好分块，对最后多余的多行多列也进行同态解密
res_row = mod(row,2); %多余的行
res_col = mod(col,2); %多余的列
%---------------------在最后多余的行中进行分块同态解密----------------------%
if res_row ~= 0
    i = m + 1;
    for j=1:n  %按列分块解密
        %---------------------先求x(i)对应的x(i+1)的值---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        else % xi≥0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        end
        %------------------根据xi_1求当前分块同态解密的值-------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;
        %---------------对尺寸为res_row*3的分块像素同态解密-----------------%       
        for x=row-res_row+1:row
            for y=(j-1)*2+1:j*2
                recover_I(x,y) = mod(encrypt_I(x,y)-R(i,j),256); 
            end    
        end   
    end 
end
%---------------------在最后多余的列中进行分块同态解密----------------------%
if res_col ~= 0
    j = n + 1;
    for i=1:m  %按行分块解密
        %---------------------先求x(i)对应的x(i+1)的值---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        else % xi≥0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        end
        %------------------根据xi_1求当前分块同态解密的值-------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;
        %---------------对尺寸为3*res_col的分块像素同态解密-----------------%       
        for x=(i-1)*2+1:i*2
            for y=col-res_col+1:col
                recover_I(x,y) = mod(encrypt_I(x,y)-R(i,j),256);
            end    
        end   
    end
end 
%-------------------在最后多余的小分块中进行分块同态解密---------------------%
if res_row~=0 && res_col~=0
    i = m + 1;
    j = n + 1;
    %-----------------------先求x(i)对应的x(i+1)的值-----------------------%
    if xi < 0.5
        xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
    else % xi≥0.5
        xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
    end
    %--------------------根据xi_1求当前分块同态解密的值---------------------%
    R(i,j) = floor(mod(xi_1*(2^40),256));
    %-------------对尺寸为res_row*res_col的小分块像素同态解密---------------%
    for x=row-res_row+1:row
        for y=col-res_col+1:col
            recover_I(x,y) = mod(encrypt_I(x,y)-R(i,j),256);
        end
    end
end
