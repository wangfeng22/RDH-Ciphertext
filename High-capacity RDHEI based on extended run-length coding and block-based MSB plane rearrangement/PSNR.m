function psnrvalue = PSNR(origin,stego)
% ����˵�������ͼ��origin��stego��PSNR

I1 = double(origin);
I2 = double(stego);
E = I1 - I2;
MSE = mean2(E.*E);
if MSE == 0
    psnrvalue = -1;
else
    psnrvalue = 10*log10(255*255/MSE);
end