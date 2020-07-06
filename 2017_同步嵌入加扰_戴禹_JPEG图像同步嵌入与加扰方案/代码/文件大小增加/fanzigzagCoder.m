function A = fanzigzagCoder(dctVector)  
    count = 1;      
    for dim_sum = 2 : 16
        if mod(dim_sum, 2) == 0  
            for i = 1 : 8  
                if dim_sum - i <= 8 & dim_sum - i > 0  
                    A(i, dim_sum - i)  = dctVector(count); 
                    count = count + 1;  
                end  
            end  
        else  
            for i = 1 : 8  
                if dim_sum - i <= 8 & dim_sum - i >0  
                    A(dim_sum - i, i)  = dctVector(count); 
                    count = count + 1;  
                end                     
            end     
        end  
    end   
    A=A';
end 