function result = my_randint(varargin)
    % Determine the number of input arguments
    if nargin == 3
        symb = varargin{1};
        N_sub = varargin{2};
        M = varargin{3};
        result = randi(M-1, symb, N_sub);
    elseif nargin == 2
        number_of_rows = varargin{1};
        number_of_columns = varargin{2};
        result = randsrc(number_of_rows, number_of_columns, [0 1]);
    else
        error('Incorrect number of input arguments');
    end
end
