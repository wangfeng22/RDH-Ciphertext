function [imageAronold] = Arnold_Disorder( image,iTimes )
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%ˮӡͼ����������������
Mm=size(image,1);               
Nm=size(image,2);  
imageAronold=zeros(Mm,Nm);
%��ˮӡͼ�����arnold����
if Mm~=Nm
  error('ˮӡ�������Ϊ����');
end
tempImg=image; %ͼ����󸳸�tempImg
for n=1:iTimes   %���Ҵ���
  for u=1:Mm
    for v=1:Nm
      temp=tempImg(u,v);
      ax=mod((u-1)+(v-1),Mm)+1;   %��������λ��
      ay=mod((u-1)+2*(v-1),Nm)+1;   %��������λ��
      imageAronold(ax,ay)=temp;
    end
  end
tempImg=imageAronold;
end

end

