function [encrypt_I,Shuffle,R] = Encrypt_Image(origin_I,Image_key)
% 函数说明：对图像origin_I进行同态加密
% 输入：origin_I（原始图像）,Image_key（图像加密密钥）
% 输出：encrypt_I（加密图像）
[row,col] = size(origin_I); %计算origin_I的行列值
encrypt_I = origin_I;  %构建存储加密图像的容器
%% 根据密钥Image_key构建分块混洗矩阵
m = floor(row/3);
n = floor(col/3);
rand('seed',Image_key);   
index = randperm(m*n);
for i=1:m
    for j=1:n
        Shuffle(i,j) = index((i-1)*n+j);  
    end
end
%% 根据TSS（Tent-Sine system）产生初始参数
[r,x0] = TSS(Image_key);
%% 将图像进行分块混洗并对每个分块像素进行同态加密
R = zeros(m,n); %记录每个分块像素同态加密的值
if x0 < 0.5 %先求x0对应的x1的值
    xi = mod((r*x0)/2+((4-r)*sin(pi*x0)/4),1); %pi表示π
else % x0≥0.5
    xi = mod((r*(1-x0))/2+((4-r)*sin(pi*x0)/4),1); %pi表示π
end
origin_Block = zeros(3,3); %用来记录3*3分块的像素
for i=1:m
    for j=1:n   
        %---------------------先求x(i)对应的x(i+1)的值---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        else % xi≥0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        end   
        %-------------------根据xi_1求当前分块同态加密的值------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;  
        %-------------------求混洗后当前分块对应的分块位置------------------%
        pos_x = ceil(Shuffle(i,j)/n);
        if mod(Shuffle(i,j),n) == 0
            pos_y = n;
        else
            pos_y = mod(Shuffle(i,j),n); %(r,c)表示混洗后分块对应的原始位置
        end 
        %------------------------求对应位置的分块--------------------------%
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
        %------------------------对分块像素同态加密-------------------------%
        encrypt_Block = origin_Block; %用来记录加密分块的像素
        for x=1:3
            for y=1:3
                encrypt_Block(x,y) = mod(origin_Block(x,y)+R(i,j),256);
            end
        end
        %----------------------将加密分块放到当前位置-----------------------%
        row_B = 1;
        col_B = 1;
        for x=(i-1)*3+1:i*3  
            for y=(j-1)*3+1:j*3
                encrypt_I(x,y) = encrypt_Block(row_B,col_B); %记录加密分块的像素
                col_B = col_B + 1;
            end
            row_B = row_B + 1;
            col_B = 1;
        end    
    end
end
%% 若图像没有恰好分块，对最后多余的多行多列也进行同态加密
res_row = mod(row,3); %多余的行
res_col = mod(col,3); %多余的列
%---------------------在最后多余的行中进行分块同态加密----------------------%
if res_row ~= 0
    i = m + 1;
    for j=1:n  %按列分块加密
        %---------------------先求x(i)对应的x(i+1)的值---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        else % xi≥0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        end
        %------------------根据xi_1求当前分块同态加密的值-------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;
        %---------------对尺寸为res_row*3的分块像素同态加密-----------------%       
        for x=row-res_row+1:row
            for y=(j-1)*3+1:j*3
                encrypt_I(x,y) = mod(origin_I(x,y)+R(i,j),256); 
            end    
        end   
    end 
end
%---------------------在最后多余的列中进行分块同态加密----------------------%
if res_col ~= 0
    j = n + 1;
    for i=1:m  %按行分块加密
        %---------------------先求x(i)对应的x(i+1)的值---------------------%
        if xi < 0.5
            xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        else % xi≥0.5
            xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
        end
        %------------------根据xi_1求当前分块同态加密的值-------------------%
        R(i,j) = floor(mod(xi_1*(2^40),256));
        xi = xi_1;
        %---------------对尺寸为3*res_col的分块像素同态加密-----------------%       
        for x=(i-1)*3+1:i*3
            for y=col-res_col+1:col
                encrypt_I(x,y) = mod(origin_I(x,y)+R(i,j),256); 
            end    
        end   
    end
end 
%-------------------在最后多余的小分块中进行分块同态加密---------------------%
if res_row~=0 && res_col~=0
    i = m + 1;
    j = n + 1;
    %-----------------------先求x(i)对应的x(i+1)的值-----------------------%
    if xi < 0.5
        xi_1 = mod((r*xi)/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
    else % xi≥0.5
        xi_1 = mod((r*(1-xi))/2+((4-r)*sin(pi*xi)/4),1); %pi表示π
    end
    %--------------------根据xi_1求当前分块同态加密的值---------------------%
    R(i,j) = floor(mod(xi_1*(2^40),256));
    %-------------对尺寸为res_row*res_col的小分块像素同态加密---------------%
    for x=row-res_row+1:row
        for y=col-res_col+1:col
            encrypt_I(x,y) = mod(origin_I(x,y)+R(i,j),256);
        end
    end
end
