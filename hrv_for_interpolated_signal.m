function [m,varargout] = hrv_for_interpolated_signal(tNN,fs);
% Function that calculates various HRV characteristics. FS is the sampling
% rate of NN intervals. tNN is the vector containing NN intervals.
% 21.03.2015

% varargout{1} -- hrv_mean
% varargout{2} -- hrv_SDNN
% varargout{3} -- hrv_LF_HF
% varargout{4} -- hrv_LFn
% varargout{5} -- hrv_HFn
% varargout{6} -- hrv_RMSSD
% varargout{7} -- hrv_TP;

m=[];
hrv_n = length(tNN); 
hrv_mean = sum(tNN)/hrv_n; % ms

hrv_HR = 60*1000*hrv_n/sum(tNN); % 1/s
varargout{1} = sum(tNN)/hrv_n; % ms

s = sum((tNN-hrv_mean).*(tNN-hrv_mean));
varargout{2} = sqrt(s/(hrv_n-1)); % ms

hrv_pNN50 = 0;
i = find(diff(tNN) > 50); % > 50 ms
varargout{6} = sqrt(sum(diff(tNN).^2)/(hrv_n-1)); % ms
hrv_pNN50 = length(i)/hrv_n*100; % %


ttNN = tNN(1);
for i = 2:length(tNN),
 ttNN(i) = ttNN(i-1)+tNN(i);% time base for NN intervals
end

% ������������ ������

fN = length(tNN);
ww = hamming(fN); % ���� ��������

% ww = hann(fN); % ���� �����
fNN = fft((tNN-mean(tNN)).*ww); %  ?


%%%%%%%%%%%%%%5
%%% Zhenia, it was here beforehand
% fHFi = floor(0.4*fN*hrv_mean/1000)+1; % 0.4 ��
% fLFHFi = floor(0.15*fN*hrv_mean/1000)+1; % 0.15 �� 
% fVLFLFi = floor(0.04*fN*hrv_mean/1000)+1; % 0.04 �� 
% fULFVLFi = floor(0.015*fN*hrv_mean/1000)+1; % 0.015 �� 
% fULFi = floor(0.003*fN*hrv_mean/1000)+1; % 0.003 �� 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Anton, added on 24.01.2015
f=linspace(0,fs,fN);% frequency vector in Hz
% indicies for edge frequencies
k=find(f>0.4); fHFi = k(1);  % 0.4 ��
k=find(f>0.15); fLFHFi = k(1); % 0.15 �� 
k=find(f>0.04); fVLFLFi = k(1); % 0.04 �� 
k=find(f>0.015); fULFVLFi = k(1); % 0.015 �� 
k=find(f>0.003);  fULFi = k(1); % 0.003 �� 
%----------------------------------------------------------------

fPNN = 2*abs(fNN(1:round(fN/2))).^2; % ms^2
hrv_TP = sum(fPNN(1:fHFi));
hrv_ULF = sum(fPNN(fULFi:fULFVLFi));
hrv_VLF = sum(fPNN(fULFVLFi:fVLFLFi));
hrv_LF = sum(fPNN(fVLFLFi:fLFHFi));
hrv_HF = sum(fPNN(fLFHFi:fHFi));
  
varargout{3} = hrv_LF/hrv_HF; % 1
varargout{4} = hrv_LF/(hrv_TP-hrv_VLF)*100;% %
varargout{5} = hrv_HF/(hrv_TP-hrv_VLF)*100; % %
varargout{7} = hrv_TP;
varargout{8} = hrv_TP;
end
