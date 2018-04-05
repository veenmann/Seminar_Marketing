 A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8),default_bin(:,1:2), ...
     housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
     day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
     consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
%   A = [age, duration, campaign, pdays, previous,...
%       consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
 
 % CASE = 0         Original problem
 % CASE = 1         A --> AB', w --> p, t --> q
 % CASE = 2         x = B'u
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 % Parameters
 v = 0.07;
 k = 400;          % k >= number of columns of AA
 
 % Dimentions
 m = size(A, 1);
 n = size(A, 2);
 one = 1;
 
 % Block matrices
 D = diag(e);
 DA = D*A;
 De = D*e;
 Zero_n_1 = zeros(n,one);
 Zero_m_1 = zeros(m, one);
 Zero_1_1 = zeros(one,one);
 Zero_m_n = zeros(m, n);
 Zero_n_m = zeros(n, m);
 Zero_m_k = zeros(m, k);
 Zero_k_m = zeros(k, m);
 Zero_k_1 = zeros(k, 1);
 Zero_m_m = zeros(m);
 Zero_n_n = zeros(n);
 One_m_1  = ones(m, one);
 One_n_1  = ones(n, one);
 One_k_1  = ones(k, one);
 I_m = eye(m);
 I_n = eye(n);
 I_k = eye(k); 

%%%%%%%%%%%%%%%%%%%%% x = B'u %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % 
 %      min     v*e'*B_y'*u + e'*B_t'*u
 %      s.t.   -D*A*B_w'*u + D*e*B_gamma'*u + B_y'*u <= -1
 %              B_w'*u - B_y'*u <= 0
 %             -B_w'*u - B_y'*u <= 0
 %              B_y'*u >= 0
 %              B_t'*u >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     AA = [-DA          De         I_m     Zero_m_n;...
            I_n     Zero_n_1    Zero_n_m    -I_n; ...
           -I_n     Zero_n_1    Zero_n_m    -I_n; ...
         Zero_m_n   Zero_m_1      -I_m     Zero_m_n; ...
         Zero_n_n   Zero_n_1    Zero_n_m    -I_n];

     bb = [-One_m_1; ...
            Zero_n_1; ...
            Zero_n_1; ...
            Zero_m_1; ...
            Zero_n_1];
        
     cc = [Zero_n_1; ...
           Zero_1_1; ...
           v * One_m_1; ...
           One_n_1];
      
     %m_new = size(AA, 1);
     %n_new = size(AA, 2);
     
     %B = randi(10, k, n_new);
     %%%%%%%%%%%%%%%%%%%
     %B = randi(10, n_new);
     %B = diag(diag(B));
     %%%%%%%%%%%%%%%%%%%
     %AA = AA * B';
     %cc = B * cc;
  
     [u,f,exitflag,out,lambda] = linprog(cc, AA, bb);
  
     %%% Finding private coefficients
%      try
%         x = B' * u;
%         w = x(1:n);
%         gamma = x(n+1);
%         y = x(n+2:n+one+m);
%         t = x(n+one+m+1:end);
%      catch
%         fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
%      end