function [rr,rr_t]=extract_rr_as_function(d,Fs);
% Function returns RR intervals (in seconds) in RR vector, RR_T is the time
% stamps for RR intervals.
% 

frame_len = 100000; % frame length
rr_min = 0.2; % s
rr_max = 2; % s
rr_dmax = 0.2; % s  0.5
maf_len = 25; % moving average filter length
maf_dth = 0.2; % s, deviation threshold from moving average  0.5

i_qrs = [];

% Process ECG signal frame by frame (for memory saving)
for i = 1:frame_len:length(d) 
  i_end = min(i+frame_len,length(d));
%   fprintf(1,'Processing frame (%d:%d).... \n', i, i_end);  
  ecg = d(i:i_end)*1e-3; % mV
  
  % Find QRS complexes...
  i_qrs_frame = findqrs(ecg,Fs,0,'ref_lead',1);   
  drawnow();
  
  i_qrs = [i_qrs; i_qrs_frame' + i - 1];
%   fprintf(1,'Done\n');  
end  
t_qrs = (i_qrs-1)/Fs; % s
rr = diff(t_qrs);
rr_t = t_qrs(1:end-1);

%--------------------------------------------------------------------------
% Some kind of "magic" for to remove error RR...
%--------------------------------------------------------------------------

rr_raw = rr;
rr_t_raw = rr_t;
i = 1:length(rr_raw);

% RR must be in rr_min to rr_max
ii = find((rr_min <= rr) & (rr <= rr_max));
rr = rr(ii);
rr_t = rr_t(ii);
i = i(ii);

% Single spikes removing....
ii_err = find((abs(rr(2:end-1)-rr(1:end-2)) > rr_dmax) & (abs(rr(2:end-1)-rr(3:end)) > rr_dmax)) + 1;
i_err1 = i(ii_err);
ii = find((abs(rr(2:end-1)-rr(1:end-2)) < rr_dmax) | (abs(rr(2:end-1)-rr(3:end)) < rr_dmax)) + 1;
rr = rr(ii);
rr_t = rr_t(ii);
i = i(ii);

% Removing spikes with deviation from moving average > maf_dth
rr_ma = filtfilt(ones(maf_len,1)/maf_len,1,rr); % moving average signal
ii_err = find(abs(rr-rr_ma) > maf_dth);
i_err2 = i(ii_err);
ii = find(abs(rr-rr_ma) <= maf_dth);
rr = rr(ii);% !!!!!!!!!!!
rr_t = rr_t(ii);% !!!!!!!!!!!
rr_ma = rr_ma(ii);
i = i(ii);

%--------------------------------------------------------------------------
hf = figure;
subplot(2,1,1);
plot(rr_t_raw,rr_raw,'.',rr_t,rr,'.:',rr_t,rr_ma,'m');
hold on;
plot(rr_t_raw(i_err1),rr_raw(i_err1),'or',rr_t_raw(i_err2),rr_raw(i_err2),'om');
grid on;
title('Raw RR data and errors');
xlabel('t, s');
ylabel('RR, s');
legend('Raw RR','Result RR signal','Moving average RR signal','Error RR (Single spikes)','Error RR (spikes from moving average)');
 
subplot(2,1,2);
plot(rr_t,rr,'.:');
grid on;
title('Result RR signal for further analysis');
xlabel('t, s');
ylabel('RR, s');

% hrv(rr,rr_t);

end