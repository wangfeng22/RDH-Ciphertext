clear
clc 
%% Test images
x=[1 2 3 4 5 6];
y1=[642889 528429 1877668 526969 120419 558624];
y2=[749155 693285 2599454 700600 254080 695065];
y3=[976348 677212 2463347 794387 279391 740355];
y4=[772400 521256 1857266 612721 133784 603333];
y_all=[y1;y2;y3;y4]';
figure;
bar(x,y_all)
xlabel('Test Images')
ylabel('ER (bits)')
legend('PBTL(3*3)','PBTL(²»·Ö¿é)','HuffmanCoding','Proposed');
% set(gca,'xtick',[1 2 3 4 5 6]);
set(gca,'xticklabel',{'Lena','Baboon','Jetplane','Man','Airplane','Tiffany'});