 % CASE = 0         Original problem
 % CASE = 1         A --> AB', w --> p, t --> q
 % CASE = 2         x = B'u
 % CASE = 3         Permutation
 
   CASE = 1;        % <--- CHANGE THIS ONE
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

n=size(A,1);
k=size(A,2);

D = diag(e);

DA=D*A;
I_n=eye(n);
O_k=zeros(k,k);
O_n_k=zeros(n,k);
One_n1=ones(n,1);
O_n1=zeros(n,1);
O_nk=zeros(n+k,1);
O_n=zeros(n,n);
One_n=ones(n,1);

if CASE == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 0                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = [ -DA   -D   -I_n; ...
      O_n_k   O_n  -I_n];
  
b = [ -One_n1; ...
      O_n1];
 
  
c = [ O_nk;...
      One_n];
  
options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter');

[x,f,exitflag,out,lambda] = linprog(c, E, b,[],[],[],[],options);

 %%% Finding private coefficients
     try
        w = x(k+n+1:end);
        a = x(1:k);
        b = x(k+1:k+n);
        f = c'*x;             
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end

elseif CASE == 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 1                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
E = [ -DA   -D   -I_n; ...
      O_n_k   O_n  -I_n];

  
b = [ -One_n1; ...
      O_n1];
 
  
c = [ O_nk;...
      One_n];
  
B=rand(2*n+k,2*n+k);

EE=E*B';
cc=c'*B';

options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter');
[u,f,exitflag,out,lambda] = linprog(cc, EE, b,[],[],[],[],options);

 %%% Finding private coefficients
     try
        x=B'*u;
        w = x(k+n+1:end);
        a = x(1:k);
        b = x(k+1:k+n);
        f = c'*x;             
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
end
   