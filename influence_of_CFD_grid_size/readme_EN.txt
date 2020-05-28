The main routine in this folder has two functions, the first one is to draw contours with the contaminant concentration field exported by Fluent.
The second is to calculate the bias and correlation of Markov method (both the old and new) and scalar tranport method.
~~Please note that there is no inputs in the script, and the script should be run after the finish of main routines in the folder 'global_area_old_method' and
    'global_area_new_method'.
    The mean absolute error of the new markov method is saved in 'residual_new' and the correlation coefficient is saved in 'correlation_new' while those values
    of the old markov method are stored in 'residual_old' and 'correlation_old', respectively.
~~~~Please note that the script have suppressed all the warnings to make the command window concise. You can delete the warning('off','all') in the line 5 in the script to show warnings.