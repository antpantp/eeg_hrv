% plotting the parts of signals before and after each seizure
% 26.01.2015 -- 

close all;
clear;
clc;

% dir_in='M:\EEG_ECG Haritonov\MAT\FocalSeizures\focal_seizures_ECG\with_seizures_separated\';
dir_in='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';
fileStruct=dir(strcat(dir_in,'*.mat'));

%%%%%%%%%%%%%%%%%55
%%%% plotting whole parts before and after seizures
channels={'F7','O1','ECG'};% channels to plot

for i=1:length(fileStruct)% all mat files
    load([dir_in,fileStruct(i).name])
    fileStruct(i).name
    S=length(d.seizureStart)% number of seizures
        for s=1:S; % for every seizure in the signal
            ind = findChannelIndex(d.labels,channels);
            figure
            set(gcf,'name',['Seizure starting at ',num2str(d.seizureStart(s))]);
                        
            subplot(3,2,1)
            plot(d.seizure(s).time_relBefore,d.seizure(s).sigBefore(:,ind(1))); grid on;
            title([channels{1}, ', before'])

            subplot(3,2,2)
            plot(d.seizure(s).time_relAfter,d.seizure(s).sigAfter(:,ind(1))); grid on;
%             set(gca,'xticklabel',d.seizure(s).time_relAfter)
            title([channels{1}, ', after'])
            
            subplot(3,2,3)
            plot(d.seizure(s).time_relBefore,d.seizure(s).sigBefore(:,ind(2))); grid on;
%             set(gca,'xticklabel',d.seizure(s).time_relBefore)
            title([channels{2}, ', before'])
            subplot(3,2,4)
            plot(d.seizure(s).time_relAfter,d.seizure(s).sigAfter(:,ind(2))); grid on;
%             set(gca,'xticklabel',d.seizure(s).time_relAfter)
            title([channels{2}, ', after'])
            
            subplot(3,2,5)
            plot(d.seizure(s).time_relBefore,d.seizure(s).RRBefore'); grid on;
%             set(gca,'xticklabel',d.seizure(s).time_relBefore)
            title(['RR', ', before'])
            subplot(3,2,6)
            plot(d.seizure(s).time_relAfter,d.seizure(s).RRAfter'); grid on;
%             set(gca,'xticklabel',d.seizure(s).time_relAfter)
            title(['RR', ', after'])

            
            
        end

end

