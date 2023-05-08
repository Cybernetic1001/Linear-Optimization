function [x, optimal_cost, pivots] = tableau_simplex(A, b, c, enter_rule, leave_rule)
% Check if the LP is feasible
if any(b < 0)
    disp('The LP is infeasible.');
    x = [];
    optimal_cost = [];
    pivots = 0;
    return;
end

% Add slack variables to convert the LP to standard form
[m, n] = size(A);
A = [A eye(m)];
c = [c; zeros(m, 1)];

% Create the initial tableau
T = [A b; c' 0];

% Count the number of simplex pivots
pivots = 0;

% Set the maximum number of iterations
max_iterations = 1000000;
iterations = 0;

% Loop until an optimal solution is found or the LP is determined to be
% unbounded or max iterations has been reached. 
while true    
    % Check if the maximum number of iterations has been reached
    iterations = iterations + 1;
    if iterations > max_iterations
        disp('Maximum number of iterations reached.');
        x = [];
        optimal_cost = [];
        pivots = NaN;
        return;
    end
    
    % Determine the entering variable
    reduced_costs = T(end, 1:n);
    if strcmp(enter_rule, 'most_negative')
        entering_col = find(reduced_costs == min(reduced_costs), 1);
    elseif strcmp(enter_rule, 'smallest_index')
        entering_col = find(reduced_costs < 0, 1);
    end
    
    % If no entering variable is found, the solution is optimal
    if isempty(entering_col)
        x = T(1:m, end);
        optimal_cost = -T(end, end);
        pivots = pivots - 1; % Adjust the pivot count
        break;
    end
    
    % Determine the leaving variable
    ratios = T(1:m, end) ./ T(1:m, entering_col);
    candidate_rows = find(T(1:m, entering_col) > 0);
    if isempty(candidate_rows)
        disp('The LP is unbounded.');
        x = [];
        optimal_cost = [];
        pivots = NaN;
        return;
    end
    if strcmp(leave_rule, 'break_ties')
        [~, idx] = min(ratios(candidate_rows));
        leaving_row = candidate_rows(idx);
    elseif strcmp(leave_rule, 'lexicographic')
        [~, idx] = min(T(candidate_rows, entering_col));
        candidate_rows = candidate_rows(T(candidate_rows, entering_col) == T(candidate_rows(idx), entering_col));
        [~, idx] = min(T(candidate_rows, end) ./ T(candidate_rows, entering_col));
        leaving_row = candidate_rows(idx);
    end
    
    % Update the tableau
    pivot_element = T(leaving_row, entering_col);
    T(leaving_row, :) = T(leaving_row, :) / pivot_element;
    for i = 1:size(T, 1)
        if i ~= leaving_row
            T(i, :) = T(i, :) - T(i, entering_col) * T(leaving_row, :);
        end
    end
    
    % Increment the pivot count
    pivots = pivots + 1;
    
end

end
