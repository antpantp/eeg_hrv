function [Params]=seizure_approximate_entropy_trends(dir_in,T,Tw,To,M,r);

% Returns trends of RR-sequence (2 Hz interpolated) Approximate Entropy 
% of all seizures in files in folder DIR_IN, 
% starting from T sec. before seizure using the time window Tw sec. 
% moved with overlapping To sec. M is the ApEn dimension, R is the tolerance.

% 07.03.2015 -- start

fileStruct=dir(strcat(dir_in,'*.mat'));

%M=2;% approximate entropy embedded dimension
%H=20;% number of bins for MI calculation

hrv_data_before=[];
kb=1;% seizure counter, before

%%%%%%%%%
%%% calculating trends of characteristics before seizure

for i=1:length(fileStruct)% all mat files
    load([dir_in,fileStruct(i).name]);
    disp(fileStruct(i).name);% name of signal
    S=length(d.seizureStart);% number of seizures
    disp(['Number of seizures in the signal = ',num2str(S)]);
    
    for s=1:S; % for every seizure in the signal
        %%%%%% checking duration
        if d.seizure(s).time_relBefore_2Hz(1)<T;
            disp(['Not enough time before ',num2str(s),'-th seizure, procceding to next one.'])
            continue;
        end
        disp(['Seizure number ',num2str(s),', duration is ',...
            num2str( ( length(d.seizure(s).RRBefore_2Hz)-1  )/2),' sec.']);
        
        %%%% finding the start of the part from T sec. before seizure
        st_ind=find(d.seizure(s).time_relBefore_2Hz<=T);
        st_ind=st_ind(1);% start of T-sec. part
        
        %%%% extraction of time windows before seizure
        [q,~]=get_signal_parts_time(d.seizure(s).RRBefore_2Hz(st_ind:end),Tw,To,2,'R');
        W=size(q,2);
        dummy1=zeros(1,W);% array for trend1
        for w=1:W
            dummy1(w)=apen(q(:,w),M,r);
        end
        hrv_data_before{kb,1}=dummy1;
        kb=kb+1;% seizure counter
    end        
end

%%%%%%%%%%%%%%%%%%%%%%
%%% creating large matrix with parameters
sn=size(hrv_data_before,1);% total number of seizures in all signals
len_s=zeros(1,sn);% lengths of 
for s=1:sn
    len_s(s)=size(hrv_data_before{s},2);% number of windows before each particular seizure
end
MaxWinNum=max(len_s);% maximal number of windows before seizure
params=zeros(sn,MaxWinNum);% windows are columnwise, seizures are rowwise

%%%%%%%%
%%% saving parameters, redundand matrix
for s=1:sn
    for w=1:len_s(s)
        params(s,w)=hrv_data_before{s,1}(w);
    end
end

%%%%%%%%%%%%%%%%%%%
%%%% saving parameters into the structure to avoid zero elements
Params={};
% Params2={};
for w=1:MaxWinNum
    nzi=find(params(:,w));%indicies of nonzero elements for each window
    Params{w}=params(nzi,w);
end
