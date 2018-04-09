function e_hat = forecast(A, e, w, gamma, y, t)
e = ones(size(y,1),1);
e_hat = A*w - e*gamma + y;
end