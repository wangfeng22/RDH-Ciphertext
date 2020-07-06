function [ image ] = Arnold_recover( imageAronold,iTimes )
%UNTITLED7 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
Mm=size(imageAronold,1);               
Nm=size(imageAronold,2);  
image=zeros(Mm,Nm);
%��ˮӡͼ�����arnold����
if Mm~=Nm
  error('ˮӡ�������Ϊ����');
end
tempImg=imageAronold; %ͼ����󸳸�tempImg
for n=1:iTimes   %���Ҵ���
  for u=1:Mm
    for v=1:Nm
      temp=tempImg(u,v);
      ax=mod(2*(u-1)-(v-1),Mm)+1;   %��������λ��
      ay=mod(-1*(u-1)+(v-1),Nm)+1;   %��������λ��
      image(ax,ay)=temp;
    end
  end
tempImg=image;
end

end
