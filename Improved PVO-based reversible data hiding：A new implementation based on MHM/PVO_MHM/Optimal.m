function [context,Offsets,index,opt_R_S,NL,MAX,MIN] = Optimal(I,PS,context)
% ����˵���������Ų�����������Ԥ�����ظ����Ͳ�������
% ���룺I��ͼ�����,PS����Ҫ��Ƕ��������,context��Ԥ�����ظ�����
% �����context���޸ĵ�Ԥ�����ظ�����,Offsets��54�鲹��������,index�����Ų���������������,opt_R_S���Ż�������,NL������ˮƽ��,MAX��Ԥ�����ݵ����ֵ��,MIN��Ԥ�����ݵ���Сֵ��
% I = change_ori_I;
%% ��������ͼ�������ˮƽ�Լ�Ԥ�����ݵ����ֵ����Сֵ
[NL,MAX,MIN] = Noise_Level(I,context);
%% ��ʼ����������
r_s = zeros(2,256); %��ʼ��ȫΪ0,����256��ֱ��ͼ
r_s(1,1) = -1;
[Offsets] = Offset_Manners(r_s);
%% ���54�鲹������������һ�鲹������
[index] = Offset_Select(I,context,NL,MAX,MIN,Offsets,PS);
%% �����Ż�
if index~=-1
    R_S = Offsets{index};
    [opt_R_S] = Offset_Optimize(I,context,NL,MAX,MIN,R_S,PS);
elseif index==-1 && context>2
    context = context-1;
    [context,Offsets,index,opt_R_S,NL,MAX,MIN] = Optimal(I,PS,context);
else
    disp('�������Ƕ������!');
end
end