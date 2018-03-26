%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make A matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8), default_bin(:,1:2), ...
     housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
      day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
      consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
 %B = 10*rand(size(A,1),size(A,2));
  
 %Create variables for A matrix
 DA = D*A;
 De = D*e;
 I = eye(size(A,1));
 neg_De = -1*De;
 neg_DA = -1*DA;
 A_matrix = [DA,neg_DA,neg_De,I];
 %B = 10*rand(size(A_matrix,1),size(A_matrix,2));
 A_matrix = (-1)*A_matrix;
 %A_matrix = A_matrix*B';
 
 %Create parameter v
 v = 0.01;
 
 %Create cost c
 c = [ones(1,2*size(A,2)),zeros(1),(v*ones(1,4119))];%*B';
 
 %Create lower bound lb
 lb = zeros(1,size(A_matrix,2));
 lb(107) = -1000;

 %Run LP optimization
 LP = linprog(c,A_matrix,(-1)*ones(4119,1),[],[],lb,[]);
 w_pos = LP(1:53);
 w_neg = LP(54:106);
 gamma = LP(107)
 y = LP(108:end);