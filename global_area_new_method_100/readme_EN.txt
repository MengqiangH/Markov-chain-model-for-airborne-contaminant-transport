~~main_routine.m in the folder is used to calculate the markov transition probability by the new method proposed in the paper.
~~myread.m is used to read the airflow field data, which should be in ASCII format.
     The airflow field data is exported by Fluent, and the data values at the node (including the boundaries and zones) is needed. The parameters include the x-coordinate,
     y-coordinate, velocity-magnitude, x-velocity, y-velocity, dx-velocity-dx, dy-velocity-dx, dx-velocity-dy, and dy-velocity-dy. Please make sure the order is the same as above.
     And select comma as the delimiter. Please make sure the airflow field file is similar to the fluent2d in the folder airflow_field.
~~mycase.m is used to calculate the total number of Markov state according to the specified airflow size and Markov state number and the airflow field. 
     Besides, it will estabilish estabilish the interpolation data set used for the calculation of velocity of specific point.
~~mysize.m is used to calculate the standard deviation of captured speed of a given number of Markov states. The detail meaning can be found in the paper titled 'Constructing Markov 
     matrices for real-time transient contaminant transport analysis for indoor environments'.
~~mystep.m is used to calculate the proportions of absorbed and neighbor state. The result will be exported to the file 's_std.csv'.
~~default.m is a script used to set the default value of input parameters, provided by Joe Eichholz. Joe Eichholz (2020). Set default values of input variables
     (https://www.mathworks.com/matlabcentral/fileexchange/59853-set-default-values-of-input-variables), MATLAB Central File Exchange. Retrieved February 25, 2020.
******************************************************************************************************************************************************************************************************************************
~~The User's Guide of main_routine.
     1. After the main routine runs, please input the path of the airflow field first. The format of the file can be found in the introduction of myread.m, after that, please press
        enter. The default path is ..\airflow_field\
     2. After that, please input the name of the airflow field field, and press enter. The default name is fluent2d
     3. After that, please input the length of the computional domain, which corresponds to the airflow field, and press enter. The default length is 9
     4. After that, please input the width of the computional domain, which corresponds to the airflow field, and press enter. The default width is 3
     5. After that, please input the number of Markov states (a sequence) and press enter. The default value is 5:5:200
     ......The script will automatically calculate the standard deviations of velocity for different amouts of Markov states, then compare them, and finally draw a figure.
     6. After that, please input the number of Markov states (a single value, depending on the last figure), and press enter. The default value is 30
     7. After that, please input the Markov time steps (a sequence, you can refer to the paper titled 'Constructing Markov matrices for real-time transient contaminant transport 
         analysis for indoor environments'), and press enter. The default sequence is 0.1087:0.05:10
     ......The script will automatically calculate the number of absorbed and neighbor state under different Markov time step, and finally draw a figure.
     8. After that, please input the Markov time step (a single value, depending on the last figure). The default size is 0.865
     9. After that, please input the number of particles per edge (a sequence, please note that the number of particles includes the vertices), and press enter. The default value is 2:100
     ......The script will automatically find the state with maximum deformation, and calculate the deviation of its area before and after the transport of airflow.
     10. After that, please input the number of particles per edge (a value, please note that the number of particles includes the vertices), and press enter. The default value is 25
     11. After that, please confirm whether there is an outlet in the domain, please input 1 if so, or 0 if not, and press enter. In this case, there is an outlet, therefore the default value is 1
     12. After that, please input the domain that represents the outside area. (The script model the outdoor area as a rectangle, please confirm that it can capture any air escaping from the
          airflow field.) The location of the vertices will be entered with a format of '[x y]', including the upper left vertice (the default value is [9 0.5]), the upper right vertice (the default value is
          [10 0.5]), the lower left vertice (the default value is [9 -0.5]), the lower right vertice (the default value is [10 -0.5]).
     ......The script will automatically calculate the State Transfer Probability by the new method (The defination of State Transfer Probability can be found in the paper titled 'Constructing Markov 
         matrices for real-time transient contaminant transport analysis for indoor environments').
     13. After that, please determine the initial contaminant concentration field, and if it is different from the default concentration field, you need to modify Line 285-291 in the script.
     14. After that, please input the calculation time, please use the non-dimensional time, which means the ratio of actual time and time step. It should be integer, and both single value and sequence
          are acceptable. The default value is 10:20:90
     ......The script will automatically calculate the contaminant concentration field at specific moment, and draw figures. These figures will be saved in the hardware and titled 'non-dimensional moment.png'
~~Please note that the script have suppressed all the warnings to make the command window concise. You can delete the warning('off','all') in the line 6 in the script to show warnings.