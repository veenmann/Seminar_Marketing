function [A,e] = Circle_data()
xCenter = 12;
yCenter = 10;
theta = 0 : 0.01 : 2*pi;
radius = 5;
x1 = radius * cos(theta) + xCenter;
y1 = radius * sin(theta) + yCenter;
radius = 7;
x2 = radius * cos(theta) + xCenter;
y2 = radius * sin(theta) + yCenter;

A = [x1 x2;y1 y2];
A = A';
e = ones(size(A,1),1);
e(1:size(A,1)/2) = -1;
end