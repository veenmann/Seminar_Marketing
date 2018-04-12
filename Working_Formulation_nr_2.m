function [a, b, u, f] = Working_Formulation_nr_2(A,e) 
 % CASE = 0         Original problem
 % CASE = 1         x = B'w
 
   CASE =0;        % <--- CHANGE THIS ONE
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  V=A;           % For the full matrix input A
% A=A(:,6:7);    % Copy inside command window if wanted to plot the data in 2 dimensions
  S=e;

n=size(V,1);
k=size(V,2);

D = diag(S);

DV = D*V;
I_n=eye(n);
O_n_k=zeros(n,k);
O_n_1=zeros(n,1);
O_k1_1 = zeros(k+1,1);
One_n_1=ones(n,1);

if CASE == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE = 0                    
% 
% V * a + b  > 0    if s_i=1
% V * a + b <= 0    if s_i=1
%
% s_i*(V*a+b) >= 1
% D = diag (s_i)
%
% minimize:    sum (max 0, 1- D(V*a+b))
% such that:   1- D(V*a+b) <= u
%                          u>=0
%
% REVWRITE
% minimize:    sum u
% such that:   - D(V*a+b) - u <= -1
%                           u >=  0
%
% MATRIX
%                 -DA  -s  -I
%                 nxk  nx1 nxn
%         E =       0   0  -I
%                 nxk  nx1 nxn
%
%               a
%              kx1
%               b
%          x = 1x1
%               u
%              nx1
%
%                      -1 
%         upperbound = nx1
%                       0
%                      nx1
%
%
%         c =  0   0    1
%             kx1 1x1 nx1
%
%
% REWRITE IN MATRIX FORM 
%
% minimize:    c * x
% such that:   E * x <= upperbound
%                          
%       
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = [ -DV     -S    -I_n; ...
      O_n_k  O_n_1  -I_n];
  
upperbound = [ -One_n_1; ...
                O_n_1];
  
c = [O_k1_1;...
     One_n_1];
  
options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter','MaxIter',1500);
[x,f,exitflag,out,lambda] = linprog(c, E, upperbound,[],[],[],[],options);

%%% Finding private coefficients
    try
       u = x(k+2:end);
       a = x(1:k);
       b = x(k+1);
       f = c'*x;        
    catch
       fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
    end

elseif CASE == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE = 1
% 
% replace x = B' * w
%
% where B is a random matrix where the number of columns is at least the
%      mxp
% number of rows in E -> p >= size(E,2) and m can be anything 
%                     -> we used a square matrix  B
%                                                pxp
% 
% V * a + b  > 0    if s_i=1
% V * a + b <= 0    if s_i=1
%
% s_i*(V*a+b) >= 1
% D = diag (s_i)
%
% minimize:    sum (max 0, 1- D(V*a+b))
% such that:   1- D(V*a+b) <= u
%                          u>=0
%
% REVWRITE
% minimize:    sum u
% such that:   - D(V*a+b) - u <= -1
%                           u >=  0
%
% MATRIX
%                 -DA  -s  -I
%                 nxk  nx1 nxn
%         E =       0   0  -I
%                 nxk  nx1 nxn
%
%               a
%              kx1
%               b
%          x = 1x1
%               u
%              nx1
%
%                      -1 
%         upperbound = nx1
%                       0
%                      nx1
%
%
%         c =  0   0    1
%             kx1 1x1 nx1
%
%
% REWRITE IN MATRIX FORM 
%
% minimize:    c * B' * w
% such that:   E * B' * w <= upperbound
%                          
%       
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


E = [ -DV     -S    -I_n; ...
      O_n_k  O_n_1  -I_n];
  
upperbound = [ -One_n_1; ...
                O_n_1];
  
c = [ O_k1_1;...
      One_n_1];
  
B=rand(k+1+n,k+1+n);

EE=E*B';
cc=c'*B';

options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter', 'MaxIter', 150000);
[w,func,exitflag,out,lambda] = linprog(cc, EE, upperbound,[],[],[],[],options);

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