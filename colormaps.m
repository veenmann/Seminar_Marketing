function colormaps(V)
% COLORMAPS Creates a figure with three colormaps subplots: matrix V,
% random matrix B_a and VB_a
% colormaps(V)
% Inputs:
%    V      Data matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=size(V,1);
k=size(V,2);

B=rand(k+1+n,k+1+n);
B_T = B';
B_a = B_T(1:k, 1:k+1+n);

subplot(1,3,1)
colormap('hot')
imagesc(V)
colorbar
title('Original data')
xlabel('Attributes')
ylabel('Observations')

subplot(1,3,2)
colormap('hot')
imagesc(B_a')
colorbar
title({'Random'; 'sub-matrix B_a'})

subplot(1,3,3)
colormap('hot')
imagesc(V*B_a)
colorbar
title({'Original'; 'randomized data'})
xlabel('Attributes')
ylabel('Observations')
end