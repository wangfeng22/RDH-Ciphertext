function [ imageRev] = Image_Recover( imageData)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[row,col]=size(imageData);
imageRev=zeros(row,col);
for k=1:3
    A_bitplane=bitget(imageData,k);
    Control_Parameters=A_bitplane(row*col-31:row*col);
    if Control_Parameters(1:2)==[0,0]
        S=4;
    elseif Control_Parameters(1:2)==[0,1]
        S=8;
    elseif Control_Parameters(1:2)==[1,0]
        S=16;  
    end
    q5max_len=log2((row*col)/(S*S));
    temp=Control_Parameters(3:q5max_len+2);
    temp=num2str(temp);
    q5=bin2dec(temp);
    temp=Control_Parameters(q5max_len+3:length(Control_Parameters));
    temp=num2str(temp);
    c_num=bin2dec(temp);
    LRDA=S*S*q5;
    LRDB=q5+3*((row/S)*(col/S)-q5);
    LRD=LRDA+LRDB+c_num;
    Recover_Data=A_bitplane(1:LRD);
    a=Recover_Data(1:LRDA);
    b=Recover_Data(LRDA+1:LRDA+LRDB);
    c=Recover_Data(LRDA+LRDB+1:LRD);
    Block_num1=row/S;
    Block_num2=col/S;
    Block_row = S * ones(1,Block_num1);
    Block_col = S * ones(1,Block_num2);
    imageExBlock = mat2cell(A_bitplane,Block_row,Block_col);
    a_count=1;b_count=1;c_count=1;
    LEMN=ceil(log2((S*S-3)/(2*log2(S))));
    bit_len=log2(S);
    for i=1:Block_num1
        for j=1:Block_num2
            if b(b_count)==1
                imageExBlock{i,j}=reshape(a(a_count:a_count+S*S-1),S,S);
                a_count=a_count+S*S;
                b_count=b_count+1;
            else
                if b(b_count:b_count+2)==[0,0,0]
                    imageExBlock{i,j}=zeros(S,S);
                    b_count=b_count+3;
                elseif b(b_count:b_count+2)==[0,1,0]
                    imageExBlock{i,j}=ones(S,S);
                    b_count=b_count+3;
                elseif b(b_count:b_count+2)==[0,0,1]
                    b_count=b_count+3;
                    temp=c(c_count:c_count+LEMN-1);
                    c_count=c_count+LEMN;
                    temp=num2str(temp);
                    e1_num=bin2dec(temp)+1;
                    type3=zeros(S,S);
                    for p=1:e1_num
                        temp=c(c_count:c_count+bit_len-1);
                        c_count=c_count+bit_len;
                        temp=num2str(temp);
                        e1_x=bin2dec(temp)+1;
                        temp=c(c_count:c_count+bit_len-1);
                        c_count=c_count+bit_len;
                        temp=num2str(temp);
                        e1_y=bin2dec(temp)+1;
                        type3(e1_x,e1_y)=1;
                    end
                    imageExBlock{i,j}=type3;
                elseif b(b_count:b_count+2)==[0,1,1]
                    b_count=b_count+3;
                    temp=c(c_count:c_count+LEMN-1);
                    c_count=c_count+LEMN;
                    temp=num2str(temp);
                    e0_num=bin2dec(temp)+1;
                    type4=ones(S,S);
                    for p=1:e0_num
                        temp=c(c_count:c_count+bit_len-1);
                        c_count=c_count+bit_len;
                        temp=num2str(temp);
                        e0_x=bin2dec(temp)+1;
                        temp=c(c_count:c_count+bit_len-1);
                        c_count=c_count+bit_len;
                        temp=num2str(temp);
                        e0_y=bin2dec(temp)+1;
                        type4(e0_x,e0_y)=0;
                    end
                    imageExBlock{i,j}=type4;
                end
            end
        end
    end
    R_bitplane=cell2mat(imageExBlock);
    imageRev=imageRev+double(bitshift(R_bitplane,k-1));
end
for k=4:8
    A_bitplane=bitget(imageData,k);
    imageRev=imageRev+double(bitshift(A_bitplane,k-1));
end

end

