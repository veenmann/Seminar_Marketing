% Random
A = randi(5,10,2);
e = randi(2, 10,1)-1;
e(e == 0) = -1;
% Fixed
%A = [1 1; -1 -1; 1 -1];
%e = [1;-1; -1]
% Code
[a,b] = Elena_new(A,e); 
hold on
plot(A, 'ob')
Q = A*a +b;
plot(Q, '-r')
hold off