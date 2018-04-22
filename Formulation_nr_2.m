function [a, b, y, f, x, t] = Formulation_nr_2(V, s, ATTEMPT)
% FORMULATION_NR_2 Linear Programming SVM training models for 4 
% different cases.
% [a, b, y, f, x, t] = Formulation_nr_2(A, e)
% Inputs: 
%   V          Data matrix
%   s          Labels {1 and -1} vector
%   ATTEMPT    0 Original problem
%              1 x = B'w
%              2 Only V random
%              3 Permutation
% Outputs:
%   x          Coefficients vector
%   f          Optimal cost value
%   a          Coefficients vector
%   b          Data separation hyperplane
%   y          Coefficients vector
%   t          Coeficients vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 % Dimensions
 m = size(V, 1);
 n = size(V, 2);
 one = 1;
 
 % Parameters
 g = 0.07;
 k = n+one+m+n;        % k >= number of columns of AA
  
 % Block matrices
 O_n_1 = zeros(n,one);
 O_m_1 = zeros(m, one);
 O_1_1 = zeros(one,one);
 O_m_n = zeros(m, n);
 O_n_m = zeros(n, m);
 O_m_k = zeros(m, k);
 O_k_m = zeros(k, m);
 O_k_1 = zeros(k, 1);
 O_k_k = zeros(k,k);
 O_n_n = zeros(n);
 One_m_1  = ones(m, one);
 One_n_1  = ones(n, one);
 One_k_1  = ones(k, one);
 I_m = eye(m);
 I_n = eye(n);
 I_k = eye(k);
 D = diag(s);
 DV = D*V;
 De = D*One_m_1;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 if ATTEMPT == 0
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ORIGINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %     min   g*e'*y + e'*t
 %     s.t. -D*V*a + D*e*b - y <= -1
 %                       w - t <= 0
 %                      -w - t <= 0
 %                           y >= 0
 %                           t >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     E = [ -DV      De       -I_m     O_m_n;...
            I_n    O_n_1    O_n_m      -I_n; ...
           -I_n    O_n_1    O_n_m      -I_n; ...
           O_m_n   O_m_1     -I_m     O_m_n; ...
           O_n_n   O_n_1    O_n_m      -I_n];
  
     upperbound = [-One_m_1; ...
                    O_n_1; ...
                    O_n_1; ...
                    O_m_1; ...
                    O_n_1];
 
     c = [O_n_1;...
          O_1_1;...
          g * One_m_1;...
          One_n_1];
       
     options = optimoptions('linprog','Algorithm','interior-point-legacy',...
                            'Display','iter', 'MaxIterations', 150000);
     [x,f,~,~,~] = linprog(c, E, upperbound,[],[],[],[],options);
        
     %%% Finding private coefficients
        try
           a = x(1:n);
           b = x(n+1);
           y = x(n+2:n+one+m);
           t = x(n+one+m+1:end);
         catch
           fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
        end

 elseif ATTEMPT == 1     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% x = B'w %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % 
 %      min     g*e'*B_y'*w + e'*B_t'*w
 %      s.t.   -D*V*B_a'*w + D*e*B_b'*w - B_y'*w <= -1
 %                               B_a'*w - B_t'*w <= 0
 %                               B_a'*w - B_t'*w <= 0
 %                                        B_y'*w >= 0
 %                                        B_t'*w >= 0
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     E = [ -DV     De       -I_m     O_m_n;...
            I_n   O_n_1    O_n_m      -I_n; ...
           -I_n   O_n_1    O_n_m      -I_n; ...
          O_m_n   O_m_1     -I_m     O_m_n; ...
          O_n_n   O_n_1    O_n_m      -I_n];

     upperbound = [-One_m_1; ...
                    O_n_1; ...
                    O_n_1; ...
                    O_m_1; ...
                    O_n_1];
           
     c = [O_n_1; 
          O_1_1; ...
          g * One_m_1; ...
          One_n_1];
       
     B = randi(10, size(E, 2));
     
     EE = E*B';
     cc_true = c;
     cc = B*c;
 
     options = optimoptions('linprog','Algorithm','dual-simplex',...
                            'Display','iter', 'MaxIterations', 150000);
     [w,f,~,~,~] = linprog(cc, EE, upperbound, [], [], [], [], options);
  
     %%% Finding private coefficients
     try
        x = B'*w;
        a = x(1:n);
        b = x(n+1);
        y = x(n+2:n+one+m);
        t = x(n+one+m+1:end);
        f = cc_true'*x;         % true cost
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
     
elseif ATTEMPT == 2
%%%%%%%%%%%%%%%%%%%%%%%%%% ONLY V RANDOMIZED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%       min    g*e'*y + e'*q
%       s.t.  -D*V*B'*p + D*e*b - y <= -1
%                             p - q <= 0
%                            -p - q <= 0
%                                 y >= 0
%                                 q >= 0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     B = randi(100, k, n);
     DVB = (DV*B')';
     
     E = [ -DVB'     De       -I_m     O_m_k;...
            I_k     O_k_1    O_k_m      -I_k; ...
           -I_k     O_k_1    O_k_m      -I_k; ...
          O_m_k     O_m_1     -I_m     O_m_k; ...
          O_k_k     O_k_1    O_k_m      -I_k];

  
     upperbound = [-One_m_1; ...
                    O_k_1; ...
                    O_k_1; ...
                    O_m_1; ...
                    O_k_1]; 
 
     c = [O_k_1;...
          O_1_1;...
          g * One_m_1;...
          One_k_1];

     options = optimoptions('linprog','Algorithm','dual-simplex',...
                            'Display','iter', 'MaxIterations', 150000);
     [w,f,~,~,~] = linprog(c, E, upperbound,[],[],[],[],options);
     try
         p = w(1:k);
         b = w(k+1);
         y = w(k+2:k+one+m);
         q = w(k+one+m+1:end);
         % Since function has outputs:
         x = w;
         a = p;
         t = q;
     catch
         fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
     %%% Finding private coefficients
      % IMPOSSIBLE
  
elseif ATTEMPT == 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERMUTATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%      min     g*e'*B_y'*w + e'*B_t'*w
%      s.t.   -D*V*B_a'*w + D*e*B_b'*w - B_y'*w <= -1
%                         P1*B_a'*w - P1*B_t'*w <= 0
%                        -P2*B_a'*w - P2*B_t'*w <= 0
%                                     P3*B_y'*w >= 0
%                                     P4*B_t'*w >= 0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Permutation matrices
    P1 = eye(n);
        P1 = P1(randperm(n),:);
    P2 = eye(n);
        P2 = P2(randperm(n),:);
    P3 = eye(m);
        P3 = P3(randperm(m),:);
    P4 = eye(n);
        P4 = P4(randperm(n),:);

    E = [  -DV      De       -I_m       O_m_n; ...
          P1*I_n   O_n_1     O_n_m    -P1*I_n; ...
         -P2*I_n   O_n_1     O_n_m    -P2*I_n; ...
           O_m_n   O_m_1   -P3*I_m      O_m_n; ...
           O_n_n   O_n_1     O_n_m    -P4*I_n];

     upperbound = [-One_m_1; ...
                    O_n_1; ...
                    O_n_1; ...
                    O_m_1; ...
                    O_n_1];

    c = [O_n_1; ...
         O_1_1; ...
         g * One_m_1; ...
         One_n_1];

    B = randi(10, size(E, 2));
    EE = E * B';
    cc_true = c;
    cc = B * c;

    options = optimoptions('linprog','Algorithm','dual-simplex',...
                            'Display','iter', 'MaxIterations', 150000);
    [w,f,~,~,~] = linprog(cc, EE, upperbound, [], [], [], [], options);

     %%% Finding private coefficients
     try
        x = B' * w;
        a = x(1:n);
        b = x(n+1);
        y = x(n+2:n+one+m);
        t = x(n+one+m+1:end);
        f = cc_true'*x;      % true cost
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
 end