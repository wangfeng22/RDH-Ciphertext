function [exData,numD] = GroupExtract(RLE,G,k)
%RLE��ʾ�ֿ�RLE���У�G��ʾRLE���жԷ������,k��ʾԭʼ�ֿ���������
%exData��ʾ�ֿ���ȡ������,numD��ʾ�ֿ���ȡ���ݵ�����
exData = zeros();
numD = 0;
[~,L]=size(RLE); %ͳ�Ʒֿ�RLE���жԵĸ���
ki = 1;
while k>1 %ֻ�з�����������1����ȡ��Ϣ
    [b,c_code,n] = CodeAssignment(k); %���븳ֵ
    for i=ki:L   
        %---�ҵ�����һ��RLE���ж���ȡ����---%
        for j=1:k       
            if RLE(1,i)==G(1,j) && RLE(2,i)==G(2,j)     
                kg = j; 
                nd = c_code(kg);
                break;
            end   
        end
        %--------��ȡ����--------%
        if kg<=b  %ǰ��b��RLEÿ����ȡn-1�������� 
            for x=n-1:-1:1   
                data = mod(nd,2); %������             
                exData(numD+x) = data;             
                nd = floor(nd/2); 
            end       
            numD = numD + n-1;  
        else  % ����k-b��RLEÿ����ȡn��������    
            for x=n:-1:1
                data = mod(nd,2);            
                exData(numD+x) = data;
                nd = floor(nd/2); 
            end 
            numD = numD + n;
        end
        G(3,kg)=G(3,kg)-1; %����RLE������1
        %-----����RLEǶ�꣬ɾ�������¼������ѭ��-----%
        if G(3,kg) == 0
            for x=kg:k-1
                G(1,x) = G(1,x+1);
                G(2,x) = G(2,x+1);
                G(3,x) = G(3,x+1);
            end
            ki = i+1; %��¼��һ��RLEλ��
            k = k-1;
            G = G(1:3,1:k);
            break;
        end
    end
end