function[Result,sigma,s,h_half,t_xy]=my_step(G,U_max,x,y,n,n_total,T_series,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy)
for  z=1:length(n)
    %先确定左上角的横、纵坐标位置
    p(:,1)=y/n(z)*(ceil(double(1:n_total(z))/n(z))-1);
    p(:,2)=y/n(z)*(double(1:n_total(z))-(ceil(double(1:n_total(z))/n(z))-1)*n(z));
    %第三、四列存储中心点的横、纵坐标
    p(:,3)=p(:,1)+y/n(z)/2;
    p(:,4)=p(:,2)-y/n(z)/2;
    %Result存储的马尔科夫状态的点的速度
    Result(:,1:2)=p(:,3:4);
    Result(:,3)=F_v(Result(:,1),Result(:,2));
    Result(:,4)=F_vx(Result(:,1),Result(:,2));
    Result(:,5)=F_vy(Result(:,1),Result(:,2));
    %计算当前马尔科夫状态的空气速度标准偏差
    sigma(z)=std(Result(:,3),1)/U_max;%存储马尔科夫状态中空气速度的标准偏差
    %至此，已经完成了马尔科夫矩阵尺寸的确定，以马尔科夫状态尺寸下的空气速度标准偏差的误差小于1%为标准
    %作图
    %q=quiver(Result(:,1),Result(:,2),Result(:,4),Result(:,5));
    %q.AutoScale='on';%自动缩放箭头长度
    %q.AutoScaleFactor=1.5;%更改箭头的长度
    %下面开始确定马尔科夫时间步长
    % x_T和y_T分别存储两方向的状态数量
    x_T = n(z)*G;
    y_T = n(z);
    n_abs = 0; %% 起始时刻，吸收态数量为0
    n_nei = 0; %% 起始时刻，相邻状态数量为0
    h_half=1/2*(min(x,y)/n(z)); %% n(z)是当前马尔科夫状态数量
    t_xy(:,1)=h_half./Result(:,4); %% t_xy第1列存储每个状态横向运动所需要的时间
    t_xy(:,2)=h_half./Result(:,5); %% t_xy第2列存储每个状态纵向运动所需要的时间
    s(:,1,z)=T_series'; %%需要一个变量来存储时间序列，以及相应的吸收态、相邻状态数量
    for m = 1:length(T_series) %% 对每个T_series的吸收态、相邻状态个数进行计算，m是T_series的个数
        for i =1 : size(Result,1) %% 先判断每一个状态，T_series是取的时间步长，目前是第i个状态
            k = i;%% 用k存储状态的最初位置
            T_s = T_series(m); %% 将第m个T_series赋值给T_s
            while T_s > min(abs(t_xy(i,1)),abs(t_xy(i,2))) %% 当T_series大于i状态的某一方向上运动所需要的时间时
                if abs(t_xy(i,1)) < abs(t_xy(i,2)) %% 如果横向运动时间短，那就是左右运动
                    T_s = T_s-abs(t_xy(i,1)); %% 更新T_series
                    if t_xy(i,1) < 0 %% 如果小于0，那么就是向左运动
                        if idivide((i-1),int16(y_T)) == 0 %% 如果是最左边1列
                            j = i; %% 用j存储当前所在状态，如果是最左边1列，则保持在该状态
                        else j = i-y_T; %% 用j存储当前所在状态，如果不是最左边1列，则向左移动，状态数为i-length(y_T)
                        end
                    elseif t_xy(i,1) > 0 %% 如果大于0，那么就是向右运动
                        if  idivide((i-1),int16(y_T)) == x_T-1 %%如果是最右边1列
                            j = i; %% 用j存储当前所在状态，如果是最右边1列，则保持在该状态
                        else j = i+y_T; %% 用j存储当前所在状态，如果不是最右边1列，则向右移动，状态数为i+length(y_T)
                        end
                    end
                elseif abs(t_xy(i,2)) < abs(t_xy(i,1)) %% 如果纵向运动时间短，那就是上下运动
                    T_s = T_s-abs(t_xy(i,2)); %% 更新T_series
                    if t_xy(i,2) < 0 %% 如果小于0，那么就是向下运动
                        if mod(i,y_T) == 1 %% 如果是最下面1行
                            j = i; %% 用j存储当前所在状态，如果是最下面1行，则保持在该状态
                        else j = i-1; %% 用j存储当前所在状态，如果不是最下面1行，则向下运动，状态数为i-1
                        end
                    elseif t_xy(i,2) > 0 %% 如果大于0，那么就是向上运动
                        if mod(i,y_T) == 0 %% 如果是最上面1行
                            j = i; %% 用j存储当前所在状态，如果是最上面1行，则保持在该状态
                        else j = i+1; %% 用j存储当前所在状态，如果不是最上面1行，则向上运动，状态数为i+1
                        end
                    end
                elseif abs(t_xy(i,1)) == abs(t_xy(i,2)) %%如果横向纵向时间一样长，那就是斜向运动
                    T_s = T_s-abs(t_xy(i,1)); %% 更新T_series
                    if t_xy(i,1) > 0 && t_xy(i,2) > 0 %% 如果都大于0，那么就是右上运动
                        if mod(i,y_T) == 0 && idivide((i-1),int16(y_T)) == x_T-1 %% 如果是右上角
                            j = i; %% 用j存储当前所在状态，如果是右上角，则保持在该状态，状态数为i
                        elseif mod(i,y_T) == 0 %% 如果是最上面1行
                            j = i+y_T; %% 用j存储当前所在状态，如果是最上面1行，则向右运动，状态数为i+length(y_T)
                        elseif idivide((i-1),int16(y_T)) == x_T-1 %%如果是最右边1列
                            j = i+1; %% 用j存储当前所在状态，如果是最右边1列，则向上运动，状态数为i+1
                        else %% 不是最上面1行或最右边1列，则向右上运动
                            j = i+y_T+1; %% 用j存储当前所在状态，不是最上面1行或最右边1列，则向右上运动，状态数为i+length(y_T)+1
                        end
                    elseif t_xy(i,1) > 0 && t_xy(i,2) < 0 %% 如果第1列大于0，第2列小于0，那么就是右下运动
                        if mod(i,y_T) == 1 && idivide((i-1),int16(y_T)) == length(x_T)-1 %% 如果是右下角
                            j = i; %% 用j存储当前所在状态，如果是右下角，则保持在该状态，状态数为i
                        elseif mod(i,y_T) == 1 %% 如果是最下面1行
                            j = i+y_T; %% 用j存储当前所在状态，如果是最下面1行，则向右运动，状态数为i+length(y_T)
                        elseif idivide((i-1),int16(y_T)) == x_T-1 %%如果是最右边1列
                            j = i-1; %% 用j存储当前所在状态，如果是最右边1列，则向下运动，状态数为i-1
                        else %% 不是最下面1行或最右边1列，则向右下运动
                            j = i+y_T-1; %% 用j存储当前所在状态，不是最下面1行或最右边1列，则向右下运动，状态数为i+length(y_T)-1
                        end
                    elseif t_xy(i,1) < 0 && t_xy(i,2) < 0 %% 如果第1列小于0，第2列小于0，那么就是左下运动
                        if idivide((i-1),int16(y_T)) == 0 && mod(i,y_T) == 1 %% 如果是左下角
                            j = i; %% 用j存储当前所在状态，如果是左下角，则保持在该状态，状态数为i
                        elseif idivide((i-1),int16(y_T)) == 0 %% 如果是最左边1列
                            j = i-1; %% 用j存储当前所在状态，如果是最左边1列，则向下运动，状态数为i-1
                        elseif mod(i,y_T) == 1 %% 如果是最下面1行
                            j = i-y_T; %% 用j存储当前所在状态，如果是最下面1行，则向左移动，状态数为i-length(y_T)
                        else %% 不是最左边1列或最下面1行，则向左下运动
                            j = i-y_T-1; %% 用j存储当前所在状态，不是最左边1列或最下面1行，则向左下运动，状态数为i-length(y_T)-1
                        end
                    elseif t_xy(i,1) < 0 && t_xy(i,2) > 0 %% 如果第1列小于0，第2列大于0，那么就是左上运动
                        if idivide((i-1),int16(y_T)) == 0 && mod(i,y_T) == 0 %% 如果是左上角
                            j = i; %% 用j存储当前所在状态，如果是左上角，则保持在该状态，状态数为i
                        elseif idivide((i-1),int16(y_T)) == 0 %% 如果是最左边1列
                            j = i+1; %% 用j存储当前所在状态，如果是最左边1列，则向上运动，状态数为i+1
                        elseif mod(i,y_T) == 0 %% 如果是最上面1行
                            j = i-y_T; %% 用j存储当前所在状态，如果是最上面1行，则向左移动，状态数为i-length(y_T)
                        else %% 不是最左边1列或最上面1行，则向左上运动
                            j = i-y_T+1; %% 用j存储当前所在状态，不是最左边1列或最上面1行，则向左上运动，状态数为i-length(y_T)+1
                        end
                    end
                end
                i = j; %% 将j的值赋给i，更新i，不断循环，直到达到T_series
                clear j; %% 在每次循环前，将j清除
            end
            % 比较i和k，从而判断是否在原来状态或者是相邻状态
            if k == i %% 如果k==i，则保持在原状态，即吸收态数量+1
                n_abs = n_abs+1; %% 吸收态数量+1
            elseif i == k+1 || i == k-1 || i == k+y_T || i == k-y_T || i == k+y_T+1 || i == k+y_T-1 || i == k-y_T+1 || i == k-y_T-1
                n_nei = n_nei+1; %% 相邻状态数量+1
            end
        end
        s(m,2,z)=n_abs; %% s的第2列，第m行，存储第m个T_series下的吸收状态
        s(m,3,z)=n_nei; %% s的第3列，第m行，存储第m个T_series下的相邻状态
        n_abs = 0; n_nei = 0;
    end
    clear p
end
Result(:,6)=F_dvxdx(Result(:,1),Result(:,2));
Result(:,7)=F_dvydx(Result(:,1),Result(:,2));
Result(:,8)=F_dvxdy(Result(:,1),Result(:,2));
Result(:,9)=F_dvydy(Result(:,1),Result(:,2));