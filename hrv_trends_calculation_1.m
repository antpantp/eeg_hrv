% calculating trends of RR characteristics over time
% 07.03.2015 -- start

close all
clear all;
clc

dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures seizures only\';

T=600;% sec, duration of signal part before seizure
Tw=60;% time window, sec
To=30;% overlapping, sec

r=.01;% ApEn tolerance
% % Ms=[2:5];% approximate entropy embedded dimension
ms=[3:5]; % Permutation Entropy orders

c=1;% counter
par_name='LF_HF';%'RMSSD';% parameter name = fcode

y_lim=[0 30];


for Tw=[30]%m=ms%M=Ms
    To=Tw/2;
    tic
    %before
    [PE]=seizure_chracteristic_trends(dir_in,'before',par_name,T,Tw,To,2);
    win_num=size(PE,2);
    
    %%%% boxplotting boxplots
    pe=[];
    group=[];
    for w=1:win_num
        pe=[pe, PE{w}'];
        group=[group, w*ones(1,length(PE{w}))];
    end
    figure
    boxplot(pe,group); set(gcf,'color','white');
    title(['Before Seizure, ',par_name,' in window Tw=',num2str(Tw)],'Interpreter','none');...
        set(gca,'xdir','reverse');
    ylim(y_lim);
    grid on;
    xlabel('Window number with respect to seizure onset');
    ylabel(par_name,'Interpreter','none')

%     % after
%     [PE]=seizure_chracteristic_trends(dir_in,'after',par_name,T,Tw,To,2);
%     win_num=size(PE,2);
%     
%     %%%% boxplotting boxplots
%     pe=[];
%     group=[];
%     for w=1:win_num
%         pe=[pe, PE{w}'];
%         group=[group, w*ones(1,length(PE{w}))];
%     end
%     figure
%     boxplot(pe,group); set(gcf,'color','white');
%     title(['After Seizure, ',par_name,' in window Tw=',num2str(Tw)],'Interpreter','none');
%     ylim(y_lim);
%     grid on;
%     xlabel('Window number with respect to seizure onset');
%     ylabel(par_name,'Interpreter','none')



%     for w=1:win_num
%         trend(c,w)=mean(PE{w});% trend of mean values
%     end
    c=c+1;
    t=toc
end
% 
% %%%%%%%%%%%%%%%%%%%
% %%%% boxplotting boxplots
% pe=[];
% group=[];
% for w=1:win_num
%     pe=[pe, PE{w}'];
%     group=[group, w*ones(1,length(PE{w}))];
% end
% 
% figure
% boxplot(pe,group); set(gcf,'color','white');
% % title('After Seizure')
% title('Before Seizure'); set(gca,'xdir','reverse');
% 
% ylim([0,1]);
% grid on;
% xlabel('Window number with respect to seizure onset');
% ylabel('PE')
% 













%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% mesh(trend);colorbar
% zlim([0 1])
% xlabel('Time window');
% ylabel('PE Order');set(gca,'ytick',ms,'yticklabel',ms)
% zlabel('PE');
% ylim([0,1])




% trendAE=zeros(1,win_num);
% for w=1:win_num
%     trendAE(w)=mean(AE{w});
% end
% figure
% plot(trendAE)
% ylim([0,1])


% for w=1:3%MaxWinNum
%     figure
%     boxplot(PE{w}(:));
%     ylim([0,1])
% end
% 
% for w=1:3%MaxWinNum
%     figure
%     boxplot(ApEn{w}(:));
%     ylim([0,1])
% end
% 


% % x = hrv_data_before(:,4); xl=size(x,1);
% % y = hrv_data_after(:,4); yl=size(y,1);
% % figure
% % group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
% % boxplot([x;y], group);
% % title('hrv_LFn','interpreter','none');
% % set(gcf,'color','white');
% % 
% % x = hrv_data_before(:,5); xl=size(x,1);
% % y = hrv_data_after(:,5); yl=size(y,1);
% % figure
% % group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
% % boxplot([x;y], group);
% % title('hrv_HFn','interpreter','none');
% % set(gcf,'color','white');
% % 
% % x = hrv_data_before(:,6); xl=size(x,1);
% % y = hrv_data_after(:,6); yl=size(y,1);
% % figure
% % group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
% % boxplot([x;y], group);
% % title('Permutation Entropy','interpreter','none');
% % set(gcf,'color','white');
% % 
% % x = hrv_data_before(:,7); xl=size(x,1);
% % y = hrv_data_after(:,7); yl=size(y,1);
% % figure
% % group = [repmat({'Before'}, xl, 1); repmat({'After'}, yl, 1)];
% % boxplot([x;y], group);
% % title('Approximate Entropy','interpreter','none');
% % set(gcf,'color','white');
% % 
% % 
% % 
% % 
