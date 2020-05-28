function[Example] = my_read(path,file_name)
%指定路径与文件名
file=dir([path,file_name]);
fid=fopen([path,file.name],'r','n','UTF-8');
%将数据读取到Example中，Example文件里是以node输出的fluent模拟数据（包括边界和内部空间）。
Example=cell2mat(textscan(fid,'%f %f %f %f %f %f %f %f %f %f','Delimiter',',','HeaderLines',1));
Example2=Example(:,2:(size(Example,2)));
clear Example
Example=Example2;
clear Example2
fclose(fid);
