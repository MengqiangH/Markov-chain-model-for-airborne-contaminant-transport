function[G,n_total,F_v,F_vx,F_vy,F_dvxdx,F_dvydx,F_dvxdy,F_dvydy,U_max]=my_case(x,y,n,Example)
%�󳤶Ⱥ͸߶ȵı�����ϵ
G=int32(max(x,y)/min(x,y));
%�����ܵ�����Ʒ�״̬����
n_total=n.*n.*double(G);
% F_vΪv�Ĳ�ֵ��F_vxΪvx�Ĳ�ֵ��F_vyΪvy�Ĳ�ֵ
F_v = scatteredInterpolant(Example(:,1),Example(:,2),Example(:,3));
F_vx= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,4));
F_vy= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,5));
F_dvxdx= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,6));
F_dvydx= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,7));
F_dvxdy= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,8));
F_dvydy= scatteredInterpolant(Example(:,1),Example(:,2),Example(:,8));
%�洢�������ڵ�����ٶ�
U_max=max(Example(:,3));