%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make A matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8), default_bin(:,1:2), ...
     housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
      day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
      consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
  
  %Check code - random matrix A
  %A=rand(4119,53)*10;
      
 %Create variables for A matrix
 DA = D*A;
 De = D*e;
 
 I1 = eye(size(A,1));
 I2 = eye(size(A,2));
 
 neg_DA = -1*DA;
 neg_I1 = -1*I1;
 neg_I2 = -1*I2;
 
<<<<<<< Updated upstream
 gamma_zeros= zeros(size(A,2),1);      %53x1
 y_zeros= zeros(size(A,2),size(A,1));  %53x4119 
 t_zeros= zeros(size(A,1),size(A,2));  %4119X53
 
 A_matrix = [neg_DA,De,neg_I1,   t_zeros       ;
             I2,    gamma_zeros, y_zeros,neg_I2;
            neg_I2, gamma_zeros, y_zeros,neg_I2];
 
 %Create parameter v
 v=0.07; 
=======
 %Create parameter v
 v = 1;

>>>>>>> Stashed changes
 %Create cost c
 c = [zeros(1,size(A,2)),zeros(1),v*ones(1,size(A,1)),ones(1,size(A,2))]';
 
 %Create lower bound lb
 lb=zeros(size(A_matrix,2),1);
 lb(54)=-Inf;

 %Run LP optimization
<<<<<<< Updated upstream
 b=[(-1)*ones(4119,1);zeros(53,1);zeros(53,1)];
 LP = linprog(c,A_matrix,b,[],[],lb,[]);
 w = LP(1:53);
 gamma = LP(54)
 y = LP(55:end);
=======
 LP = linprog(c,A_matrix,(-1)*ones(4119,1),[],[],lb,[]);
 w_pos = LP(1:53);
 w_neg = LP(54:106);
 gamma = LP(107)
 y = LP(108:end);

>>>>>>> Stashed changes
