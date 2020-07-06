function [imageAronold] = Arnold_Disorder( image,iTimes )
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
%水印图像矩阵的行数与列数
Mm=size(image,1);               
Nm=size(image,2);  
imageAronold=zeros(Mm,Nm);
%对水印图像进行arnold置乱
if Mm~=Nm
  error('水印矩阵必须为方阵');
end
tempImg=image; %图像矩阵赋给tempImg
for n=1:iTimes   %置乱次数
  for u=1:Mm
    for v=1:Nm
      temp=tempImg(u,v);
      ax=mod((u-1)+(v-1),Mm)+1;   %新像素行位置
      ay=mod((u-1)+2*(v-1),Nm)+1;   %新像素列位置
      imageAronold(ax,ay)=temp;
    end
  end
tempImg=imageAronold;
end

end

