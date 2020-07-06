clc
clear

% Data = round(rand(1,10000000)*1);
addpath(genpath('G:\科研项目\JPEG实验报告_P71514007_戴禹\JPEG_Toolbox'));
jpeg_info = jpeg_read('Lena.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{1} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Airplane.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{2} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Baboon.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{3} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Boat.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{4} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Lake.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{5} = jpeg_info.coef_arrays{1,1};%获取dct系数
jpeg_info = jpeg_read('Tiffany.jpg');%解析JPEG图像 jpeg_read（）是解析工具中的函数 直接调用
dct_coef{6} = jpeg_info.coef_arrays{1,1};%获取dct系数
for i123=1:6
    
    
    fenkuaijieguo=fenkuai(dct_coef{i123});
    h=0;
    
    run=0;
    zongshu=0;
    aaa=0;
    t=zeros(64,64);
    %% RSV提取，第一行为value，第二行为run
    for i=1:64
        for j=1:64
            run=0;
            tt=1;
            dctVector=zigzagCoder(fenkuaijieguo{i,j},64);
            for ii=1:64
                if ii~=1
                    if dctVector(ii)~=0;
                        value=dctVector(ii);
                        RSV{i,j}(:,tt)=[value;run];
                        run=0;
                        tt=tt+1;
                    else
                        run=run+1;
                    end
                end
            end
        end
    end
    ccccc=0;
    biaoji=zeros(64,64);
    payload=0;
    t3=1;
    %% RSV还原，第一行为value，第二行为run 计算标记
    for i=1:64
        for j=1:64
            if isempty(RSV{i,j})
                biaoji(i,j)=0;
                
            else if length(RSV{i,j}(1,:))>=2&&length(RSV{i,j}(1,:))<=3
                    a=RSV{i,j}(:,1);
                    
                    b=RSV{i,j}(:,length(RSV{i,j}(1,:)));
                    
                    d1=delta(a,b,1);
                    d2=delta(b,a,1);
                    if d1>d2
                        biaoji(i,j)=1;
                        payload=payload+1;
                    else
                        biaoji(i,j)=0;
                    end
                else if length(RSV{i,j}(1,:))>=4&&length(RSV{i,j}(1,:))<=7
                        shiyong=RSV{i,j}(:,[1:2,(length(RSV{i,j}(1,:))-1):length(RSV{i,j}(1,:))]);
                        dd=zeros(1,8);
                        for i11=1:8
                            if i11<=4
                                cc=circshift(shiyong,[0,i11-1]);
                                a=cc(:,1:2);
                                b=cc(:,3:4);
                                dd(i11)=delta(a,b,2);
                            else
                                cc=fliplr(shiyong);
                                ccc=circshift(cc,[0,i11-5]);
                                a=ccc(:,1:2);
                                b=ccc(:,3:4);
                                dd(i11)=delta(a,b,2);
                            end
                        end
                        dmax=max(dd);
                        x=find(dmax==dd);
                        if length(x)>1||dd(1)~=dmax
                            biaoji(i,j)=0;
                        else
                            biaoji(i,j)=1;
                            payload=payload+3;
                            
                        end
                    else if length(RSV{i,j}(1,:))>=8&&length(RSV{i,j}(1,:))<=15
                            shiyong=RSV{i,j}(:,[1:4,(length(RSV{i,j}(1,:))-3):length(RSV{i,j}(1,:))]);
                            dd=zeros(1,16);
                            for i11=1:16
                                if i11<=8
                                    cc=circshift(shiyong,[0,i11-1]);
                                    a=cc(:,1:2);
                                    b=cc(:,length(cc(1,:))-1:length(cc(1,:)));
                                    dd(i11)=delta(a,b,2);
                                else
                                    cc=fliplr(shiyong);
                                    ccc=circshift(cc,[0,i11-9]);
                                    a=ccc(:,1:2);
                                    b=ccc(:,length(cc(1,:))-1:length(cc(1,:)));
                                    dd(i11)=delta(a,b,2);
                                end
                            end
                            dmax=max(dd);
                            x=find(dmax==dd);
                            if length(x)>1||dd(1)~=dmax
                                biaoji(i,j)=0;
                            else
                                biaoji(i,j)=1;
                                payload=payload+4;
                                
                            end
                        else if length(RSV{i,j}(1,:))>=16&&length(RSV{i,j}(1,:))<=31
                                shiyong=RSV{i,j}(:,[1:8,(length(RSV{i,j}(1,:))-7):length(RSV{i,j}(1,:))]);
                                dd=zeros(1,32);
                                for i11=1:32
                                    if i11<=16
                                        cc=circshift(shiyong,[0,i11-1]);
                                        a=cc(:,1:2);
                                        b=cc(:,length(cc(1,:))-1:length(cc(1,:)));
                                        dd(i11)=delta(a,b,2);
                                    else
                                        cc=fliplr(shiyong);
                                        ccc=circshift(cc,[0,i11-17]);
                                        a=ccc(:,1:2);
                                        b=ccc(:,length(cc(1,:))-1:length(cc(1,:)));
                                        dd(i11)=delta(a,b,2);
                                    end
                                end
                                dmax=max(dd);
                                x=find(dmax==dd);
                                if length(x)>1||dd(1)~=dmax
                                    biaoji(i,j)=0;
                                else
                                    biaoji(i,j)=1;
                                    payload=payload+5;
                                    
                                end
                            else if length(RSV{i,j}(1,:))>=32&&length(RSV{i,j}(1,:))<=63
                                    shiyong=RSV{i,j}(:,[1:16,(length(RSV{i,j}(1,:))-15):length(RSV{i,j}(1,:))]);
                                    dd=zeros(1,64);
                                    for i11=1:64
                                        if i11<=32
                                            cc=circshift(shiyong,[0,i11-1]);
                                            a=cc(:,1:2);
                                            b=cc(:,length(cc(1,:))-1:length(cc(1,:)));
                                            dd(i11)=delta(a,b,2);
                                        else
                                            cc=fliplr(shiyong);
                                            ccc=circshift(cc,[0,i11-33]);
                                            a=ccc(:,1:2);
                                            b=ccc(:,length(cc(1,:))-1:length(cc(1,:)));
                                            dd(i11)=delta(a,b,2);
                                        end
                                    end
                                    dmax=max(dd);
                                    x=find(dmax==dd);
                                    if length(x)>1||dd(1)~=dmax
                                        biaoji(i,j)=0;
                                    else
                                        biaoji(i,j)=1;
                                        payload=payload+6;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    loading(i123)=payload;
    payload=0;
end
