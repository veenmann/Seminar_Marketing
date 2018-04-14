function [a, b, u, f] = Main_nienke(V,S) 
 % CASE = 0         Original problem
 % CASE = 1         x = B'u
 % CASE = 2         A --> AB', w --> p, t --> q
 
   CASE = 0;        % <--- CHANGE THIS ONE
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE 1                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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