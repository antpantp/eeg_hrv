% MI Mutual information
% [mi] = MI(x, y, bins, logBase) returns the mututal information of x and y
% datasets given number of bins and base of the logarithm that is used in
% the formula.
%
% Misha Zhukov 20.05.2013
% misha.zhukov@gmail.com

function [mi] = myMi(x, y, bins)

if(size(x,1) < size(x,2))
  x = x';
  y = y';
end

n = length(x);
%initialize mi
mi = 0;

%% probabilities calculation
hx = hist(x,bins);
px = hx/sum(hx);
hy = hist(y,bins);
py = hy/sum(hy);

%% joint probability
hxy = hist3([x y], [bins bins]);
pxy = hxy ./ sum(sum(hxy));

binStruct.xy = 0;   % bins for which pxy(i,j) ~=0
binStruct.x = 0;    % bins for which px(i,j) ~= 0
binStruct.y = 0;

%% calculate Mutual information
for i=1:bins
    
  if(px(i) ~= 0) 
      binStruct.x = binStruct.x +1;
  end
  
  if(py(i) ~= 0) 
      binStruct.y = binStruct.y +1;
  end
      
  for j=1:bins
      
    if(pxy(i,j) ~= 0) % 0*log(0) = 0
      binStruct.xy = binStruct.xy +1;

      mi = mi + ...
           pxy(i,j) * log2( pxy(i,j) / (px(i)*py(j)) );
    end 
      
  end
    
end

%% Remove the error
% miTrue = mi+(binStruct.x + binStruct.y-...
%             binStruct.xy-1)/(2*n);
% miTrue = mi;
end

% sysError = (bins*bins - bins - bins + 1) / (2*length(x)); 
% fprintf('\nSystematic error of MI: %.4f', sysError);
