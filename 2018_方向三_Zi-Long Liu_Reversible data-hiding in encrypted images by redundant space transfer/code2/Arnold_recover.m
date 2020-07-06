function [ image ] = Arnold_recover( imageAronold,iTimes )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
Mm=size(imageAronold,1);               
Nm=size(imageAronold,2);  
image=zeros(Mm,Nm);
%对水印图像进行arnold置乱
if Mm~=Nm
  error('水印矩阵必须为方阵');
end
tempImg=imageAronold; %图像矩阵赋给tempImg
for n=1:iTimes   %置乱次数
  for u=1:Mm
    for v=1:Nm
      temp=tempImg(u,v);
      ax=mod(2*(u-1)-(v-1),Mm)+1;   %新像素行位置
      ay=mod(-1*(u-1)+(v-1),Nm)+1;   %新像素列位置
      image(ax,ay)=temp;
    end
  end
tempImg=image;
end

end
