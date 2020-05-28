%%主程序
%% 确定马尔科夫状态尺寸
clear
clc

warning('off','all')
%指定路径与文件名
prompt = '请输入底层流场文件（ASCII格式）的路径【默认为..\\airflow_field\\】：';
path=input(prompt,'s');
default('path','..\airflow_field\');
prompt = '请输入底层流场文件（ASCII格式）的文件名【默认为fluent2d】：';
file_name=input(prompt,'s');
default('file_name','fluent2d');
Example = my_read(path,file_name); %my_read函数用于读取数据

%指定计算域的尺寸
prompt = '请输入矩形计算域长度【默认为9】：';
x = input(prompt);
default('x',9);
prompt = '请输入矩形计算域宽度【默认为3】：';
y = input(prompt);
default('y',3);
%指定马尔科夫状态数量
prompt = '请输入您确定的马尔科夫状态数量（数列）【默认为5:5:200】：';
n = input(prompt);
default('n',5:5:200);
[G,n_total,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy,U_max]=my_case(x,y,n,Example); %my_case函数用于计算G,n_total,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy,U_max

%确定马尔科夫状态尺寸
[sigma]=my_size(U_max,y,n,n_total,F_v,F_vx,F_vy);%根据计算得到的sigma确定需要的马尔科夫状态数量
for i=2:size(sigma,1)
    sigma(i,3)=abs(sigma(i,2)-sigma(i-1,2));
end
plot(sigma(2:size(sigma,1),1),sigma(2:size(sigma,1),3))
title('速度标准偏差的偏差')
xlabel('y方向上的马尔科夫状态数量')
ylabel('标准偏差')
%% 确定马尔科夫时间步长
%指定马尔科夫状态数量
prompt = '请输入您确定的马尔科夫状态数量【默认为30】：';
n = input(prompt);
default('n',30);
n_total=n.*n.*double(G);
%指定要考虑的不同的时间间隔长度
prompt = '请输入您确定的时间步长（数列）【默认为0.1087:0.05:10】：';
T_series = input(prompt);%0.1087:0.05:10;
default('T_series',0.1087:0.05:10);
[Result,sigma,s,h_half,t_xy]=my_step(G,U_max,x,y,n,n_total,T_series,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy);%my_step函数用于计算马尔科夫状态时间步长
% 将数据归一化，即除以总的状态数量
n_total = n.*n*single(G);
s_std = zeros(size(T_series,2),4,length(n_total)); %% 预先为其分配内存
for i =1:length(n_total)
    s_std(:,1,i)=s(:,1,i);
    s_std(:,2:3,i)=s(:,2:3,i)/n_total(i);
    s_std(:,4,i)=log10(s_std(:,1,i)*U_max/y);
end
% 作图
% 吸收态作图
figure
for i =1:size(s_std,3)
    plot(s_std(:,1,i),s_std(:,2,i))
    hold on
end
title('吸收状态变化')
legend(arrayfun(@num2str,n,'UniformOutput',false)) %% 为图表添加图例
xlabel('马尔科夫时间步长')
ylabel('比例')
% 相邻状态作图
figure
for i =1:size(s_std,3)
    plot(s_std(:,1,i),s_std(:,3,i))
    hold on
end
title('相邻状态变化')
legend(arrayfun(@num2str,n,'UniformOutput',false)) %% 为图表添加图例
xlabel('马尔科夫时间步长')
ylabel('比例')
s_std=[{'时间步长','吸收状态','相邻状态','对数时间步长'};num2cell(s_std)];
% 将s_std写出
xlswrite('s_std.csv',s_std);
save('value_A','Example','Result','G','n','n_total','h_half','t_xy','x','y')
% 判断单元变形
clear
clc
load('value_A')
%指定马尔科夫时间步长
prompt = '请输入您确定的马尔科夫时间步长【默认为0.865】：';
t=input(prompt);%0.865
default('t',0.865);
% Result里面存储着状态的x,y坐标，vm,vx,vy速度，dvxx,dvyx,dvxy,dvyy速度梯度等信息。
% t_xy存储每个状态沿不同方向运动所需时间
% 开始计算每个状态的速度梯度的L1范数
eps_def = zeros(1,size(Result,1)); %% 预先为其分配内存
for i = 1: size(Result,1)
    eps_def(i) = norm(Result(i,6:9),1);
end
clear i
% 找到变形最大的单元
eps_max = find(eps_def==max(eps_def));
% 用p存储左上、右上、右下、左下节点的x、y坐标值
p(1)=Result(eps_max,1)-h_half;
p(2)=Result(eps_max,2)+h_half;
p(3)=Result(eps_max,1)+h_half;
p(4)=p(2);
p(5)=p(3);
p(6)=Result(eps_max,2)-h_half;
p(7)=p(1);
p(8)=p(6);
prompt = '请输入您确定的每条边界粒子数（数列）【默认为2:100】：';
p_edge=input(prompt);
default('p_edge',2:100)
% 开始循环计算面积变化
eps_npts = zeros(length(p_edge),2); %% 预先为其分配内存
s = zeros(1,length(p_edge)); %% 预先为其分配内存
% 将Example数据插值
% F1为v_x的插值，F2为v_y
F1 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,4));
F2 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,5));
figure
for i = 1:length(p_edge)
    eps_npts(:,1) = p_edge';
    % e的一行存储一个点，前p_edge行是左边界的，p_edge+1到2*p_edge-1是上边界的点，
    % 2*p_edge+1到3*p_edge是右边界的点，3*p_edge+1到4*p_edge-3是下边界的点。
    % 左边界
    e((1:p_edge(i))+((p_edge(i)-1)*4+1)*(i-1),1)=p(1);%左边界的x
    e((1:p_edge(i))+((p_edge(i)-1)*4+1)*(i-1),2)=linspace(p(8),p(2),p_edge(i));%左边界的y
    % 上边界
    e_top=linspace(p(1),p(3),p_edge(i));
    e((p_edge(i)+1:2*p_edge(i)-1)+((p_edge(i)-1)*4+1)*(i-1),1)=e_top(2:p_edge(i));%上边界的x
    e((p_edge(i)+1:2*p_edge(i)-1)+((p_edge(i)-1)*4+1)*(i-1),2)=p(2);%上边界的y
    % 右边界
    e_right=linspace(p(4),p(6),p_edge(i));
    e((2*p_edge(i):3*p_edge(i)-2)+((p_edge(i)-1)*4+1)*(i-1),1)=p(3);%右边界的x
    e((2*p_edge(i):3*p_edge(i)-2)+((p_edge(i)-1)*4+1)*(i-1),2)=e_right(2:p_edge(i));%右边界的y
    % 下边界
    e_down=linspace(p(5),p(7),p_edge(i));
    e((3*p_edge(i)-1:4*p_edge(i)-3)+((p_edge(i)-1)*4+1)*(i-1),1)=e_down(2:p_edge(i));%下边界的x
    e((3*p_edge(i)-1:4*p_edge(i)-3)+((p_edge(i)-1)*4+1)*(i-1),2)=p(8);%下边界的y 
    clear e_top e_right e_down
    % v_x和v_y
    e(:,3) = F1(e(:,1),e(:,2));
    e(:,4) = F2(e(:,1),e(:,2));
    % e_final存储最终的坐标
    e_final(:,1)=e(:,1)+t*e(:,3);
    e_final(:,2)=e(:,2)+t*e(:,4);
    p_i = e_final((1:(4*p_edge(i)-3))+((p_edge(i)-1)*4+1)*(i-1),1:2);
    x_i = p_i(:,1);
    y_i = p_i(:,2);
    s(i) = polyarea(x_i,y_i); %% 计算变形后的面积
    hold on
    plot(x_i,y_i);
    if i > 1
        eps_npts(i,2) = n*single(G)*n*abs((s(i-1)-s(i))/s(i)); %% eps_npts第2行存储面积变化率
    end
    clear e e_final
end
title(['最大变形单元的变形为' eps_max])
s=[eps_npts(:,1)';s(1,:)]';
figure
plot(s(:,1),s(:,2))
title('最大变形单元的面积变化率')
xlabel('边界粒子数')
ylabel('变化率')
save('value_B','Example','Result','G','n','h_half','t_xy','t','x','y')
%% 计算新算法下的转移概率
clear
clc
load('value_B')
%指定每条边界的粒子个数（包括边界端点）
prompt = '请输入您确定的每条边界粒子数（数列）【默认为25】：';
p_edge=input(prompt);%本例中为25
default('p_edge',25)
prompt = '请确定是否有出口，有请输入1，否则请输入0【默认为1】：';
outlet=input(prompt);%本例中为1
default('outlet',1)
%指定能包含逃逸气流的出口区域
if outlet == 1
    prompt = '请输入代表外界的左上节点的位置【默认为[9 0.5]】：';
    P_LT_O =input(prompt);%本例中为[9 0.5]
    default('P_LT_O',[9 0.5])
    prompt = '请输入代表外界的右上节点的位置【默认为[10 0.5]】：';
    P_RT_O =input(prompt);%本例中为[10 0.5]
    default('P_RT_O',[10 0.5])
    prompt = '请输入代表外界的左下节点的位置【默认为[9 -0.5]】：';
    P_LD_O =input(prompt);%本例中为[9 -0.5]
    default('P_LD_O',[9 -0.5])
    prompt = '请输入代表外界的右下节点的位置【默认为[10 -0.5]】：';
    P_RD_O =input(prompt);%本例中为[10 -0.5]
    default('P_RD_O',[10 -0.5])
    P_O = [P_LT_O;P_RT_O;P_RD_O;P_LD_O;P_LT_O]; %outlet的位置
end
%计算区域状态尺寸
size_C = h_half*2;
%计算区域的马尔科夫状态总数量
n_total = n * n * G;
% F1为v_x的插值，F2为v_y
F1 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,4));
F2 = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,5));

%先确定左上角的横、纵坐标位置
p(:,1)=size_C*(ceil(double(1:n_total)/n)-1);
p(:,2)=size_C*(double(1:n_total)-(ceil(double(1:n_total)/n)-1)*n);
%第三、四列存储右上角的横、纵坐标位置
p(:,3) = p(:,1)+size_C;
p(:,4) = p(:,2);
%第五、六列存储右下角的横、纵坐标位置
p(:,5) = p(:,3);
p(:,6) = p(:,2)-size_C;
%第七、八列存储左下角的横、纵坐标位置
p(:,7) = p(:,1);
p(:,8) = p(:,2)-size_C;

for i = 1:size(p,1)
    % e的一行存储一个点，前p_edge行是左边界的，p_edge+1到2*p_edge-1是上边界的点，
    % 2*p_edge+1到3*p_edge是右边界的点，3*p_edge+1到4*p_edge-3是下边界的点。
    % 左边界
    e((1:p_edge)+((p_edge-1)*4+1)*(i-1),1)=p(i,1);%左边界的x
    e((1:p_edge)+((p_edge-1)*4+1)*(i-1),2)=linspace(p(i,8),p(i,2),p_edge);%左边界的y
    % 上边界
    e_top=linspace(p(i,1),p(i,3),p_edge);
    e((p_edge+1:2*p_edge-1)+((p_edge-1)*4+1)*(i-1),1)=e_top(2:p_edge);%上边界的x
    e((p_edge+1:2*p_edge-1)+((p_edge-1)*4+1)*(i-1),2)=p(i,2);%上边界的y
    % 右边界
    e_right=linspace(p(i,4),p(i,6),p_edge);
    e((2*p_edge:3*p_edge-2)+((p_edge-1)*4+1)*(i-1),1)=p(i,3);%右边界的x
    e((2*p_edge:3*p_edge-2)+((p_edge-1)*4+1)*(i-1),2)=e_right(2:p_edge);%右边界的y
    % 下边界
    e_down=linspace(p(i,5),p(i,7),p_edge);
    e((3*p_edge-1:4*p_edge-3)+((p_edge-1)*4+1)*(i-1),1)=e_down(2:p_edge);%下边界的x
    e((3*p_edge-1:4*p_edge-3)+((p_edge-1)*4+1)*(i-1),2)=p(i,8);%下边界的y 
    clear e_top e_right e_down
end
% e的一行存储一个点，第3列是点的v_x，第4列是点的v_y，
e(:,3) = F1(e(:,1),e(:,2));
e(:,4) = F2(e(:,1),e(:,2));
% e_final里存储边界上的点的最终位置，一行存储一个点，第1列是x，第2列是y。
e_final(:,1)=e(:,1)+t*e(:,3);
e_final(:,2)=e(:,2)+t*e(:,4);
tic
for i = 1:size(p,1) %%外层应该是变化后的
     p_i = e_final((1:(4*p_edge-3))+((p_edge-1)*4+1)*(i-1),1:2);
     x_i = p_i(:,1);
     y_i = p_i(:,2);
     p_i_o = e((1:(4*p_edge-3))+((p_edge-1)*4+1)*(i-1),1:2);
     x_i_o = p_i_o(:,1);
     y_i_o = p_i_o(:,2);
    for j = 1:size(p,1)  %%内层应该是变化前的
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
            bw_i = poly2mask(x_i_std,y_i_std,1000,1000);%bw_i是源头单元变化后的
            bw_j = poly2mask(x_j_std,y_j_std,1000,1000);%bw_j是终端单元变化前的
            bw_i_o = poly2mask(x_i_o_std,y_i_o_std,1000,1000);%bw_i_o是源头单元变化前的
            P(i,j) = bwarea(bw_i&bw_j)/bwarea(bw_i_o&bw_i_o);%P记录了新提出的概率计算方法
        end
    end
    % 在此增加出口的吸收状态
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
%%  使用新算法下的转移概率计算污染物输运
clear
clc
load('value_C')
load('A_mycolormap')
%为初始污染物浓度场赋值
disp('初始浓度场采用默认设置（y<=1.5为0，y>1.5为1），如需更改，请修改代码第285行到291行。')
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
disp('已针对初始浓度场作图，并以‘initial.png’为文件名存储在硬盘中')
%指定计算时刻
prompt='请指定计算时刻（请输入无量纲时间，即真实时间与时间步长的比值，请输入整数数列）【默认为10:20:90】：';
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
disp('已经计算出污染物浓度分布，并以‘无量纲时间.png’为文件名存储在硬盘中')