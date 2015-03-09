% HRV parameters calculation for definite number of seconds before and after seizure
% onset.

% 28.01.2015
% 20.02.2015 -- calculating standard parameters + PE value
% 21.02.2015 -- ApEn calculation
% 07.03.2015 -- 2 Hz-interpolated RRs are used

close all;
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% open *.MAT files with separated seizures
% dir_in='M:\EEG_ECG Haritonov\MAT\FocalSeizures\focal_seizures_ECG\with_seizures_separated\temp\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';

% dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures seizures only\';

dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';
dir_out=dir_in;
fileStruct=dir(strcat(dir_in,'*.mat'));

% before seizure
T=3*60;% seconds before 
m=6;% Permutation Entropy order
M=4;% approximate entropy embedded dimension
H=20;% number of bins for MI calculation

hrv_data_before=[];
hrv_data_after=[];
kb=1;% seizure counter, before
ka=1;% seizure counter, after
tic
% figure;
for i=1:length(fileStruct)% all mat files
    load([dir_in,fileStruct(i).name]);
    disp(fileStruct(i).name);% name of signal
    S=length(d.seizureStart);% number of seizures
    disp(['Number of seizures in the signal = ',num2str(S)]);
    for s=1:S; % for every seizure in the signal
        disp(['Seizure number s = ',num2str(s)]);
        %%%%%%%%%
        %%% before seizure
        if d.seizure(s).time_relBefore_2Hz(1)>=T;
            disp('Enough time BEFORE!')
            st_ind=find(d.seizure(s).time_relBefore_2Hz<=T);
            st_ind=st_ind(1);% start of T-sec. window
            [hrv_data_before(kb,1), hrv_data_before(kb,2),...
                hrv_data_before(kb,3), hrv_data_before(kb,4),...
                hrv_data_before(kb,5)]=hrv_for_interpolated_signal(d.seizure(s).RRBefore_2Hz(st_ind:end),...
                d.Fs);
            
%             subplot(2,1,1);
%             plot(d.seizure(s).RRBefore(st_ind:end));
%             title(['before'])
            hrv_data_before(kb,6)=perm_entropy_value(d.seizure(s).RRBefore_2Hz(st_ind:end),m);
            hrv_data_before(kb,7)=apen(d.seizure(s).RRBefore_2Hz(st_ind:end),...
                M, .01*std(d.seizure(s).RRBefore_2Hz(st_ind:end)));
            
            
            kb=kb+1;% seizure counter
        end
        %%% After  seizure
        if d.seizure(s).time_relAfter_2Hz(end)>=T;
            disp('Enough time AFTER!')
            st_ind=find(d.seizure(s).time_relAfter_2Hz>=T);
            st_ind=st_ind(1);% end of T-sec. window
            [hrv_data_after(ka,1), hrv_data_after(ka,2),...
                hrv_data_after(ka,3), hrv_data_after(ka,4),...
                hrv_data_after(ka,5)]=hrv_for_interpolated_signal(d.seizure(s).RRAfter_2Hz(1:st_ind),...
                d.Fs);
%             subplot(2,1,2);
%             plot(d.seizure(s).RRAfter(1:st_ind));
%             title(['after'])
            hrv_data_after(ka,6)=perm_entropy_value(d.seizure(s).RRAfter_2Hz(1:st_ind),m);
            hrv_data_after(ka,7)=apen(d.seizure(s).RRAfter_2Hz(1:st_ind),...
                M,.01*std(d.seizure(s).RRAfter_2Hz(1:st_ind)));

            ka=ka+1;% seizure counter
%             figure
%             plot(d.seizure(s).time_relAfter(1:st_ind),...
%                 d.seizure(s).RRAfter(1:st_ind));
        end
%         keyboard;
    end
end
t=toc

%%%%%%%%%%%%%%%
%%% boxplot visualization with some plot-subscription magic

x = hrv_data_before(:,1); xl=size(x,1);
y = hrv_data_after(:,1); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('hrv_mean','interpreter','none');
set(gcf,'color','white');

x = hrv_data_before(:,2); xl=size(x,1);
y = hrv_data_after(:,2); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('hrv_SDNN','interpreter','none');
set(gcf,'color','white');

x = hrv_data_before(:,3); xl=size(x,1);
y = hrv_data_after(:,3); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('hrv_LF_HF','interpreter','none');
set(gcf,'color','white');

x = hrv_data_before(:,4); xl=size(x,1);
y = hrv_data_after(:,4); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('hrv_LFn','interpreter','none');
set(gcf,'color','white');

x = hrv_data_before(:,5); xl=size(x,1);
y = hrv_data_after(:,5); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('hrv_HFn','interpreter','none');
set(gcf,'color','white');

x = hrv_data_before(:,6); xl=size(x,1);
y = hrv_data_after(:,6); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('Permutation Entropy','interpreter','none');
set(gcf,'color','white');

x = hrv_data_before(:,7); xl=size(x,1);
y = hrv_data_after(:,7); yl=size(y,1);
figure
group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
boxplot([x;y], group);
title('Approximate Entropy','interpreter','none');
set(gcf,'color','white');




