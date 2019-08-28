function [ g ] = predict( gi, w, i, j )
%FLUCTUATION Summary of this function goes here
%   Detailed explanation goes here

t1 = gi(i-1, j-1) + gi(i+1, j-1) + gi(i-1, j+1) + gi(i+1, j+1);
t2 = gi(i, j-1) + gi(i-1, j) + gi(i+1, j) + gi(i, j+1);
g = floor((t1 + w*t2)/(4*(1 + w)));
end

