function i_qrs = findqrs(s,fs,show_figure,varargin)

a_th = 0.1; % mV
peaks_th = 0.5; % 0.25;
int_d = 0.15; % s
max_win_d = 1; % s
peaks_mindist = 10; % samples
ref_lead_i = 1; % ECG I

if (~exist('show_figure','var'))
  show_figure = 0;
end

if nargin == 0
  return;
end

i = 1;
while (i <= nargin-3)
  arg = cell2mat(varargin(i));
  if (ischar(arg))
    switch lower(arg)
      case 'ref_lead'
        ref_lead_i = cell2mat(varargin(i+1));  
        i = i+2;
      otherwise
        error(['Unknown method: ' arg]);
    end
  else
    i = i+1;
  end
end    


i_qrs = [];
int_len = floor(int_d*fs);
ecg_ref = [0; diff(s(:,ref_lead_i))].^2;
ecg_ref = filter(ones(int_len,1)/int_len, 1, ecg_ref);

ecg_ref_max = slidefun(@max, floor(max_win_d*fs), ecg_ref);
% ecg_ref_max = max(ecg_ref);

ii = find(ecg_ref > peaks_th*ecg_ref_max);
if (length(ii) <= 1)
    i_qrs = [];
    return;
end    
% size(ii)
iii = find(diff(ii) > 1);
if (length(iii) == 0)
    i_qrs = [];
    return;
end    

qrs_i_ref_right = [ii(iii); ii(end)];
qrs_i_ref_left = [ii(1); ii(iii+1)];

qrs_i_ref = round((qrs_i_ref_left + qrs_i_ref_right)/2);
% i_qrs = qrs_i_ref - round(int_len/2);

qrs_base = zeros(size(qrs_i_ref_left));
qrs_i_left = zeros(size(qrs_i_ref_left));
qrs_i_right = zeros(size(qrs_i_ref_left));

for i = 1:length(qrs_i_ref_left),
  i_left = qrs_i_ref_left(i) - round(int_len/2);
  i_right = qrs_i_ref_right(i) - round(int_len/2);
  i_left = max(1,i_left); i_left = min(size(s,1),i_left);
  i_right = max(1,i_right); i_right = min(size(s,1),i_right);
  [pmax, ii_max] = max(s(i_left:i_right, ref_lead_i));
  [pmin, ii_min] = min(s(i_left:i_right, ref_lead_i));
  pbase = mean(s(i_left:i_right, ref_lead_i)); 
  qrs_base(i) = pbase;
  qrs_i_left(i) = i_left;
  qrs_i_right(i) = i_right;
  if (abs(pmax-pmin) < a_th) 
    i_qrs(i) = NaN;
  else
    if (abs(pmax-pbase) > abs(pmin-pbase))
      i_qrs(i) = i_left + ii_max - 1;
    else  
      i_qrs(i) = i_left + ii_min - 1;
    end
  end  
end

ii = find(isfinite(i_qrs));
i_qrs = i_qrs(ii);
qrs_base = qrs_base(ii);


if (show_figure)
  hf = figure('Name','findqrs: Signal and QRS markers');
  t = (0:length(s)-1)*1/fs;
  
  ha(1) = subplot(2,1,1);
  line(t(i_qrs),s(i_qrs,ref_lead_i),'LineStyle','none','Color','k','Marker','.');
  line(t(i_qrs),qrs_base,'LineStyle','none','Color','k','Marker','*');
  line(t(qrs_i_left),s(qrs_i_left,ref_lead_i),'LineStyle','none','Color','b','Marker','.');
  line(t(qrs_i_right),s(qrs_i_right,ref_lead_i),'LineStyle','none','Color','m','Marker','.');
  line(t-t(round(int_len/2)),ecg_ref./ecg_ref_max*max(s(:,ref_lead_i)),'LineStyle',':','Color','r');
  line(t, s(:,ref_lead_i),'Color','b');
  grid on;
  
  ha(2) = subplot(2,1,2);
  line(t, ecg_ref,'Color',[0 0.4 0]);
  line(t, ecg_ref_max,'Color',[1 0 0]);
  line(t(qrs_i_ref),ecg_ref(qrs_i_ref),'LineStyle','none','Color','r','Marker','o');
  line(t(qrs_i_ref_left),ecg_ref(qrs_i_ref_left),'LineStyle','none','Color','b','Marker','.');
  line(t(qrs_i_ref_right),ecg_ref(qrs_i_ref_right),'LineStyle','none','Color','m','Marker','.');
  grid on;
  linkaxes(ha,'x');

  % momentary_period = diff(qrs_i)*1/Fs;
  % 
  % period = mean(momentary_period);
  % hr = 60/period;
  % 
  % figure;
  % plot(momentary_period, '.-');
  % grid on;
  % text(1, 0.5, ['HR = ' num2str(hr) ' 1/min']);
end
