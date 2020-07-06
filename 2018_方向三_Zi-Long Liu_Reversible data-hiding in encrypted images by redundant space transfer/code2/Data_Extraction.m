function [ exData ] = Data_Extraction(imageData)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[row,col]=size(imageData);
start=1;
exData=[];
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
    LRD=S*S*q5+q5+3*((row/S)*(col/S)-q5)+c_num;
    embed_num=row*col-LRD-length(Control_Parameters);
    exData(start:start+embed_num-1)=A_bitplane(LRD+1:row*col-length(Control_Parameters));
    start=start+embed_num;
    
end

end

