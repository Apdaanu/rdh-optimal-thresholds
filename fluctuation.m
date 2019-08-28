function [ fVal ] = fluctuation( gi, g, i, j )
%FLUCTUATION Summary of this function goes here
%   Detailed explanation goes here

        f1 = (gi(i, j-1) -g)^2 + (gi(i-1, j) -g)^2 + (gi(i+1, j) -g)^2 + (gi(i, j+1) -g)^2;
        f2 = (gi(i-1, j-1) - g)^2 + (gi(i-1, j+1) - g)^2 + (gi(i+1, j-1) - g)^2 + (gi(i+1, j+1) - g)^2;
        fVal = floor((2*f1 + f2) / 3);
end

