 % CASE = 0         Original problem
 % CASE = 1         x = B'u
 % CASE = 3         Permutation
 
 CASE = 1;        % <--- CHANGE THIS ONE
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%Dimesions
n=size(A,1);
k=size(A,2);

%Create diagonal matrix to change signs
D = diag(e);

%Change 
DA=D*A;
I_n=eye(n);
O_k=zeros(k,k);
O_n_k=zeros(n,k);
One_n1=ones(n,1);
O_n1=zeros(n,1);
O_nk=zeros(k+1,1);
O_n=zeros(n,1);
One_n=ones(n,1);

if CASE == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 0                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = [ -DA   -e   -I_n; ...
      O_n_k  O_n  -I_n];
  
r = [ -One_n1; ...
      O_n1];
 
  
c = [ O_nk;...
      One_n];
  
options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter');

[x,f,exitflag,out,lambda] = linprog(c, E, r,[],[],[],[],options);

 %%% Finding private coefficients
     try
        w = x(k+2:end);
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
E = [ -DA   -e   -I_n; ...
      O_n_k   O_n  -I_n];

  
r = [ -One_n1; ...
      O_n1];
 
  
c = [ O_nk;...
      One_n];
  
B=randi(10,n+k+1,n+k+1);

EE=E*B';
cc=c'*B';

options = optimoptions('linprog','Algorithm','interior-point-legacy ','Display','iter');
[u,f,exitflag,out,lambda] = linprog(cc, EE, r,[],[],[],[],options);

 %%% Finding private coefficients
     try
        x=B'*u;
        w = x(k+2:end);
        a = x(1:k);
        b = x(k+1);
        f = c'*x;             
     catch
        fprintf(2, 'PROBLEMS HAVE OCCURED. CHECK x\n');
     end
end
   