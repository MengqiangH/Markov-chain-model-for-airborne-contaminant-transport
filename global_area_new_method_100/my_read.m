function[Example] = my_read(path,file_name)
%ָ��·�����ļ���
file=dir([path,file_name]);
fid=fopen([path,file.name],'r','n','UTF-8');
%�����ݶ�ȡ��Example�У�Example�ļ�������node�����fluentģ�����ݣ������߽���ڲ��ռ䣩��
Example=cell2mat(textscan(fid,'%f %f %f %f %f %f %f %f %f %f','Delimiter',',','HeaderLines',1));
Example2=Example(:,2:(size(Example,2)));
clear Example
Example=Example2;
clear Example2
fclose(fid);
