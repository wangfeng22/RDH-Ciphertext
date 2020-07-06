function [stego_AC,numD] = GroupEmbed(G,k,D,num_emD)
%stego_AC��ʾǶ����Ϣ��ķֿ�,numD��ʾ�ֿ�Ƕ�����Ϣ��
%G��ʾRLE���жԷ������,k��ʾԭʼ�ֿ�����������D��ʾҪǶ�������,num_emD��ʾ��Ƕ�����ݵ�����
numD = 0;
stego_AC = zeros(8,8);
x=1; %��x,y��������¼�ϴ�Ƕ����Ϣ��λ��
y=1; %(1,2)����ʼλ��
while k>1 %ֻ�з�����������1��Ƕ����Ϣ
    [b,c_code,n] = CodeAssignment(k); %���븳ֵ   
    for w=1:64  %����ѭ��,ֱ��һ��RLEȫ��Ƕ��
        s = num_emD+numD; %������¼��Ƕ�����ݵ�����
        %--��Ƕ��n-1���ض��������ݵĴ�С--%
        sum_D1 = 0; 
        for i=1:n-1
            if D(s+i)==1
                sum_D1 = sum_D1 + 2^(n-1-i);
            end
        end
        %--��Ƕ��n���ض��������ݵĴ�С--%
        sum_D2 = 0; 
        for i=1:n
            if D(s+i)==1
                sum_D2 = sum_D2 + 2^(n-i);
            end
        end
        %------Ѱ��Ƕ����һ���RLE���ж�------%
        if sum_D1<b %ѡȡn-1���ض���������ʾΪb-1
             for i=1:k %����c_code,�ҵ���ȵĶ���������c_code(i)
                if c_code(i)==sum_D1
                    ki = i; %��¼Ƕ����һ���RLE���ж�
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
        %--------��ʼǶ��--------%
        num0 = G(1,ki); %Ƕ��RLE���жԵ���ֵ����       
        [x0,y0] = FindCoors(x,y,num0); %�ҵ�Ƕ���      
        stego_AC(x0,y0) = G(2,ki); %Ƕ��LRE���ж�
        G(3,ki)=G(3,ki)-1; %����RLE������1
        x = x0; %��¼����λ�ã�x,y��        
        y = y0;    
        %-----����RLEǶ�꣬ɾ�������¼������ѭ��-----%
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
%---ֻʣһ��RLEʱ,ֻǶ��RLE����Ƕ������---%
if k==1 
    for i=1:G(3,1) 
        num0 = G(1,1); %RLE���жԵ���ֵ����           
        [x0,y0] = FindCoors(x,y,num0); %�ҵ�Ƕ���         
        stego_AC(x0,y0) = G(2,1); %Ƕ��LRE���ж�         
        x = x0; %��¼����λ��            
        y = y0;
    end
end