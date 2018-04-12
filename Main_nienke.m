function [a,b]=Main_nienke(V,e) 
 % CASE = 0         Original problem
 % CASE = 1         A --> AB', w --> p, t --> q
 % CASE = 2         x = B'u
 % CASE = 3         Permutation
 
   CASE = 0;        % <--- CHANGE THIS ONE
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

n=size(V,1);
k=size(V,2);

D = diag(e);
S = e;

DV = D*V;
I_n=eye(n);
O_k=zeros(k,k);
O_n_k=zeros(n,k);
O_n_1=zeros(n,1);
O_n1_1=zeros(n+1,1);
O_n=zeros(n,n);
One_n_1=ones(n,1);
One_n1_1=ones(n+1,1);

if CASE == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 0                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = [ -DV    -S   -I_n; ...
      O_n_k  O_n_1  -I_n];
  
b = [ -One_n_1; ...
      O_n_1];
 
  
c = [ O_n1_1;...
      One_n_1];
  
options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter');
[x,f,exitflag,out,lambda] = linprog(c, E, b,[],[],[],[],options);

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 1                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E = [ -DV    -S   -I_n; ...
      O_n_k  O_n_1  -I_n];
  
b = [ -One_n_1; ...
      O_n_1];
 
  
c = [ O_n1_1;...
      One_n_1];
  
B=rand(k+1+n,k+1+n);

EE=E*B';
cc=c'*B';

options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter');
[u,f,exitflag,out,lambda] = linprog(cc, EE, b,[],[],[],[],options);

 %%% Finding private coefficients
     try
        x=B'*u;
        u = x(k+2:end);
        a = x(1:k);
        b = x(k+1);
        f = c'*x;             
     catch
 fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
end