% calculating trends of RR characteristics over time
% visuzlization of both before and after, and KW test of last window before 
% and first window after
% 28.03.2015 -- start

close all
clear all;
clc

% dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures seizures only\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\very_good\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\generalized seizures seizures only\';%'D:\DATA\ЭЭГ_от_Харитонова\temp\good\';
dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures initial signal_0_2 seizures only\';


T=300;% sec, duration of signal part before seizure
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
% 'RR',...
% 'Det',...
% 'ADL',...
% 'LLDL',...
% 'EDL',...
% 'Lam',...
% 'TT',...
% 'LLVL',...
% 'RT1',...
'RT2',...
'RPDE',...
'CC',...
'Trans',...
    };% parameter name = fcode
% y_lim=[0 30];


for par_name=par_names
for Tw=[30 60 90 120 150 180]%m=ms%M=Ms
    Tw
    To=Tw/2;
    tic
    % before seizure
    [PEb]=seizure_chracteristic_trends(dir_in,'before',par_name,T,Tw,To,m);
    win_num=size(PEb,2);
    
    %%%% preparations to boxplotting boxplots
    peb=[];
    groupb=[];
    for w=1:win_num
        peb=[peb, PEb{w}'];
        groupb=[groupb, -1*w*ones(1,length(PEb{w}))];
    end
    
    
    
    % after seizure
    [PEa]=seizure_chracteristic_trends(dir_in,'after',par_name,T,Tw,To,m);
    win_num=size(PEa,2);
    
    %%%% preparations to boxplotting boxplots
    pea=[];
    groupa=[];
    for w=1:win_num
        pea=[pea, PEa{w}'];
        groupa=[groupa, w*ones(1,length(PEa{w}))];
    end
    
    %%% preparing for KW test
    N=min([length(PEb{1}),length(PEa{1})]);
    P=[PEb{1}(1:N),PEa{1}(1:N)];
    pe=[peb pea];
    group=[groupb groupa];
    KW=kruskalwallis(P,[],'off')
    if KW<=.2
        figure
        boxplot(pe,group); set(gcf,'color','white');
        title(['Before and After Seizure, ',par_name,' Tw=',num2str(Tw),' KW p='...
            , num2str(KW)],'Interpreter','none');...
            set(gca,'xdir','normal');
        grid on;
        xlabel('Window number with respect to seizure onset');
        ylabel(par_name,'Interpreter','none')
    end


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
