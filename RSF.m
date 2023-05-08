function [x, opt_val, num_pivots] = RSF(A, b, c, varargin)
% This function solves a linear program in standard form using the revised
% simplex method. It takes as input the constraint matrix A, the right
% hand-side vector b, the cost vector c, and optional arguments for the
% entering and leaving variable rules. It returns the optimal solution
% vector x, the optimal cost, and the number of simplex pivots used.

% Set default rules
entering_rule = 'most_negative';
leaving_rule = 'break_ties_arbitrarily';

% Parse optional arguments
if nargin > 3
    entering_rule = varargin{1};
end
if nargin > 4
    leaving_rule = varargin{2};
end

% Initialize variables
[m, n] = size(A);
B = 1:m;
N = m+1:n;
x_B = b;
x_N = zeros(n-m,1);
c_B = c(B);
c_N = c(N);
num_pivots = 0;

% Check if the initial feasible solution is infeasible
if any(x_B < 0)
    error('LP is infeasible');
end

while true
    % Step 1 - compute reduced costs
    reduced_costs = c_N' - c_B' * A(:,N);
    
    % Check for optimality
    if all(reduced_costs >= 0)
        x = zeros(n, 1);
        x(B) = x_B;
        x(N) = x_N;
        opt_val = c' * x;
        return
    end
    
    % Step 2 - choose entering variable
    if strcmp(entering_rule, 'most_negative')
        [~, enter_idx] = min(reduced_costs);
    elseif strcmp(entering_rule, 'first_negative')
        enter_idx = find(reduced_costs < 0, 1);
    else
        error('Invalid entering rule');
    end
    enter_var = N(enter_idx);
    
    % Step 3 - compute minimum ratios
    ratios = x_B ./ A(:,B(enter_idx)); %elements of the ratio vectors
    
    % Check for unboundedness
    if all(ratios <= 0)
        error('LP is unbounded');
    end
    
    % Step 4 - choose leaving variable
    if strcmp(leaving_rule, 'break_ties_arbitrarily')
        leave_idx = find(ratios == min(ratios(ratios > 0)), 1);
    elseif strcmp(leaving_rule, 'smallest_index')
        [~, leave_idx] = min(B(ratios > 0));
    else
        error('Invalid leaving rule');
    end
    leave_var = B(leave_idx);
    
    % Step 5 - update basis
    B(leave_idx) = enter_var;
    N(enter_idx) = leave_var;
    x_B = x_B - ratios(leave_idx) * A(:,enter_var);
    x_N(enter_idx) = ratios(leave_idx);
    c_B = c(B);
    c_N = c(N);
    num_pivots = num_pivots + 1;
end
end
