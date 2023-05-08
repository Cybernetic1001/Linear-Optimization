% Number of products
n = randi([5, 10]);

% Number of machines
m = randi([5, 10]);

% Number of months
p = randi([1, 5]);

% Production time for each product on each machine
t = randi([1, 10], n, m);

% Available hours on each machine for each month
h = randi([1, 10], p, m);

% Unit cost and demand for each product in each month
c = randi([10, 100], n, p);
d = randi([10, 100], n, p);
