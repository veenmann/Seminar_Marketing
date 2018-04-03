%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make A matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8), default_bin(:,1:2), ...
     %housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
      %day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
      %consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
  %A = [age, duration, campaign, pdays, previous,...
      %consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
 %A = rand(4119,53);
 
 D = diag(e);
 
 v = 0.07;
 m = size(A, 1);
 n = size(A, 2);
 one = 1;
 
 DA = D*A;
 De = D*e;
 
 Zero_n = zeros(n,one);
 Zero_m = zeros(m,n);
 Zero_n_m = zeros(n,m);
 I_m = -eye(m);
 I_n = eye(n);
 AA = [-DA      De         I_m    Zero_m;...
        I_n   Zero_n    Zero_n_m    -I_n;...
       -I_n   Zero_n    Zero_n_m   -I_n];
 B = randi(100,size(AA,2));
 B = diag(diag(B));
 %B = rand(size(AA,1),size(AA,2));
 AA = AA*B';
 
 bb = [-ones(m,one);...
       zeros(n,one);...
       zeros(n,one)];   
   
cc = [zeros(one, n) zeros(one,one) v*ones(one,m) ones(one,n)];
cc = cc * B';

lb = zeros(2*n+m+one,one);
lb(1:n+one) = -Inf;

options = optimoptions('linprog','Algorithm','interior-point-legacy','Display','iter')
[LP,f,exitflag,out,lambda] = linprog(cc, AA, bb,[],[],lb,[],options);
w = LP(1:n);
gamma = LP(n+1)
y = LP(n+2:n+one+m);
t = LP(n+one+m+1:end);