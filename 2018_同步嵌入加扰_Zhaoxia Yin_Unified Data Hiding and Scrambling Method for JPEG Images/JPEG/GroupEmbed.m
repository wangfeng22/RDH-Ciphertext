function [stego_AC,numD] = GroupEmbed(G,k,D,num_emD)
%stego_AC表示嵌入信息后的分块,numD表示分块嵌入的信息量
%G表示RLE序列对分组情况,k表示原始分块分组的数量，D表示要嵌入的数据,num_emD表示已嵌入数据的数量
numD = 0;
stego_AC = zeros(8,8);
x=1; %（x,y）用来记录上次嵌入信息的位置
y=1; %(1,2)是起始位置
while k>1 %只有分组数量大于1才嵌入信息
    [b,c_code,n] = CodeAssignment(k); %代码赋值   
    for w=1:64  %方便循环,直到一组RLE全部嵌入
        s = num_emD+numD; %用来记录已嵌入数据的数量
        %--求嵌入n-1比特二进制数据的大小--%
        sum_D1 = 0; 
        for i=1:n-1
            if D(s+i)==1
                sum_D1 = sum_D1 + 2^(n-1-i);
            end
        end
        %--求嵌入n比特二进制数据的大小--%
        sum_D2 = 0; 
        for i=1:n
            if D(s+i)==1
                sum_D2 = sum_D2 + 2^(n-i);
            end
        end
        %------寻找嵌入哪一组的RLE序列对------%
        if sum_D1<b %选取n-1比特二进制最大表示为b-1
             for i=1:k %遍历c_code,找到相等的二进制数据c_code(i)
                if c_code(i)==sum_D1
                    ki = i; %记录嵌入哪一组的RLE序列对
                    numD = numD + n-1;
                    break;  
                end
             end
        else
            for i=1:k 
                if c_code(i)==sum_D2
                    ki = i; 
                    numD = numD + n;
                    break;
                end
            end
        end
        %--------开始嵌入--------%
        num0 = G(1,ki); %嵌入RLE序列对的零值个数       
        [x0,y0] = FindCoors(x,y,num0); %找到嵌入点      
        stego_AC(x0,y0) = G(2,ki); %嵌入LRE序列对
        G(3,ki)=G(3,ki)-1; %该组RLE个数减1
        x = x0; %记录结束位置（x,y）        
        y = y0;    
        %-----该组RLE嵌完，删除该组记录并结束循环-----%
        if G(3,ki) == 0
            for i=ki:k-1
                G(1,i) = G(1,i+1);
                G(2,i) = G(2,i+1);
                G(3,i) = G(3,i+1);
            end
            k=k-1;
            G = G(1:3,1:k);
            break;
        end
    end
end
%---只剩一组RLE时,只嵌入RLE，不嵌入数据---%
if k==1 
    for i=1:G(3,1) 
        num0 = G(1,1); %RLE序列对的零值个数           
        [x0,y0] = FindCoors(x,y,num0); %找到嵌入点         
        stego_AC(x0,y0) = G(2,1); %嵌入LRE序列对         
        x = x0; %记录结束位置            
        y = y0;
    end
end