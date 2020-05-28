function default(varname,value,count_empty)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Give a variable a default value.  If the variable varname does not exist,
%or it is empty, then the variable varname is created and set to the value
%in value, in the workspace of the calling function. 
%Usage:
%varname - the NAME of the value which should recieve a default value. 
%value   - The default value
%count_empty - whether or not varname should be defaulted if it is empty.
%this defaults to 1 (go ahead and default if empty). 
%
%Example
%Give the variable foo the value of 1 if it doesn't exist or if it is empty
%>> default('foo',1);
%
%Example
%Give the variable foo the value of 1 if it doesn't exist, do nothing if it
%is empty. 
%>> default('foo',1,0);


    if ~exist('count_empty','var') || isempty(count_empty)
        count_empty=1;
    end

    %check to see if varname exists in caller
    varexist=evalin('caller',['exist(''' varname ''',''var'')']);
    
    makedefault=0;
    if ~varexist
        makedefault=1;
    else
        varisempty=evalin('caller',['isempty(' varname ')']);
        if varisempty && count_empty
            makedefault=1;
        end
    end
    
    if makedefault
        assignin('caller',varname,value);
    end