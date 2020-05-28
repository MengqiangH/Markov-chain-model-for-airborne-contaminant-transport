The files in this folder are the airflow field data and the contaminant concentration results calculated by Fluent.
~~2D_airflow.cas/2D_airflow.dat are the airflow field results in this research.
~~fluent2d is the airflow field data is exported by Fluent, and the data values at the node (including the 
     boundaries and zones) is needed. The parameters include the x-coordinate, y-coordinate, velocity-magnitude,
     x-velocity, y-velocity, dx-velocity-dx, dy-velocity-dx, dx-velocity-dy, and dy-velocity-dy. And select comma as the delimiter.
~~10.cas/10.dat to 90.cas/90.dat are the contaminant concentration field calculated by scalar transport in Fluent. 10.csv to 90.csv
     and initial.csv are the contaminant concentration field exported by Fluent, and the data values at the node (including the 
     boundaries and zones) is needed. The parameters include the  x-coordinate, y-coordinate, and Scalar-0. The comma was selected as the delimiter.