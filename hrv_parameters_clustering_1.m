% HRV parameters clustering
% k-means
% 23.03.2015 -- start

close all;
clear all;
clc;

X = [randn(100,1)+ones(100,1)];...
%      randn(100,2)-ones(100,2)];
opts = statset('Display','final');

[idx,ctrs] = kmeans(X,5);%,...
%                     'Distance','city',...
%                     'Replicates',5,...
%                     'Options',opts);
% 5 iterations, total sum of distances = 284.671
% 4 iterations, total sum of distances = 284.671
% 4 iterations, total sum of distances = 284.671
% 3 iterations, total sum of distances = 284.671
% 3 iterations, total sum of distances = 284.671

plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
plot(ctrs(:,1),ctrs(:,2),'kx',...
     'MarkerSize',12,'LineWidth',2)
plot(ctrs(:,1),ctrs(:,2),'ko',...
     'MarkerSize',12,'LineWidth',2)
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures seizures only\';
dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\very_good\';
% dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\good\';


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
    'PE',...
%     'HFn',...
%     'LFn',...
%     'LF_HF',...
%     'RMSSD',...
%     'AE'...
    };% parameter name = fcode

% y_lim=[0 30];


for par_name=par_names
for Tw=30;%[10 30 60 120 180]%m=ms%M=Ms
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
