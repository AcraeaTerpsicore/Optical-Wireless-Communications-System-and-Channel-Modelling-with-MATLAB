function result = Q(x)
    result = 1/2 * erfc(sqrt(x^2) / sqrt(2));
    % result = erfc(x/sqrt(2))/2;  %Gaussian Q function
end