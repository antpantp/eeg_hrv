function [Params]=seizure_chracteristic_trends(dir_in,Flag,fcode,T,Tw,To,varargin);

% Returns trends of RR-2-Hz interpolated characteristics of all seizures from all *.mat files in
% the folder DIR_IN. This works also if there is signle seizure in the
% file. PARAMS is the structure with the non-zero and non-NAN values of corresponding
% parameters for each seizure in the signal. Each entry in the structure is
% the array containing the parameter values for every seizure. Entry
% corresponds to the time window.

% FLAG can be 'before' (trend before seizure is calculated) or 
% 'after' (trend after seizure is calculated.) In both cases, first field 
% of PARAMS corresponds to values in time window close to seizure onset.
%
% T is the beginning of time range (in case of calculating before seizure),
% or the end of time range (if calculating after seizure).
% , starting from T sec. before 
%
% Tw - time window, sec., 
% To - window overlapping, sec.
%
% FCODE is the code of function, which calculates one single
% characteristic. VARARGIN is the sequence of input parameters for each
% particular function. The following function codes and input parameters
% are supported:
% 
% PE - Permutation Entropy:
% [Params]=seizure_chracteristic_trends(dir_in,flag,'PE',T,Tw,To,m):
% Returns trends of RR-sequence (2 Hz interpolated) Permutation Entropy 
% of all seizures in files in folder DIR_IN.
% M is the PermEn order.
% 
% AE - Approximate Entropy:
% [Params]=seizure_chracteristic_trends(dir_in,flag,'PE',T,Tw,To,M,r):
% M is the ApEn dimension, R is the tolerance.
%
% Parameter of HRV:
% see help for function "hrv_for_interpolated_signal"
% [Params]=seizure_chracteristic_trends(dir_in,flag,'PE',T,Tw,To, ....)
%
% 'SDNN' Standard Deviation of NN-intervals
% 'RMSSD' -- Root Mean Square of the Successive Differences
% 'LF_HF' -- ration of PSD
%
%


% 09.03.2015 -- start
% 

FS=2;%% Fs is 2 Hz

fileStruct=dir(strcat(dir_in,'*.mat'));
hrv_data=[];
kb=1;% seizure counter, before

%%%%%%%%%
%%% calculating trends of characteristics before seizure
for i=1:length(fileStruct)% all mat files
    load([dir_in,fileStruct(i).name]);
%     disp(fileStruct(i).name);% name of signal
    S=length(d.seizure);% number of seizures
%     disp(['Number of seizures in the signal = ',num2str(S)]);
    
    for s=1:S; % for every seizure in the signal
        %%%%%% checking duration
        if strcmp(Flag,'before')
            %%%% checking if there is enough time before seizure
            if d.seizure(s).time_relBefore_2Hz(1)<T;
%                 disp(['Not enough time before ',num2str(s),'-th seizure, proceeding to next one.'])
                continue;
            end
%             disp(['Seizure number ',num2str(s),', duration is ',...
%                 num2str( ( length(d.seizure(s).RRBefore_2Hz)-1  )/FS),' sec.']);
            
            %%%% finding the start of the part from T sec. before seizure
            st_ind=find(d.seizure(s).time_relBefore_2Hz<=T);
            st_ind=st_ind(1);% start of T-sec. part
            
            %%%% extraction of time windows before seizure, signal parts
            %%%% are arranged columnwise, closest part to seizure onset is
            %%%% in the first column!!!
            [q,~]=get_signal_parts_time(d.seizure(s).RRBefore_2Hz(st_ind:end),Tw,To,FS,'R');

        elseif strcmp(Flag,'after')%%% after seizure
            %%%% checking if there is enough time after seizure
            if d.seizure(s).time_relAfter_2Hz(end)<T;
                disp(['Not enough time before ',num2str(s),'-th seizure, proceeding to next one.'])
                continue;
            end
            disp(['Seizure number ',num2str(s),', duration is ',...
                num2str( ( length(d.seizure(s).RRAfter_2Hz)-1  )/FS),' sec.']);
            
            %%%% finding the end of the part from T sec. after seizure
            end_ind=find(d.seizure(s).time_relAfter_2Hz>=T);
            end_ind=end_ind(1)-1;% end of T-sec. part
            
            %%%% extraction of time windows after seizure, signal parts
            %%%% are arranged columnwise, closest part to seizure onset is
            %%%% in the first column!!!
            [q,~]=get_signal_parts_time(d.seizure(s).RRAfter_2Hz(1:end_ind),Tw,To,FS,'D');
        else
            error('Unknown flag; RTFM!')
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% Here goes the functions calling:
        
        W=size(q,2);% 
        dummy1=zeros(1,W);% array for trend of characteristics of this seizure
        for w=1:W
            if strcmp(fcode,'PE')
                dummy1(w)=perm_entropy_value(q(:,w),varargin{1});
            elseif strcmp(fcode,'AE')
                dummy1(w)=apen(q(:,w),varargin{1},varargin{2});
            elseif strcmp(fcode,'SDNN')
                [~,~,dummy1(w)] = hrv_for_interpolated_signal(q(:,w),FS);
            elseif strcmp(fcode,'RMSSD')
                [~,~,~,~,~,~,dummy1(w)] = hrv_for_interpolated_signal(q(:,w),FS);
            elseif strcmp(fcode,'LF_HF')
                [~,~,~,dummy1(w)] = hrv_for_interpolated_signal(q(:,w),FS);
            elseif strcmp(fcode,'LFn')
                [~,~,~,~,dummy1(w)] = hrv_for_interpolated_signal(q(:,w),FS);
            elseif strcmp(fcode,'HFn')
                [~,~,~,~,~,dummy1(w)] = hrv_for_interpolated_signal(q(:,w),FS);
            elseif strcmp(fcode,'RR')%'Recurrence rate'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(1);
            elseif strcmp(fcode,'Det')%'Determinism'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(2);
            elseif strcmp(fcode,'ADL')%'Averaged diagonal length'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(3);
            elseif strcmp(fcode,'LLDL')%'Length of the longest diagonal line'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(4);
            elseif strcmp(fcode,'EDL')%'Entropy of diagonal length'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(5);
            elseif strcmp(fcode,'Lam')% 'Laminarity'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(6);
            elseif strcmp(fcode,'TT')%'Trapping time'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(7);
            elseif strcmp(fcode,'LLVL')%'Length of the longest vertical line'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(8);
            elseif strcmp(fcode,'RT1')%'Recurrence time of 1st type'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(9);
            elseif strcmp(fcode,'RT2')%'Recurrence time of 2nd type'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(10);
            elseif strcmp(fcode,'RPDE')%'Recurrence period density entropy'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(11);
            elseif strcmp(fcode,'CC')%'Clustering coefficient'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(12);
            elseif strcmp(fcode,'Trans')% 'Transitivity'
                [crqa_res, ~] = crqa_values_many_channels(q(:,w)');
                dummy1(w)=crqa_res(13);
                
                
            else
                error('No such function code; RTFM!')
            end
        end
        hrv_data{kb,1}=dummy1;
        kb=kb+1;% seizure counter        
    end
end % of all files in the folder
    
%%%%%%%%%%%%%%%%%%%%%%
%%% creating large matrix with parameters
sn=size(hrv_data,1);% total number of seizures in all signals
len_s=zeros(1,sn);% lengths of 
for s=1:sn
    len_s(s)=size(hrv_data{s},2);% number of windows before/after each particular seizure
end
MaxWinNum=max(len_s);% maximal number of windows
params=zeros(sn,MaxWinNum);% windows are columnwise, seizures are rowwise
%%%%%%%%
%%% saving parameters, redundand matrix
for s=1:sn % for all seizures
    for w=1:len_s(s)% for all windows
        params(s,w)=hrv_data{s,1}(w);
    end
end
%%%%%%%%%%%%%%%%%%%
%%%% saving parameters into the structure to get rid of zero elements
Params={};
for w=1:MaxWinNum%
    nzi=find(params(:,w));%indicies of nonzero elements for each window
    Params{w}=params(nzi,w);
end



