function[G,n_total,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy,U_max]=my_case(x,y,n,Example)
%求长度和高度的倍数关系
G=int32(max(x,y)/min(x,y));
%计算总的马尔科夫状态数量
n_total=n.*n.*double(G);
% F_v为v的插值，F_vx为vx的插值，F_vy为vy的插值
F_v = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,3));
F_vx= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,4));
F_vy= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,5));
F_dvxdx= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,6));
F_dvydx= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,7));
F_dvxdy= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,8));
F_dvydy= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,8));
%存储计算域内的最大速度
U_max=max(Example(:,3));