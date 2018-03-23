%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make A matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 A = [age, job_bin(:,2:12),marital_bin(:,2:4), education_bin(:,2:8), default_bin(:,1:2), ...
     housing_bin(:,1:2),loan_bin(:,1:2), contact_bin(:,1), month_bin(:,1:9),...
      day_of_week_bin(:,1:4),duration, campaign, pdays, previous, poutcome_bin(:,2:3),...
      consconfidx, conspriceidx, empvarrate, euribor3m, nremployed];
  
 %Create variables for A matrix
 DA = D*A;
 De = D*e;
 I = eye(size(A,1));
 neg_De = -1*De;
 neg_DA = -1*DA;
 A_matrix = [DA,neg_DA,neg_De,I];
 A_matrix = (-1)*A_matrix;
 
 %Create parameter v
<<<<<<<
 v = 1;
=======
 v = 0.07;
>>>>>>>
 
 %Create cost c
 c = [ones(1,2*size(A,2)),zeros(1),(v*ones(1,4119))];
 
 %Create lower bound lb
 lb=zeros(1,size(A_matrix,2));
 lb(54)=-Inf;

 %Run LP optimization
<<<<<<<
 LP = linprog(c,A_matrix,(-1)*ones(4119,1),[],[],lb,[]);
 w = LP(1:53);
 gamma = LP(54);
 y = LP(55:end);
=======
 LP = linprog(c,A_matrix,(-1)*ones(4119,1),[],[],lb,[]);
 w = LP(1:53);
 gamma = LP(54)
 y = LP(55:end);
>>>>>>>