function [x, f, w, gamma, y, t] = Formulation_nr_1(A, e)
% FORMULATION_NR_1 Linear Programming SVM training models for 4 different cases.
% [x, f, w, gamma, y, t] = Formulation_nr_1(A, e)
% Inputs: 
%   A       Data matrix
%   e       Labels {1 and -1} vector
% Outputs:
%   x       Coefficients vector
%   f       Optimal cost value
%   w       Coefficients vector
%   gamma   Data separation hyperplane
%   y       Coefficients vector
%   t       Coeficients vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 % CASE = 0         Original problem
 % CASE = 1         x = B'u
 % CASE = 2         A --> AB', w --> p, t --> q
 % CASE = 3         Permutation
 
   CASE = 0;        % <--- CHANGE THIS ONE
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 % Dimensions
 m = size(A, 1);
 n = size(A, 2);
 one = 1;
 
 % Parameters
 v = 0.07;
 k = n+one+m+n;        % k >= number of columns of AA
  
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
 Zero_k_k = zeros(k,k);
 Zero_n_n = zeros(n);
 One_m_1  = ones(m, one);
 One_n_1  = ones(n, one);
 One_k_1  = ones(k, one);
 I_m = eye(m);
 I_n = eye(n);
 I_k = eye(k);
 
 %%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if CASE == 0
 %%%%%%%%%%%%%%%%%%%%%%%%% ORIGINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %     min   v*e'*y + e'*t
 %     s.t. -D*A*w + D*e*gamma - y <= -1
 %           w - t <= 0
 %          -w - t <= 0
 %           y >= 0
 %           t >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     AA = [-DA          De         -I_m     Zero_m_n;...
            I_n     Zero_n_1    Zero_n_m    -I_n; ...
           -I_n     Zero_n_1    Zero_n_m    -I_n; ...
         Zero_m_n   Zero_m_1      -I_m     Zero_m_n; ...
         Zero_n_n   Zero_n_1    Zero_n_m    -I_n];
  
     bb = [-One_m_1; ...
            Zero_n_1; ...
            Zero_n_1; ...
            Zero_m_1; ...
            Zero_n_1];
 
     cc = [Zero_n_1;...
           Zero_1_1;...
           v * One_m_1;...
           One_n_1];
 
     options = optimoptions('linprog','Algorithm','interior-point-legacy','Display','iter');
     [x,f,~,~,~] = linprog(cc, AA, bb,[],[],[],[],options);
     w = x(1:n);
     gamma = x(n+1);
     y = x(n+2:n+one+m);
     t = x(n+one+m+1:end);

 elseif CASE == 1     
 %%%%%%%%%%%%%%%%%%%%% x = B'u %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % 
 %      min     v*e'*B_y'*u + e'*B_t'*u
 %      s.t.   -D*A*B_w'*u + D*e*B_gamma'*u - B_y'*u <= -1
 %              B_w'*u - B_t'*u <= 0
 %             -B_w'*u - B_t'*u <= 0
 %              B_y'*u >= 0
 %              B_t'*u >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     AA = [-DA          De         -I_m     Zero_m_n;...
            I_n     Zero_n_1    Zero_n_m    -I_n; ...
           -I_n     Zero_n_1    Zero_n_m    -I_n; ...
         Zero_m_n   Zero_m_1      -I_m     Zero_m_n; ...
         Zero_n_n   Zero_n_1    Zero_n_m    -I_n];

     bb = [-One_m_1; ...
            Zero_n_1; ...
            Zero_n_1; ...
            Zero_m_1; ...
            Zero_n_1];
           
     cc = [Zero_n_1; 
           Zero_1_1; ...
           v * One_m_1; ...
           Zero_n_1];
       
     n_new = size(AA, 2);
     
     B = randi(10, n_new, n_new);
     AA = AA * B';
     cc_true = cc;
     cc = B * cc;
 
     options = optimoptions('linprog','Algorithm','interior-point-legacy','Display','iter'); 
     [u,f,~,~,~] = linprog(cc, AA, bb, [], [], [], [], options);
  
     %%% Finding private coefficients
     try
        x = B' * u;
        w = x(1:n);
        gamma = x(n+1);
        y = x(n+2:n+one+m);
        t = x(n+one+m+1:end);
        f = cc_true'*x;         % true cost
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
     
elseif CASE == 2
 %%%%%%%%%%%%%%% A --> AB', w --> p, t --> q %%%%%%%%%%%%%%%%%
 % 
 %       min    v*e'*y + e'*q
 %       s.t.  -D*A*B'*p + D*e*gamma - y <= -1
 %              P - q <= 0
 %             -p - q <= 0
 %              y >= 0
 %              q >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     B = randi(100, k, n);
     DAB = (DA*B')';
     
     AA = [-DAB'          De         -I_m     Zero_m_k;...
            I_k     Zero_k_1    Zero_k_m    -I_k; ...
           -I_k     Zero_k_1    Zero_k_m    -I_k; ...
         Zero_m_k   Zero_m_1      -I_m     Zero_m_k; ...
         Zero_k_k   Zero_k_1    Zero_k_m    -I_k];

  
     bb = [-One_m_1; ...
            Zero_k_1; ...
            Zero_k_1; ...
            Zero_m_1; ...
            Zero_k_1]; 
 
     cc = [Zero_k_1;...
           Zero_1_1;...
           v * One_m_1;...
           One_k_1];

     options = optimoptions('linprog','Algorithm','interior-point-legacy','Display','iter');
     [u,f,~,~,~] = linprog(cc, AA, bb,[],[],[],[],options);
     p = u(1:k);
     gamma = u(k+1);
     y = u(k+2:k+one+m);
     q = u(k+one+m+1:end);
     % Since function has outputs:
     x = u;
     w = p;
     t = q;
     %%% Finding private coefficients
      % IMPOSSIBLE
  
 elseif CASE == 3
 %%%%%%%%%%%%%%%%%%%%% x = B'u %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % 
 %      min     v*e'*B_y'*u + e'*B_t'*u
 %      s.t.   -D*A*B_w'*u + D*e*B_gamma'*u - B_y'*u <= -1
 %              P1*B_w'*u - P1*B_y'*u <= 0
 %             -P2*B_w'*u - P2*B_y'*u <= 0
 %              P3*B_y'*u >= 0
 %              P4*B_t'*u >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P1 = eye(n);
        P1 = P1(randperm(n),:);
    P2 = eye(n);
        P2 = P2(randperm(n),:);
    P3 = eye(m);
        P3 = P3(randperm(m),:);
    P4 = eye(n);
        P4 = P4(randperm(n),:);
 
    AA = [-DA          De         -I_m     Zero_m_n;...
            P1*I_n     Zero_n_1    Zero_n_m    -P1*I_n; ...
           -P2*I_n     Zero_n_1    Zero_n_m    -P2*I_n; ...
         Zero_m_n   Zero_m_1      -P3*I_m     Zero_m_n; ...
         Zero_n_n   Zero_n_1    Zero_n_m    -P4*I_n];

     bb = [-One_m_1; ...
           Zero_n_1; ...
           Zero_n_1; ...
           Zero_m_1; ...
           Zero_n_1];

    cc = [Zero_n_1; ...
          Zero_1_1; ...
          v * One_m_1; ...
          One_n_1];
      
    n_new = size(AA, 2);

    B = randi(10, n_new, n_new);
    AA = AA * B';
    cc_true = cc;
    cc = B * cc;

    
    options = optimoptions('linprog','Algorithm','interior-point-legacy','Display','iter', 'MaxIterations', 1500);
    [u,f,~,~,~] = linprog(cc, AA, bb, [], [], [], [], options);
     
     %%% Finding private coefficients
     try
        x = B' * u;
        w = x(1:n);
        gamma = x(n+1);
        y = x(n+2:n+one+m);
        t = x(n+one+m+1:end);
        f = cc_true'*x;         % true cost
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
 end