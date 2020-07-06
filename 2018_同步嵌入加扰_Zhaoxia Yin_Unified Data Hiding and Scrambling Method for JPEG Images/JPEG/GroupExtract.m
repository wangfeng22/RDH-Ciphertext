function [exData,numD] = GroupExtract(RLE,G,k)
%RLE表示分块RLE序列，G表示RLE序列对分组情况,k表示原始分块分组的数量
%exData表示分块提取的数据,numD表示分块提取数据的数量
exData = zeros();
numD = 0;
[~,L]=size(RLE); %统计分块RLE序列对的个数
ki = 1;
while k>1 %只有分组数量大于1才提取信息
    [b,c_code,n] = CodeAssignment(k); %代码赋值
    for i=ki:L   
        %---找到从哪一组RLE序列对提取数据---%
        for j=1:k       
            if RLE(1,i)==G(1,j) && RLE(2,i)==G(2,j)     
                kg = j; 
                nd = c_code(kg);
                break;
            end   
        end
        %--------提取数据--------%
        if kg<=b  %前面b组RLE每个提取n-1比特数据 
            for x=n-1:-1:1   
                data = mod(nd,2); %求余数             
                exData(numD+x) = data;             
                nd = floor(nd/2); 
            end       
            numD = numD + n-1;  
        else  % 后面k-b组RLE每个提取n比特数据    
            for x=n:-1:1
                data = mod(nd,2);            
                exData(numD+x) = data;
                nd = floor(nd/2); 
            end 
            numD = numD + n;
        end
        G(3,kg)=G(3,kg)-1; %该组RLE个数减1
        %-----该组RLE嵌完，删除该组记录并结束循环-----%
        if G(3,kg) == 0
            for x=kg:k-1
                G(1,x) = G(1,x+1);
                G(2,x) = G(2,x+1);
                G(3,x) = G(3,x+1);
            end
            ki = i+1; %记录下一个RLE位置
            k = k-1;
            G = G(1:3,1:k);
            break;
        end
    end
end