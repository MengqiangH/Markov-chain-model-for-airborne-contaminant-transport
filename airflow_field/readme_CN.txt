文件夹中是底层流场数据以及使用fluent程序对污染物浓度场进行标量输运模拟得到的结果
~~2D_airflow.cas/2D_airflow.dat是本研究中流场模拟结果。
~~fluent2d是本研究中流场的模拟结果，由FLUENT文件输出，输出格式为node，并包括边界和内部空间，输出的参数包括：
     x-coordinate，y-coordinate，velocity-magnitude，x-velocity，y-velocity，dx-velocity-dx，dy-velocity-dx，dx-velocity-dy，
     dy-velocity-dy。文件的分隔符为'，'。
~~10.cas/10.dat到90.cas/90.dat是本研究中的计算时刻的标量输运模拟结果，而10.csv到90.csv，及initial.csv则是以ASCII格式输出的
     污染物浓度场数据，输出格式为node，包括边界和内部空间，输出的参数包括：x-coordinate，y-coordinate，Scalar-0。文件分隔符为‘，’。
