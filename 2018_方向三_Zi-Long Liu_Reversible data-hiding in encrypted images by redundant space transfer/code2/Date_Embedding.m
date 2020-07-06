function [ imageData,emData,MER ] = Date_Embedding( imageEn )
%UNTITLEb2 此处显示有关此函数的摘要
%   此处显示详细说明
Data = round(rand(1,100000000)*1);%随机产生01比特，作为嵌入的数据
start=1;
[row,col]=size(imageEn);
imageData=zeros(row,col);
S=4;
Block_num1=row/S;
Block_num2=col/S;
Block_row = S * ones(1,Block_num1);
Block_col = S * ones(1,Block_num2);
bit_len=log2(S);
LEMN=ceil(log2((S*S-3)/(2*log2(S))));
q5max_len=log2((row*col)/(S*S));
cmax_len=16;
MER=zeros();
for k=3:3
    b=[];
    c=[];
    a=[];
    A_bitplane=bitget(imageEn,k);
    q1=0;q2=0;q3=0;q4=0;q5=0;
%     a_num=1;b_num=1;
    c_num=0;
    imageEnBlock = mat2cell(A_bitplane,Block_row,Block_col);
    for i=1:Block_num1
        for j=1:Block_num2
            e0=length(find(imageEnBlock{i,j}==0));
            e1=length(find(imageEnBlock{i,j}==1));
            if e1==0
                b=[b,[0,0,0]];
                q1=q1+1;
%                 b_num=b_num+3;
            elseif e0==0
                q2=q2+1;
                b=[b,[0,1,0]];
%                 b_num=b_num+3;
            elseif e1<e0&&((e1*log2(S*S))<(S*S-3))
                q3=q3+1;
                b=[b,[0,0,1]];
%                 b_num=b_num+3;
                c=[c,(dec2bin((e1-1),LEMN)-'0')];
                c_num=c_num+LEMN;
                for m=1:S
                    for n=1:S
                        if imageEnBlock{i,j}(m,n)==1
                            % 注意此处减1，在恢复时就要+1
                            c=[c,(dec2bin((m-1),bit_len)-'0')];
                            c=[c,(dec2bin((n-1),bit_len)-'0')];
                            c_num=c_num+bit_len*2;
                        end
                    end
                end
                
            elseif e0<e1&&((e0*log2(S*S))<(S*S-3))
                q4=q4+1;
                b=[b,[0,1,1]];
%                 b_num=b_num+3;
                c=[c,(dec2bin((e0-1),LEMN)-'0')];
                c_num=c_num+LEMN;
                for m=1:S
                    for n=1:S
                        if imageEnBlock{i,j}(m,n)==0
                            c=[c,(dec2bin((m-1),bit_len)-'0')];
                            c=[c,(dec2bin((n-1),bit_len)-'0')];
                            c_num=c_num+bit_len*2;
                        end
                    end
                end
            else
                q5=q5+1;
                b=[b,[1]];
%                 b(b_num)=1;
%                 b_num=b_num+1;
                temp=reshape(imageEnBlock{i,j},1,[]);
                %注意此处按列存储
                a=[a,temp];
%                 a_num=a_num+S*S;
            end 
         end
    end
%     EBP=[1,1,1,0,0,0,0,0];
%     Control_Parameters=[EBP,dec2bin(S,2)-'0',dec2bin(q5,q5max_len)-'0',dec2bin(c_num)-'0'];
    % 4*4-00 8*8-01 16*16-10 32*32-11
    Control_Parameters=[[0,0],dec2bin(q5,q5max_len)-'0',dec2bin(c_num,cmax_len)-'0'];
    Recover_data=[a,b,c];
    Data_bitplane=zeros(row,col);
    Data_bitplane(1:length(Recover_data))=Recover_data;
    Data_bitplane(row*col-length(Control_Parameters)+1:row*col)=Control_Parameters;
    embedData_len=row*col-length(Control_Parameters)-length(Recover_data);
    Data_bitplane((length(Recover_data)+1):(length(Recover_data)+embedData_len))=Data(start:start+embedData_len-1);
    start=start+embedData_len;
    imageData=imageData+double(bitshift(Data_bitplane,k-1));
    MER(k)=embedData_len/(row*col);
end
for k=1:2
    A_bitplane=bitget(imageEn,k);
    imageData=imageData+double(bitshift(A_bitplane,k-1));
end
for k=4:8
    A_bitplane=bitget(imageEn,k);
    imageData=imageData+double(bitshift(A_bitplane,k-1));
end
emData =Data(1:start-1);

end

