% Inputs for RSF function 
% Example LP
A = [ 2  1  1  0;  1  2  0  1 ];
b = [ 5; 7 ];
c = [ 2; 1; 0; 0 ];

% Add tic function to record the start time
tic();

% Run the revised simplex method with default options
[x, opt_val, num_pivots] = RSF(A, b, c, 'first_negative', 'break_ties_arbitrarily');

% Add toc function to calculate the elapsed time since the start of the process
toc();

% Display results
fprintf('Optimal solution:\n');
disp(x);
fprintf('Optimal value: %f\n', opt_val);
fprintf('Number of iterations: %d\n', num_pivots);
