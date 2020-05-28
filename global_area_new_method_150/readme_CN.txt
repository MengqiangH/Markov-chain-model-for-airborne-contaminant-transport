文件夹中的主程序用来针对参考模型，使用所提出新方法计算状态转移概率。
~~myread.m用于读取底层流场数据，底层流场应该是ASCII格式的，
     流场由FLUENT文件输出，输出格式为node，并包括边界和内部空间，
     输出的参数包括：x-coordinate，y-coordinate，velocity-magnitude，x-velocity，
     y-velocity,dx-velocity-dx,dy-velocity-dx,dx-velocity-dy,dy-velocity-dy。请确认以上述
     顺序输出。文件的分隔符为'，'。请确定输出的文件与airflow_field文件夹中的fluent2d是相同的。
~~mycase.m用于根据指定的流场尺寸、马尔科夫状态数量、底层流场，计算总的马尔科夫状态数量，并
     建立底层流场的插值数据集，用于后期查询特定点的流场参数。
~~mysize.m用于计算在特定的马尔科夫状态数量下，所捕获的速度的标准偏差。具体含义请参考论文
     《Constructing Markov matrices for real-time transient contaminant transport analysis for
     indoor environments》。
~~mystep.m用于计算在当前马尔科夫时间步长下，马尔科夫状态是吸收状态或相邻状态的比例，最终数据以.csv格式
     输出到文件s_std.csv中
~~default.m是一个用于设置输入参数的初始值的脚本，由Joe Eichholz提供，Joe Eichholz (2020). 
     Set default values of input variables (https://www.mathworks.com/matlabcentral/fileexchange/
     59853-set-default-values-of-input-variables), MATLAB Central File Exchange. Retrieved February 25, 2020.
~~主程序使用说明
     1.在主程序运行后，要求首先输入底层流场文件路径，文件格式参见myread.m脚本的说明，输入路径（请以\结尾）
        后，请轻按回车。默认路径为..\airflow_field\
     2.之后要求输入底层流场文件名，请轻按回车。默认文件名为fluent2d
     3.之后要求输入矩形计算域长度（请与底层流场对应），请轻按回车。默认长度为9
     4.之后要求输入矩形计算域宽度（请与底层流场对应），请轻按回车。默认宽度为3
     5.之后要求输入马尔科夫状态数量（请输入数列），请轻按回车。默认数量为5:5:200
     ......程序将自动计算不同马尔科夫状态数量下的速度标准偏差，之后对比相邻状态并计算出偏差，作图。
     6.之后要求输入马尔科夫状态数量（单一数值，根据前面生成的图取值），请轻按回车。默认数量为30
     7.之后要求输入马尔科夫时间步长数列（请输入数列，建议范围根据论文《Constructing Markov matrices 
        for real-time transient contaminant transport analysis for indoor environments》确定），请轻按回车。
        默认数列为0.1087:0.05:10
     ......程序将自动计算不同马尔科夫时间步长下的吸收状态和相邻状态数量，并作图。
     8.之后要求输入马尔科夫时间步长（单一数值，根据前面生成的图取值），请轻按回车。默认步长为0.865
     9.之后要求输入每条边界的粒子数（请输入数列，注意，粒子数量包括顶点在内），请轻按回车。默认数量为2:100
     ......程序将自动计算变形最大的状态，并计算不同粒子数下，状态变化前后的面积偏差。
     10.之后要求确定后的边界粒子数（请输入数值，注意，粒子数量包括顶点在内），请轻按回车。默认数量为25
     11.之后要求输入计算域是否有出口，如果有请输入1，否则请输入0，请轻按回车。本案例中有出口，因此默认为1
     12.之后要求输入代表外界区域的范围（本程序将外界区域建模为矩形，请确保所采用的矩形可以收纳所有从流场内逃逸的
          空气），将先后输入四个节点的位置，请以‘[x y]’的格式输入，包括左上节点的位置（默认为[9 0.5]），右上节点的
          位置（默认为[10 0.5]），左下节点的位置（默认为[9 -0.5]），右下节点的位置（默认为[10 -0.5]）。
     ......程序将自动计算马尔科夫状态转移概率（状态转移概率的概念请参考论文《Constructing Markov 
         matrices for real-time transient contaminant transport analysis for indoor environments》）。
     13.之后要求确定初始污染物浓度场，如果与默认浓度场不同，则需要更改主程序第285-291行代码。
     14.之后要求输入要计算时刻，请输入无量纲时间，即真实时间与时间步长的比值，请输入整数（单一数值或数列）。默认
         值为10:20:90
     ......程序将自动计算指定时刻的污染物浓度分布，并作图，图片将以'无量纲时刻.png'为文件名保存在硬盘中。
~~备注
     为了方便使用，程序屏蔽了matlab的警告，若想显示，可删除主程序main_routine.m中第6行的warning('off','all')