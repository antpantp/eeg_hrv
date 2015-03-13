function [Params]=seizure_chracteristic_trends_for_HRV_standard_parameters...
    (dir_in,Flag,fcode,T,Tw,To,varargin);

% Returns trends of RR-2-Hz interpolated HRV characteristics of all seizures from all *.mat files in
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
% and the end of time range (if calculating after seizure).
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
% SDNN -- Standard Deviation of Normal-to-Normal RR intervals:
% [Params]=seizure_chracteristic_trends(dir_in,flag,'PE',T,Tw,To):
% Fs is the sampling rate
%
% RMSSD -- Root Mean Square of the Successive Differences of RR-intervals
% [Params]=seizure_chracteristic_trends(dir_in,flag,'PE',T,Tw,To)
%
%
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
    disp(fileStruct(i).name);% name of signal
    S=length(d.seizure);% number of seizures
    disp(['Number of seizures in the signal = ',num2str(S)]);
    
    for s=1:S; % for every seizure in the signal
        %%%%%% checking duration
        if strcmp(Flag,'before')
            %%%% checking if there is enough time before seizure
            if d.seizure(s).time_relBefore_2Hz(1)<T;
                disp(['Not enough time before ',num2str(s),'-th seizure, proceeding to next one.'])
                continue;
            end
            disp(['Seizure number ',num2str(s),', duration is ',...
                num2str( ( length(d.seizure(s).RRBefore_2Hz)-1  )/FS),' sec.']);
            
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



