clear all
clc
%% Initialization

% This code is inspired from YouTube Channel: "The Kamal Institute"
% https://www.youtube.com/playlist?list=PLIAYlUlnK6-dZxzsq4CgtWpImn31gwwIK

syms X Y lambda
var = 2;                    % Number of variables on objective function
eps = 0.01;                 % Small probe length (\epsilon)
x = [2;-2];                 % Starting point

% Generate objective function
f = symfun(X - Y + 2*X^2 + 2*X*Y + Y^2, [X Y]);     % 1 Method
% f = inline(X - Y + 2*X^2 + 2*X*Y + Y^2)           % 2 Method
% f = @(X,Y) X - Y + 2*X^2 + 2*X*Y + Y^2            % 3 Method

% Direction sk/dk
S = eye(var);

%% Looping

for i = 1:20    
    x_temp = x(:,i);                % Locate the dynamic x (changes)
    % How to differ even and odd in step (2)
    if mod(i,2) == 1    % Odd
        s = S(:,1);
    else                % Even
        s = S(:,2);
    end
    
    % Compute f in step (3)
    fval = f(x_temp(1), x_temp(2));

    % Compute f_positive and f_negative to compare with f
    xp_temp = x_temp + eps*s;       % p means positive
    xn_temp = x_temp - eps*s;       % n means negative
    fval_p = f(xp_temp(1), xp_temp(2));
    fval_n = f(xn_temp(1), xn_temp(2));
    
    % Condition for s_positive or s_negative
    if fval_p < fval
        s = s;                      % Correct direction
    elseif fval_n < fval
        s = -s;                     % Opposite direction
    else
        break                       % Indicate fval < [fval_p & fval_n]
    end
    
    % Compute optimal length in step (4)
    xopt_temp = x_temp + lambda*s;
    fval_opt = f(xopt_temp(1), xopt_temp(2));
    % Compute gradient
    grad_fopt = gradient(fval_opt);
    % Solving \lambda optimum
    lambda_opt = solve(grad_fopt);
    % Update x(k+1) in step (5) and store
    x(:,i+1) = x_temp + lambda_opt*s;
end

%% Plotting x

axis square
X = linspace(-2.5,2.5);             Y = linspace(-2.5,2.5);
[A,B] = meshgrid(X,Y);
f_fig = f(A,B);
levels = 10:10:350;
figure(1), contour(X,Y,f_fig,levels,'linewidth',1.2), colorbar
hold on;
plot(x(1,:), x(2,:))
