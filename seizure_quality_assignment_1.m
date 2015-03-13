% script for vizualizing signal parts around seizure and assigning it the
% score. Score is stored in the same structure.

% 04.03.2015 -- start
% 07.03.2015 -- бесполезная фигня, для ВСР артефактов нет.

clc;
close all;
clear all;

%dir_in='D:\DATA\ЭЭГ_от_Харитонова\MAT\Focal Seizures seizures only\';
dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';

%%%%%%
%% path for storing separate seizures
good_path='D:\DATA\ЭЭГ_от_Харитонова\temp\good\';
bad_path='D:\DATA\ЭЭГ_от_Харитонова\temp\bad\';
average_path='D:\DATA\ЭЭГ_от_Харитонова\temp\average\';


fileStruct=dir(strcat(dir_in,'*.mat'));

%%%%%%%%%%%%
%%% selection of channels to inspect
channels={'Fz','Pz','ECG'};
chl=length(channels);

for i=1:length(fileStruct)% all mat files in the folder
    load([dir_in,fileStruct(i).name]);
    [ind] = findChannelIndex(d.labels,channels);% opening file
    disp(fileStruct(i).name);% name of signal
    S=length(d.seizureStart);% number of seizures
    disp(['Number of seizures in the signal = ',num2str(S)]);
    for s=1:S; % for every seizure in the signal
        disp(['Seizure number S = ',num2str(s),...
            ', Start time = ',...
            datestr(d.seizure(s).time_absBefore(end)/3600/24,'HH:MM:SS.FFF')]);
        
        %%%%%%%%%
        %%% plotting channels
        %before 
        figure
        set(gcf,'name','Before seizure')
        for ch=1:chl
            subplot(chl+1,1,ch)
            plot(d.seizure(s).time_absBefore, d.seizure(s).sigBefore(:,ind(ch)))
            ylabel(channels(ch));
            xlabel('Time, sec');            
            grid on;
        end
            subplot(chl+1,1,ch+1)
            plot(d.seizure(s).time_absBefore_2Hz, d.seizure(s).RRBefore_2Hz,'.-')
            ylabel('RR');
            xlabel('Time, sec');            
            grid on;
        
%         % after
%         figure
%         set(gcf,'name','After Seizure')
%         for ch=1:chl
%             subplot(chl,1,ch)
%             plot(d.seizure(s).time_absAfter, d.seizure(s).sigAfter(:,ind(ch)))
%             ylabel(channels(ch));
%             xlabel('Time, sec');            
%             grid on;
%         end
%         subplot(chl+1,1,ch+1)
%         plot(d.seizure(s).time_absAfter_2Hz, d.seizure(s).RRAfter_2Hz,'.-')
%         ylabel('RR');
%         xlabel('Time, sec');            
%         grid on;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% saving seizures in different folders according the seizure
        %%%% quality
        
        seiz=d.seizure(s);% saving old stuff for current seizure
        dc=d;% saving current structure for future
        d=rmfield(d, 'seizure'); % removing all seizure
        d.seizure=seiz; % saving only one seizure
        sq=input('Good(g)/Bad(b)/Average(a), sq= ','s');
        switch sq
          case 'g'
              d.seizure(s).SeizureQuality=sq;
              save([good_path,'single_seizure_',num2str(s),'_',fileStruct(i).name],'d','-v7.3');
              disp('Found good one!')
          case 'b'
              d.seizure(s).SeizureQuality=sq;
              save([bad_path,'single_seizure_',num2str(s),'_',fileStruct(i).name],'d','-v7.3');
              disp('Found bad one!')
          case 'a'
              d.seizure(s).SeizureQuality=sq;
              save([average_path,'single_seizure_',num2str(s),'_',fileStruct(i).name],'d','-v7.3');
              disp('Found average one!')
          otherwise
            disp('Unknown mark, nothing was saved.')
        end
        d=dc;
        clear 'dc';
        close all;
%         keyboard;
    end
    
    
end
