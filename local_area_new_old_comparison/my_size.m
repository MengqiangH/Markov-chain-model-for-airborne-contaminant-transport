function[sigma]=my_size(U_max,y,n,n_total,F_v,F_vx,F_vy)
for z=1:length(n)
    %��ȷ�����Ͻǵĺᡢ������λ��
    p(:,1)=y/n(z)*(ceil(double(1:n_total(z))/n(z))-1);
    p(:,2)=y/n(z)*(double(1:n_total(z))-(ceil(double(1:n_total(z))/n(z))-1)*n(z));
    %���������д洢���ĵ�ĺᡢ������
    p(:,3)=p(:,1)+y/n(z)/2;
    p(:,4)=p(:,2)-y/n(z)/2;
    %Result�洢������Ʒ�״̬�ĵ���ٶ�
    Result(:,1:2)=p(:,3:4);
    Result(:,3)=F_v(Result(:,1),Result(:,2));
    Result(:,4)=F_vx(Result(:,1),Result(:,2));
    Result(:,5)=F_vy(Result(:,1),Result(:,2));
    %���㵱ǰ����Ʒ�״̬�Ŀ����ٶȱ�׼ƫ��
    sigma(z,1)=n(z);
    sigma(z,2)=std(Result(:,3),1)/U_max;%�洢����Ʒ�״̬�п����ٶȵı�׼ƫ��
    %���ˣ��Ѿ����������Ʒ����ߴ��ȷ����������Ʒ�״̬�ߴ��µĿ����ٶȱ�׼ƫ������С��1%Ϊ��׼
    clear p Result
  end