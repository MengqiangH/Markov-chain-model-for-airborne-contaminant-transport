%%主程序
%%  生成CFD方法得到的制定时刻的污染物浓度场
clear
clc
warning('off','all')
cd ..\global_area_new_method\
load('value_C')
cd ..\airflow_field\
load('A_mycolormap')
file_name= dir ('*.csv');
for i = 1:length(file_name)
    fid=fopen(file_name(i).name,'r','n','UTF-8');
    uds_cfd=cell2mat(textscan(fid,'%f %f %f %f','Delimiter',',','HeaderLines',1));
    [xq,yq]=meshgrid(0:h_half:x,0:h_half:y);
    [x_cfd,y_cfd,c_cfd(:,:,i)]=griddata(uds_cfd(:,2),uds_cfd(:,3),uds_cfd(:,4),xq,yq);
    xlswrite([extractBefore(file_name(i).name,'.') '.xlsx'],c_cfd(:,:,i))
    figure
    contourf(x_cfd,y_cfd,c_cfd(:,:,i),20,'LineStyle','none')
    colorbar
    lim = caxis;
    caxis([0 1])
    colormap(mycolormap)
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 18 6];
    cd ..\CFD_cases\
    saveas(gcf,[extractBefore(file_name(i).name,'.') '.png'])
    cd ..\airflow_field\
    close
end
%% 计算新的马尔科夫方法计算结果的相关系数和平均绝对误差
clear
clc
cd ..\global_area_new_method\
load('value_C')
load('c_matlab')
cd ..\airflow_field\
for i = 1:length(t_total)
    fid=fopen([num2str(t_total(i)) '.csv'],'r','n','UTF-8');
    uds_cfd=cell2mat(textscan(fid,'%f %f %f %f','Delimiter',',','HeaderLines',1));
    [xq,yq]=meshgrid(0:h_half:x,0:h_half:y);
    [x_cfd,y_cfd,c_cfd]=griddata(uds_cfd(:,2),uds_cfd(:,3),uds_cfd(:,4),xq,yq);
    residual_new(i)=sum(sum((c_matlab(:,:,i)-c_cfd).^2))/sum(sum(c_cfd.^2));
    correlation_new(i) = corr2(c_matlab(:,:,i),c_cfd);
    clear c_cfd
end
%% 计算旧的马尔科夫方法计算结果的相关系数和平均绝对误差
cd ..\global_area_old_method\
load('c_matlab')
cd ..\airflow_field\
for i = 1:length(t_total)
    fid=fopen([num2str(t_total(i)) '.csv'],'r','n','UTF-8');
    uds_cfd=cell2mat(textscan(fid,'%f %f %f %f','Delimiter',',','HeaderLines',1));
    [xq,yq]=meshgrid(0:h_half:x,0:h_half:y);
    [x_cfd,y_cfd,c_cfd]=griddata(uds_cfd(:,2),uds_cfd(:,3),uds_cfd(:,4),xq,yq);
    residual_old(i)=sum(sum((c_matlab(:,:,i)-c_cfd).^2))/sum(sum(c_cfd.^2));
    correlation_old(i) = corr2(c_matlab(:,:,i),c_cfd);
    clear c_cfd
end
cd ..\CFD_cases\
save('residual_new','residual_new')
save('correlation_new','correlation_new')
save('residual_old','residual_old')
save('correlation_old','correlation_old')