% calculating trends of RR characteristics over time
% 07.03.2015 -- start

close all
clear all;
clc

% dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures seizures only\';
dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\very_good\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\good\';


T=600;% sec, duration of signal part before seizure
Tw=30;% time window, sec
% To=30;% overlapping, sec
To=Tw/2;

r=.01;% ApEn tolerance
Ms=2;
% % Ms=[2:5];% approximate entropy embedded dimension
ms=[3:5]; % Permutation Entropy orders
m=5;
c=1;% counter
par_names={...
%     'PE',...
%     'HFn',...
%     'LFn',...
%     'LF_HF',...
%     'RMSSD',...
%     'AE'...
'RR',...
'Det',...
'ADL',...
'LLDL',...
'EDL',...
'Lam',...
'TT',...
'LLVL',...
'RT1',...
'RT2',...
'RPDE',...
'CC',...
'Trans',...
    };% parameter name = fcode
% y_lim=[0 30];


for par_name=par_names
for Tw=[30 60 120 ]%m=ms%M=Ms
    To=Tw/2;
    tic
    %before
    [PE]=seizure_chracteristic_trends(dir_in,'before',par_name,T,Tw,To,m);
    win_num=size(PE,2);
    
    %%%% boxplotting boxplots
    pe=[];
    group=[];
    for w=1:win_num
        pe=[pe, PE{w}'];
        group=[group, w*ones(1,length(PE{w}))];
    end
    N=min([length(PE{1}),length(PE{2})]);
    P=[PE{1}(1:N),PE{2}(1:N)];
    figure
    boxplot(pe,group); set(gcf,'color','white');
    title(['Before Seizure, ',par_name,' Tw=',num2str(Tw),' KW p='...
        , num2str(kruskalwallis(P,[],'off'))],'Interpreter','none');...
        set(gca,'xdir','reverse');
%     ylim(y_lim);
    grid on;
    xlabel('Window number with respect to seizure onset');
    ylabel(par_name,'Interpreter','none')
%     if ttest2(PE{1},PE{2})==1
%         disp([par_name, Tw])
%     end
    
    
    
    
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
