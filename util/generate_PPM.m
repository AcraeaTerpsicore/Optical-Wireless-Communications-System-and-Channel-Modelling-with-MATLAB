function PPM=generate_PPM(M,nsym)
% function to generate PPM;
% ‘M' bit resolution; % ‘nsym': number of PPM symbol
PPM=[];
for i= 1:nsym
    temp=my_randint(1,M); % random binary number
    dec_value=bi2de(temp,'left-msb') % converting to decimal value
    temp2=zeros(1,2^M); % zero sequence of length 2^M
    temp2(dec_value+1)=1;
    % placing a pulse according to decimal value,
    % note that in Matlab index doe snot start from zero, so need to add 1;
    PPM=[PPM temp2]; % PPM symbol
end
end