%%% Make A matrix
A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8), default_bin(:,1:2), ...
    housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
    day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
    consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];

%%% Initialization
v = 0.01;
m = size(A, 1);
n = size(A, 2);
one = 1;

%%% Linear program form
DA = D*A;
De = D*e;

AA = [-DA     De           -eye(m)    zeros(m,n);...
       eye(n) zeros(n,one) zeros(n,m) -eye(n);...
      -eye(n) zeros(n,one) zeros(n,m) -eye(n)];
  
%B = randi(100,size(AA,2));
%B = diag(diag(B));
%AA = AA * B';
  
bb = [-ones(m,one);...
       zeros(n,one);...
       zeros(n,one)];   
   
cc = [zeros(one, n) zeros(one,one) v*ones(one,m) ones(one,n)];

%cc = cc * B';

%%% Lower bound
lb = zeros(2*n+m+one,one);
lb(1:n+one) = -Inf;

%%% Optimization
%options = optimoptions('linprog','Algorithm','interior-point-legacy','Display','iter');
LP = linprog(cc, AA, bb,[],[],lb,[]);

%%% Coefficients
w = LP(1:n);
gamma = LP(n+1)
y = LP(n+2:n+one+m);
t = LP(n+one+m+1:end);