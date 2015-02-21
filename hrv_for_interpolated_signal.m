function [hrv_mean, hrv_SDNN, hrv_LF_HF, hrv_LFn, hrv_HFn] = hrv_for_interpolated_signal(tNN,fs);

hrv_n = length(tNN); 
hrv_HR = 60*1000*hrv_n/sum(tNN); % 1/s
hrv_mean = sum(tNN)/hrv_n; % ms

s = sum((tNN-hrv_mean).*(tNN-hrv_mean));
hrv_SDNN = sqrt(s/(hrv_n-1)); % ms

hrv_pNN50 = 0;
i = find(diff(tNN) > 50); % > 50 ms
hrv_RMSSD = sqrt(sum(diff(tNN).^2)/(hrv_n-1)); % ms
hrv_pNN50 = length(i)/hrv_n*100; % %


ttNN = tNN(1);
for i = 2:length(tNN),
 ttNN(i) = ttNN(i-1)+tNN(i);
end

% —пектральный анализ
fN = 64;
% if (hrv_n < fN) return;
fN = length(tNN);
ww = hamming(fN); % ќкно ’емминга
% ww = hann(fN); % ќкно ’анна
fNN = fft((tNN-mean(tNN)).*ww'); %  ?


%%%%%%%%%%%%%%5
%%% Zhenia, it was here beforehand
% fHFi = floor(0.4*fN*hrv_mean/1000)+1; % 0.4 √ц
% fLFHFi = floor(0.15*fN*hrv_mean/1000)+1; % 0.15 √ц 
% fVLFLFi = floor(0.04*fN*hrv_mean/1000)+1; % 0.04 √ц 
% fULFVLFi = floor(0.015*fN*hrv_mean/1000)+1; % 0.015 √ц 
% fULFi = floor(0.003*fN*hrv_mean/1000)+1; % 0.003 √ц 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Anton, added on 24.01.2015
f=linspace(0,fs/2,fN);% frequency vector in Hz
% indicies for edge frequencies
k=find(f>0.4); fHFi = k(1);  % 0.4 √ц
k=find(f>0.15); fLFHFi = k(1); % 0.15 √ц 
k=find(f>0.04); fVLFLFi = k(1); % 0.04 √ц 
k=find(f>0.015); fULFVLFi = k(1); % 0.015 √ц 
k=find(f>0.003);  fULFi = k(1); % 0.003 √ц 
%----------------------------------------------------------------

fPNN = 2*abs(fNN(1:round(fN/2))).^2; % ms^2
hrv_TP = sum(fPNN(1:fHFi));
hrv_ULF = sum(fPNN(fULFi:fULFVLFi));
hrv_VLF = sum(fPNN(fULFVLFi:fVLFLFi));
hrv_LF = sum(fPNN(fVLFLFi:fLFHFi));
hrv_HF = sum(fPNN(fLFHFi:fHFi));
  
hrv_LF_HF = hrv_LF/hrv_HF; % 1
hrv_LFn = hrv_LF/(hrv_TP-hrv_VLF)*100;% %
hrv_HFn = hrv_HF/(hrv_TP-hrv_VLF)*100; % %
end
