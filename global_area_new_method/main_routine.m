%%������
%% ȷ������Ʒ�״̬�ߴ�
clear
clc

warning('off','all')
%ָ��·�����ļ���
prompt = '������ײ������ļ���ASCII��ʽ����·����Ĭ��Ϊ..\\airflow_field\\����';
path=input(prompt,'s');
default('path','..\airflow_field\');
prompt = '������ײ������ļ���ASCII��ʽ�����ļ�����Ĭ��Ϊfluent2d����';
file_name=input(prompt,'s');
default('file_name','fluent2d');
Example = my_read(path,file_name); %my_read�������ڶ�ȡ����

%ָ��������ĳߴ�
prompt = '��������μ����򳤶ȡ�Ĭ��Ϊ9����';
x = input(prompt);
default('x',9);
prompt = '��������μ������ȡ�Ĭ��Ϊ3����';
y = input(prompt);
default('y',3);
%ָ������Ʒ�״̬����
prompt = '��������ȷ��������Ʒ�״̬���������У���Ĭ��Ϊ5:5:200����';
n = input(prompt);
default('n',5:5:200);
[G,n_total,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy,U_max]=my_case(x,y,n,Example); %my_case�������ڼ���G,n_total,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy,U_max

%ȷ������Ʒ�״̬�ߴ�
[sigma]=my_size(U_max,y,n,n_total,F_v,F_vx,F_vy);%���ݼ���õ���sigmaȷ����Ҫ������Ʒ�״̬����
for i=2:size(sigma,1)
    sigma(i,3)=abs(sigma(i,2)-sigma(i-1,2));
end
plot(sigma(2:size(sigma,1),1),sigma(2:size(sigma,1),3))
title('�ٶȱ�׼ƫ���ƫ��')
xlabel('y�����ϵ�����Ʒ�״̬����')
ylabel('��׼ƫ��')
%% ȷ������Ʒ�ʱ�䲽��
%ָ������Ʒ�״̬����
prompt = '��������ȷ��������Ʒ�״̬������Ĭ��Ϊ30����';
n = input(prompt);
default('n',30);
n_total=n.*n.*double(G);
%ָ��Ҫ���ǵĲ�ͬ��ʱ��������
prompt = '��������ȷ����ʱ�䲽�������У���Ĭ��Ϊ0.1087:0.05:10����';
T_series = input(prompt);%0.1087:0.05:10;
default('T_series',0.1087:0.05:10);
[Result,sigma,s,h_half,t_xy]=my_step(G,U_max,x,y,n,n_total,T_series,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy);%my_step�������ڼ�������Ʒ�״̬ʱ�䲽��
% �����ݹ�һ�����������ܵ�״̬����
n_total = n.*n*single(G);
s_std = zeros(size(T_series,2),4,length(n_total)); %% Ԥ��Ϊ������ڴ�
for i =1:length(n_total)
    s_std(:,1,i)=s(:,1,i);
    s_std(:,2:3,i)=s(:,2:3,i)/n_total(i);
    s_std(:,4,i)=log10(s_std(:,1,i)*U_max/y);
end
% ��ͼ
% ����̬��ͼ
figure
for i =1:size(s_std,3)
    plot(s_std(:,1,i),s_std(:,2,i))
    hold on
end
title('����״̬�仯')
legend(arrayfun(@num2str,n,'UniformOutput',false)) %% Ϊͼ�����ͼ��
xlabel('����Ʒ�ʱ�䲽��')
ylabel('����')
% ����״̬��ͼ
figure
for i =1:size(s_std,3)
    plot(s_std(:,1,i),s_std(:,3,i))
    hold on
end
title('����״̬�仯')
legend(arrayfun(@num2str,n,'UniformOutput',false)) %% Ϊͼ�����ͼ��
xlabel('����Ʒ�ʱ�䲽��')
ylabel('����')
s_std=[{'ʱ�䲽��','����״̬','����״̬','����ʱ�䲽��'};num2cell(s_std)];
% ��s_stdд��
xlswrite('s_std.csv',s_std);
save('value_A','Example','Result','G','n','n_total','h_half','t_xy','x','y')
% �жϵ�Ԫ����
clear
clc
load('value_A')
%ָ������Ʒ�ʱ�䲽��
prompt = '��������ȷ��������Ʒ�ʱ�䲽����Ĭ��Ϊ0.865����';
t=input(prompt);%0.865
default('t',0.865);
% Result����洢��״̬��x,y���꣬vm,vx,vy�ٶȣ�dvxx,dvyx,dvxy,dvyy�ٶ��ݶȵ���Ϣ��
% t_xy�洢ÿ��״̬�ز�ͬ�����˶�����ʱ��
% ��ʼ����ÿ��״̬���ٶ��ݶȵ�L1����
eps_def = zeros(1,size(Result,1)); %% Ԥ��Ϊ������ڴ�
for i = 1: size(Result,1)
    eps_def(i) = norm(Result(i,6:9),1);
end
clear i
% �ҵ��������ĵ�Ԫ
eps_max = find(eps_def==max(eps_def));
% ��p�洢���ϡ����ϡ����¡����½ڵ��x��y����ֵ
p(1)=Result(eps_max,1)-h_half;
p(2)=Result(eps_max,2)+h_half;
p(3)=Result(eps_max,1)+h_half;
p(4)=p(2);
p(5)=p(3);
p(6)=Result(eps_max,2)-h_half;
p(7)=p(1);
p(8)=p(6);
prompt = '��������ȷ����ÿ���߽������������У���Ĭ��Ϊ2:100����';
p_edge=input(prompt);
default('p_edge',2:100)
% ��ʼѭ����������仯
eps_npts = zeros(length(p_edge),2); %% Ԥ��Ϊ������ڴ�
s = zeros(1,length(p_edge)); %% Ԥ��Ϊ������ڴ�
% ��Example���ݲ�ֵ
% F1Ϊv_x�Ĳ�ֵ��F2Ϊv_y
F1 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,4));
F2 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,5));
figure
for i = 1:length(p_edge)
    eps_npts(:,1) = p_edge';
    % e��һ�д洢һ���㣬ǰp_edge������߽�ģ�p_edge+1��2*p_edge-1���ϱ߽�ĵ㣬
    % 2*p_edge+1��3*p_edge���ұ߽�ĵ㣬3*p_edge+1��4*p_edge-3���±߽�ĵ㡣
    % ��߽�
    e((1:p_edge(i))+((p_edge(i)-1)*4+1)*(i-1),1)=p(1);%��߽��x
    e((1:p_edge(i))+((p_edge(i)-1)*4+1)*(i-1),2)=linspace(p(8),p(2),p_edge(i));%��߽��y
    % �ϱ߽�
    e_top=linspace(p(1),p(3),p_edge(i));
    e((p_edge(i)+1:2*p_edge(i)-1)+((p_edge(i)-1)*4+1)*(i-1),1)=e_top(2:p_edge(i));%�ϱ߽��x
    e((p_edge(i)+1:2*p_edge(i)-1)+((p_edge(i)-1)*4+1)*(i-1),2)=p(2);%�ϱ߽��y
    % �ұ߽�
    e_right=linspace(p(4),p(6),p_edge(i));
    e((2*p_edge(i):3*p_edge(i)-2)+((p_edge(i)-1)*4+1)*(i-1),1)=p(3);%�ұ߽��x
    e((2*p_edge(i):3*p_edge(i)-2)+((p_edge(i)-1)*4+1)*(i-1),2)=e_right(2:p_edge(i));%�ұ߽��y
    % �±߽�
    e_down=linspace(p(5),p(7),p_edge(i));
    e((3*p_edge(i)-1:4*p_edge(i)-3)+((p_edge(i)-1)*4+1)*(i-1),1)=e_down(2:p_edge(i));%�±߽��x
    e((3*p_edge(i)-1:4*p_edge(i)-3)+((p_edge(i)-1)*4+1)*(i-1),2)=p(8);%�±߽��y 
    clear e_top e_right e_down
    % v_x��v_y
    e(:,3) = F1(e(:,1),e(:,2));
    e(:,4) = F2(e(:,1),e(:,2));
    % e_final�洢���յ�����
    e_final(:,1)=e(:,1)+t*e(:,3);
    e_final(:,2)=e(:,2)+t*e(:,4);
    p_i = e_final((1:(4*p_edge(i)-3))+((p_edge(i)-1)*4+1)*(i-1),1:2);
    x_i = p_i(:,1);
    y_i = p_i(:,2);
    s(i) = polyarea(x_i,y_i); %% ������κ�����
    hold on
    plot(x_i,y_i);
    if i > 1
        eps_npts(i,2) = n*single(G)*n*abs((s(i-1)-s(i))/s(i)); %% eps_npts��2�д洢����仯��
    end
    clear e e_final
end
title(['�����ε�Ԫ�ı���Ϊ' eps_max])
s=[eps_npts(:,1)';s(1,:)]';
figure
plot(s(:,1),s(:,2))
title('�����ε�Ԫ������仯��')
xlabel('�߽�������')
ylabel('�仯��')
save('value_B','Example','Result','G','n','h_half','t_xy','t','x','y')
%% �������㷨�µ�ת�Ƹ���
clear
clc
load('value_B')
%ָ��ÿ���߽�����Ӹ����������߽�˵㣩
prompt = '��������ȷ����ÿ���߽������������У���Ĭ��Ϊ25����';
p_edge=input(prompt);%������Ϊ25
default('p_edge',25)
prompt = '��ȷ���Ƿ��г��ڣ���������1������������0��Ĭ��Ϊ1����';
outlet=input(prompt);%������Ϊ1
default('outlet',1)
%ָ���ܰ������������ĳ�������
if outlet == 1
    prompt = '����������������Ͻڵ��λ�á�Ĭ��Ϊ[9 0.5]����';
    P_LT_O =input(prompt);%������Ϊ[9 0.5]
    default('P_LT_O',[9 0.5])
    prompt = '����������������Ͻڵ��λ�á�Ĭ��Ϊ[10 0.5]����';
    P_RT_O =input(prompt);%������Ϊ[10 0.5]
    default('P_RT_O',[10 0.5])
    prompt = '����������������½ڵ��λ�á�Ĭ��Ϊ[9 -0.5]����';
    P_LD_O =input(prompt);%������Ϊ[9 -0.5]
    default('P_LD_O',[9 -0.5])
    prompt = '����������������½ڵ��λ�á�Ĭ��Ϊ[10 -0.5]����';
    P_RD_O =input(prompt);%������Ϊ[10 -0.5]
    default('P_RD_O',[10 -0.5])
    P_O = [P_LT_O;P_RT_O;P_RD_O;P_LD_O;P_LT_O]; %outlet��λ��
end
%��������״̬�ߴ�
size_C = h_half*2;
%�������������Ʒ�״̬������
n_total = n * n * G;
% F1Ϊv_x�Ĳ�ֵ��F2Ϊv_y
F1 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,4));
F2 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,5));

%��ȷ�����Ͻǵĺᡢ������λ��
p(:,1)=size_C*(ceil(double(1:n_total)/n)-1);
p(:,2)=size_C*(double(1:n_total)-(ceil(double(1:n_total)/n)-1)*n);
%���������д洢���Ͻǵĺᡢ������λ��
p(:,3) = p(:,1)+size_C;
p(:,4) = p(:,2);
%���塢���д洢���½ǵĺᡢ������λ��
p(:,5) = p(:,3);
p(:,6) = p(:,2)-size_C;
%���ߡ����д洢���½ǵĺᡢ������λ��
p(:,7) = p(:,1);
p(:,8) = p(:,2)-size_C;

for i = 1:size(p,1)
    % e��һ�д洢һ���㣬ǰp_edge������߽�ģ�p_edge+1��2*p_edge-1���ϱ߽�ĵ㣬
    % 2*p_edge+1��3*p_edge���ұ߽�ĵ㣬3*p_edge+1��4*p_edge-3���±߽�ĵ㡣
    % ��߽�
    e((1:p_edge)+((p_edge-1)*4+1)*(i-1),1)=p(i,1);%��߽��x
    e((1:p_edge)+((p_edge-1)*4+1)*(i-1),2)=linspace(p(i,8),p(i,2),p_edge);%��߽��y
    % �ϱ߽�
    e_top=linspace(p(i,1),p(i,3),p_edge);
    e((p_edge+1:2*p_edge-1)+((p_edge-1)*4+1)*(i-1),1)=e_top(2:p_edge);%�ϱ߽��x
    e((p_edge+1:2*p_edge-1)+((p_edge-1)*4+1)*(i-1),2)=p(i,2);%�ϱ߽��y
    % �ұ߽�
    e_right=linspace(p(i,4),p(i,6),p_edge);
    e((2*p_edge:3*p_edge-2)+((p_edge-1)*4+1)*(i-1),1)=p(i,3);%�ұ߽��x
    e((2*p_edge:3*p_edge-2)+((p_edge-1)*4+1)*(i-1),2)=e_right(2:p_edge);%�ұ߽��y
    % �±߽�
    e_down=linspace(p(i,5),p(i,7),p_edge);
    e((3*p_edge-1:4*p_edge-3)+((p_edge-1)*4+1)*(i-1),1)=e_down(2:p_edge);%�±߽��x
    e((3*p_edge-1:4*p_edge-3)+((p_edge-1)*4+1)*(i-1),2)=p(i,8);%�±߽��y 
    clear e_top e_right e_down
end
% e��һ�д洢һ���㣬��3���ǵ��v_x����4���ǵ��v_y��
e(:,3) = F1(e(:,1),e(:,2));
e(:,4) = F2(e(:,1),e(:,2));
% e_final��洢�߽��ϵĵ������λ�ã�һ�д洢һ���㣬��1����x����2����y��
e_final(:,1)=e(:,1)+t*e(:,3);
e_final(:,2)=e(:,2)+t*e(:,4);
tic
for i = 1:size(p,1) %%���Ӧ���Ǳ仯���
     p_i = e_final((1:(4*p_edge-3))+((p_edge-1)*4+1)*(i-1),1:2);
     x_i = p_i(:,1);
     y_i = p_i(:,2);
     p_i_o = e((1:(4*p_edge-3))+((p_edge-1)*4+1)*(i-1),1:2);
     x_i_o = p_i_o(:,1);
     y_i_o = p_i_o(:,2);
    for j = 1:size(p,1)  %%�ڲ�Ӧ���Ǳ仯ǰ��
        p_j = e((1:(4*p_edge-3))+((p_edge-1)*4+1)*(j-1),1:2);
        x_j = p_j(:,1);
        y_j = p_j(:,2);
        if min(x_i)>=max(x_j) || max(x_i)<=min(x_j) || min(y_i)>=max(y_j) || max(y_i)<=min(y_j)
            P(i,j) = 0;
        else
            x_i_std = (x_i-min([x_i',x_i_o',x_j']))/(max([x_i',x_i_o',x_j'])-min([x_i',x_i_o',x_j']))*1000;
            y_i_std = -(y_i-max([y_i',y_i_o',y_j']))/(max([y_i',y_i_o',y_j'])-min([y_i',y_i_o',y_j']))*1000;
            x_j_std = (x_j-min([x_i',x_i_o',x_j']))/(max([x_i',x_i_o',x_j'])-min([x_i',x_i_o',x_j']))*1000;
            y_j_std = -(y_j-max([y_i',y_i_o',y_j']))/(max([y_i',y_i_o',y_j'])-min([y_i',y_i_o',y_j']))*1000;
            x_i_o_std = (x_i_o-min([x_i',x_i_o',x_j']))/(max([x_i',x_i_o',x_j'])-min([x_i',x_i_o',x_j']))*1000;
            y_i_o_std = -(y_i_o-max([y_i',y_i_o',y_j']))/(max([y_i',y_i_o',y_j'])-min([y_i',y_i_o',y_j']))*1000;
            bw_i = poly2mask(x_i_std,y_i_std,1000,1000);%bw_i��Դͷ��Ԫ�仯���
            bw_j = poly2mask(x_j_std,y_j_std,1000,1000);%bw_j���ն˵�Ԫ�仯ǰ��
            bw_i_o = poly2mask(x_i_o_std,y_i_o_std,1000,1000);%bw_i_o��Դͷ��Ԫ�仯ǰ��
            P(i,j) = bwarea(bw_i&bw_j)/bwarea(bw_i_o&bw_i_o);%P��¼��������ĸ��ʼ��㷽��
        end
    end
    % �ڴ����ӳ��ڵ�����״̬
    if outlet==1
        if max(x_i)<=min(P_O(:,1)) || min(y_i)>=max(P_O(:,2))
            P(i,size(p,1)+1) = 0;
        else
            clear x_i_std y_i_std x_j_std y_j_std x_i_o_std y_i_o_std
            P(i,size(p,1)+1) = 1-sum(P(i,1:size(p,1)));
        end
    end
end
toc
save('value_C','Example','Result','G','P','n','n_total','h_half','t_xy','t','outlet','x','y')
csvwrite('P.csv',P);
%%  ʹ�����㷨�µ�ת�Ƹ��ʼ�����Ⱦ������
clear
clc
load('value_C')
load('A_mycolormap')
%Ϊ��ʼ��Ⱦ��Ũ�ȳ���ֵ
disp('��ʼŨ�ȳ�����Ĭ�����ã�y<=1.5Ϊ0��y>1.5Ϊ1����������ģ����޸Ĵ����285�е�291�С�')
for i = 1:n_total
        if Result(i,2)<=1.5
            c_0(i,1)=0;
        else
            c_0(i,1)=1;
        end
end
[xq,yq]=meshgrid(0:h_half:x,0:h_half:y);
figure
[x_1,y_1,c_1]=griddata(Result(:,1),Result(:,2),c_0,xq,yq,'v4');
contourf(x_1,y_1,c_1,20,'LineStyle','none')
colorbar
lim = caxis;
caxis([0 1])
colormap(mycolormap)
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 18 6];
saveas(gcf,['initial' '.png'])
disp('����Գ�ʼŨ�ȳ���ͼ�����ԡ�initial.png��Ϊ�ļ����洢��Ӳ����')
%ָ������ʱ��
prompt='��ָ������ʱ�̣�������������ʱ�䣬����ʵʱ����ʱ�䲽���ı�ֵ���������������У���Ĭ��Ϊ10:20:90����';
t_total=input(prompt);
default('t_total',10:20:90)
close all
for i =1:length(t_total)
    if outlet == 0
        c_final = (c_0'*P^t_total(i))';
    else
        c_final = (c_0'*P(:,1:n_total)^t_total(i))';
    end
    [x_1,y_1,c_2]=griddata(Result(:,1),Result(:,2),c_final,xq,yq,'v4');
    c_matlab(:,:,i)=c_2;
    xlswrite('c_matlab.xlsx',c_matlab(:,:,i),num2str(i))
    contourf(x_1,y_1,c_2,20,'LineStyle','none')
    colorbar
    lim = caxis;
    caxis([0 1])
    colormap(mycolormap)
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 18 6];
    saveas(gcf,[num2str(t_total(i)) '.png'])
    close
end
save('c_matlab','c_matlab')
save('value_C','Example','Result','G','P','n','n_total','h_half','t_xy','t','outlet','x','y','t_total')
disp('�Ѿ��������Ⱦ��Ũ�ȷֲ������ԡ�������ʱ��.png��Ϊ�ļ����洢��Ӳ����')