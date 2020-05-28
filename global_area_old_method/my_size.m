function[sigma]=my_size(U_max,y,n,n_total,F_v,F_vx,F_vy)
for z=1:length(n)
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
    sigma(z,1)=n(z);
    sigma(z,2)=std(Result(:,3),1)/U_max;%存储马尔科夫状态中空气速度的标准偏差
    %至此，已经完成了马尔科夫矩阵尺寸的确定，以马尔科夫状态尺寸下的空气速度标准偏差的误差小于1%为标准
    clear p Result
  end