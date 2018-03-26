%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make A matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8), default_bin(:,1:2), ...
     housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
      day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
      consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
 %A = rand(4119,53);
 
 v = 0.07;
 m = size(A, 1);
 n = size(A, 2);
 one = 1;
 
 DA = D*A;
 De = D*e;
 AA = [-DA      De         -eye(m)       zeros(m,n);...
       eye(n) zeros(n,one) zeros(n,m)   -eye(n);...
       -eye(n) zeros(n,one) zeros(n,m) -eye(n)];
   
 bb = [-ones(m,one);...
       zeros(n,one);...
       zeros(n,one)];
   
cc = [zeros(one, n) zeros(one,one) v*ones(one,m) ones(one,n)];

lb = zeros(2*n+m+one,one);
lb(n+one) = -Inf;

LP = linprog(cc, AA, bb,[],[],lb,[]);
w = LP(1:n);
gamma = LP(n+1)
y = LP(n+2:n+one+m);
t = LP(n+one+m+1:end);