function DPIM=generate_DPIM(M,nsym,NGS)
% function to generate DPIM sequence; 
% M: bit resolution; 
% nsym: numberof symbols; % NGS: number of guard slots (default value is zero)
if nargin == 2,
    NGS = 0; %default number of guard slots
end
DPIM=[];
for i= 1:nsym
    inpb(i,:)=my_randint(1,M);
end
for i=1:nsym
    inpd=bi2de(inpb(i,:),'left-msb');
    % Converting binary to decimal number
    temp=[zeros(1,(inpd+NGS))];
    % inserting number of zeros in DPIM
    DPIM=[DPIM 1 temp];
    % inserting ‘1' at the start of each symbol
end