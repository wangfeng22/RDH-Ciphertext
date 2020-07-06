function bin = de2bi(dec)
%DE2BI 将非零十进制整数转换成二进制
if dec == 0
    bin = 'error';
else
    if dec > 0
        bin = dec2bin(dec);
    else
        N = floor(log2(abs(dec))+1)
        bin = dec2bin(2^N+dec-1, N);
    end
end
end

