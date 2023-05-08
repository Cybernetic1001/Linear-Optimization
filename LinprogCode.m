%This is the Matlab formulation using Linprog 
A = [ 2  1  1  0;  1  2  0  1 ];
b = [ 5; 7 ];
c = [ 2; 1; 0; 0 ]';             
    Ae=[]; 
    be=[];
    lb=[0 0];
    ub=[inf inf];
    [x,z]=linprog(c,A,b,Ae,be,lb,ub);
    ShowSolution(x,z);