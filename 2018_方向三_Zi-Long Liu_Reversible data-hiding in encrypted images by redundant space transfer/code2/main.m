clear 
clc

imageOri=imread('Lena.tiff');
% imageOri_en=entropy(imageOri);
% imageOri=im2double(imageOri);
imageOri=double(imageOri);
% figure(1)
% subplot(2,2,1)
% imshow(imageOri,[])
% title('origin image')
[row,col]=size(imageOri);
[ imageEn,Ed2,EA,ED2,Ed11,Ed12 ] = Image_encryption( imageOri );
% figure(1)
% subplot(2,2,2)
% imshow(imageEn,[])
% title('encrypted image')
[ imageData,emData,MER ] = Date_Embedding( imageEn );
% figure(1)
% subplot(2,2,3)
% imshow(imageData,[])
% title('embeded image')
% [ imageRev] = Image_Recover( imageData);
% flag3=isequal(imageEn,imageRev);
[ imageDec ] = Image_Decryption( imageData,Ed2,EA,ED2,Ed11,Ed12);
psnrvalue=psnr(imageOri,imageDec);
% flag2=isequal(imageOri,imageDec);
% figure(1)
% subplot(2,2,4)
imshow(imageDec,[]);
% title('recover image')
[ exData ] = Data_Extraction(imageData);
flag1=isequal(emData,exData);
