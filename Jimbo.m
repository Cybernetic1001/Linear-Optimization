% Define the objective function coefficients
f = [];
for k = 1:p
    for i = 1:n
        f = [f c(i,k)*ones(1,m)];
    end
end

% Define the inequality constraints matrix A and vector b
A = sparse([], [], [], m*n*p, m*n+2*p*n, m*n*m);
b = [];

for k = 1:p
    for j = 1:m
        row = zeros(1,m*n+2*p*n);
        for i = 1:n
            row((j-1)*n+i) = t(i,j);
        end
        row(m*n+(k-1)*n+j) = 1;
        row(m*n+p*n+(k-1)*m+j) = 1;
        A((k-1)*m+j,:) = row;
        b = [b; h(k,j)];
    end
end

% Define the equality constraints matrix Aeq and vector beq
Aeq = zeros(n*p,n*m+2*p*n);
beq = zeros(n*p,1);
for k = 1:p
    for i = 1:n
        row1 = zeros(1,m*n+2*p*n);
        row2 = zeros(1,m*n+2*p*n);
        for j = 1:m
            row1((j-1)*n+i) = 1;
        end
        row1(m*n+(k-1)*n+i) = 1;
        row2(m*n+p*n+(k-1)*n+i) = 1;
        Aeq((k-1)*n+i,:) = row1;
        Aeq(n*p+(k-1)*n+i,:) = row2;
        beq((k-1)*n+i,:) = d(i,k);
    end
end

% Define the lower bounds and upper bounds for the decision variables
lb = zeros(1,m*n+2*p*n);
ub = [];

% Use linprog to solve the LP
[x,~,~,~,~] = linprog(-f,A,b,Aeq,beq,lb,ub);
