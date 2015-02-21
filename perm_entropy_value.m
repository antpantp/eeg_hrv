function PE=perm_entropy_value(sig,order)
% PE=perm_entropy_value(sig,order)
%
% Calculates the value of Permutation Entropy of the order ORDER for
% the whole signal stored in SIG. The algorithm is taken from the paper of Brand, Pompe, 2001,
% "Permutation entropy--a natural complexity measure for time series".
% The value of "permutation entropy per symbol" is computed as
% Hp(order)=h(order)/(order-1), where Hp(order) is Permutation Entropy of
% respective order

% 02.11.2012 - developed and tested using the example from the paper of Brand, Pompe, 2001
% 03.11.2012 - modified, calculating normalized PE, following the paper of
% Yinhe Cao et al., "Detecting dynamical changes in time series using the
% permutation entropy", PHYSICAL REVIEW E 70, 046217 (2004). Normalization
% is Hp_norm(order)=Hp(order)/(order!)

N=length(sig);
M=[1:order]';
perm=pick(M,order,'o');%array of all possible permutations.
m=size(perm,1);
P=zeros(m,1);% vector for counting the number of permutations match
K=zeros(order,2);% array for signal parts of length ORDER
K(:,2)=M;% initialization with proper sequence of numbers, for the first signal part

for i=1:N-order+1
    K(:,1)=sig(i:i+order-1);%picking the signal samples into first column
    B=transpose(sortrows(K));%sorting rows (first column is for rearranged samples, second -- for numbers)
    % looking for the permutation
    for j=1:m
        if all(B(2,:)==perm(j,:))
            P(j)=P(j)+1;
        end
    end
    K(:,2)=M;
end
P=P/(N-order+1);% averaging 
I=find(P);% finding indicies of nonzero elements (for logarithm function)
% initial PE
%PE=-1*sum(P(I,1).*log2(P(I,1)));

% permutation entropy per symbol
% PE=-1*sum(P(I,1).*log2(P(I,1)))/(order-1);

% normalized PE (03.11.2012)
PE=-1*sum( P(I,1).*log2(P(I,1))) /log2(prod(1:order));