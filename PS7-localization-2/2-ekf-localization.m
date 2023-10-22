f = @(x, u) x + u;
Fx = @(x,u) eye(2);
Fu = @(x,u) eye(2);

%%% SECTION FOR SELF-EVALUATION. PLEASE DO NOT EDIT BELOW THIS LINE %%%

x = [1;2]
u = [3;4]

f_eval = f(x,u)
Fx_eval = Fx(x,u)
Fu_eval = Fu(x,u)

%% ------------------------------ %%
% PART 2 - Measurement model

h = @(m, x_prior) m - x_prior;
Hx = @(m, x_prior) -eye(2);

%% SECTION FOR SELF-EVALUATION. PLEASE DO NOT EDIT BELOW THIS LINE %%%

x_prior = [1;2]
m = [3;3]

h_eval = h(m,x_prior)
Hx_eval = Hx(m,x_prior)

%% ------------------------------ %%
% PART 3 - Uncertainty propagation

P_prior = @(Fx,Fu,P,Q) ...
     Fx * P * Fx' + Fu * Q * Fu';

%% SECTION FOR SELF-EVALUATION. PLEASE DO NOT EDIT BELOW THIS LINE %%%

Fx = [2 1;1 2]
Fu = [2 1;1 2]
P = [1 0;0 1]
Q = [.5 0;0 .5]

P_prior_eval = P_prior(Fx,Fu,P,Q)

%% ------------------------------ %%
% PART 4 - Update step

y = @(z, h) z - h;
S = @(Hx, P_prior, R) Hx * P_prior * Hx' + R;
K = @(Hx, P_prior, S) P_prior * Hx' / S;
x_posterior = @(x_prior, K, y) x_prior + K * y;
P_posterior = @(Hx, P_prior, K) P_prior - P_prior * Hx' * K';

%%% SECTION FOR SELF-EVALUATION. PLEASE DO NOT EDIT BELOW THIS LINE %%%

z = [1.1;1.9]
h = [1;2]
Hx = [2 1;1 2]
P_prior = [1 0;0 1]
R = [.5 0; 0 .5]
x_prior = [1;2]

y_eval = y(z,h)
S_eval = S(Hx, P_prior, R)
K_eval = K(Hx, P_prior, S_eval)
x_posterior_eval = x_posterior(x_prior, K_eval, y_eval)
P_posterior_eval = P_posterior(Hx, P_prior, K_eval)

%% ------------------------------ %%
% PART 5 - Simulating Your EKF Localization

% all previously implemented anonymous functions go here
%motion model and Jacobians
f = @(x, u) x + u;
Fx = @(x,u) eye(2);
Fu = @(x,u) eye(2);

%measurement model and Jacobian
h = @(m, x_prior) m - x_prior;
Hx = @(m, x_prior) -eye(2);

%covariance propagation
P_prior = @(Fx, Fu, P, Q) Fx * P * Fx' + Fu * Q * Fu';

%estimate update
y = @(z, h) z - h;
S = @(Hx, P_prior, R) Hx * P_prior * Hx' + R;
K = @(Hx, P_prior, S) P_prior * Hx' / S;
x_posterior = @(x_prior, K, y) x_prior + K * y;
P_posterior = @(Hx, P_prior, K) P_prior - P_prior * Hx' * K';

plotEKFLocalization(f, Fx, Fu, h, Hx, P_prior, y, S, K, x_posterior, P_posterior);