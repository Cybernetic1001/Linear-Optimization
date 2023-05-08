A = [1 1; 1 -1];
b = [2; 1];
c = [-1; -2];
enter_rule = 'most_negative';
leave_rule = 'break_ties';

tic();
[x, optimal_cost, pivots] = tableau_simplex(A, b, c, enter_rule, leave_rule);
toc(); 
disp("Optimal solution:");
disp(x);
disp("Optimal cost:");
disp(optimal_cost);
disp("Number of pivots:");
disp(pivots);
