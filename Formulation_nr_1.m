function [a, b, u, f, x] = Formulation_nr_1(V,s, ATTEMPT)
% FORMUATION_NR_1 Linear Programming SVM training models for 3
% different cases.
% [a, b, u , f, x] = Formuation_nr_1(A,e)
% Inputs:
%   V         Data matrix
%   s         Labels (1 and -1) vector
%   ATTEMPT   0   Original problem
%             1   Private problem (x = B'w)
% Outputs:
%   a         Coefficients vector
%   b         Data seperation hyperplane (constant)
%   u         Vector of misspecification errors
%   f         Optimal cost value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dimentions
n=size(V,1);
k=size(V,2);

% Block matrices
D = diag(s);
DV = D*V;
I_n = eye(n);
O_n_k = zeros(n,k);
O_n_1 = zeros(n,1);
O_k1_1 = zeros(k+1,1);
One_n_1 = ones(n,1);

if ATTEMPT == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ORIGINAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                  
% 
%   min     e'*u
%   s.t.   -D*(V*a+b) - u <= -1
%                       u >=  0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    E = [ -DV     -s    -I_n; ...
          O_n_k  O_n_1  -I_n];

    upperbound = [ -One_n_1; ...
                    O_n_1];

    c = [O_k1_1;...
         One_n_1];

    options = optimoptions('linprog','Algorithm','dual-simplex',...
                            'Display','iter','MaxIter',150000);
    [x,f,~,~,~] = linprog(c, E, upperbound,[],[],[],[],options);

    %%% Finding private coefficients
        try
           u = x(k+2:end);
           a = x(1:k);
           b = x(k+1);
           f = c'*x;        
        catch
           fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
        end

elseif ATTEMPT == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PRIVATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   min   e'*B_y'*w
%   s.t. -D*V*B_a'*w - D*e*B_b'*w - B_y'*w <= -1
%                                 - B_y'*w <= 0
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    E = [ -DV     -s    -I_n; ...
          O_n_k  O_n_1  -I_n];

    upperbound = [ -One_n_1; ...
                    O_n_1];

    c = [ O_k1_1;...
          One_n_1];

    B = rand(k+1+n,k+1+n);

    EE = E*B';
    cc = B*c;

    options = optimoptions('linprog','Algorithm','dual-simplex',...
                            'Display','iter', 'MaxIter', 150000);
    [w,~,~,~,~] = linprog(cc, EE, upperbound,[],[],[],[],options);

    %%% Finding private coefficients
        try
           x=B'*w;
           u = x(k+2:end);
           a = x(1:k);
           b = x(k+1);
           f = c'*x;
        catch
           fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
        end
end