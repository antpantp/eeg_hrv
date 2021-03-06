function signal_partition_into_seizures_new(dir_in, dir_out)
% Opens all *.mat files with the signals from the input folder DIR_IN. 
% Takes input structure D and returns structures with the new field
% D.SEIZURE.  It consists of signal pieces with extracted parts before and 
% after seizures. Absolute and relative (with respect to the seizure onset)
% time  bases are returned as well.
% 26.01.2015 -- start
% 04.03.2015 -- all seizures are stored in separate structure, apart from the
% initial signal
% 06.03.2015 -- saving 2-Hz interpolated RR-intervals for each seizure


fileStruct=dir(strcat(dir_in,'*.mat'));
for i=1:length(fileStruct)% all mat files
    load([dir_in,fileStruct(i).name]);
    fileStruct(i).name
    
    if ~isfield(d, 'seizureStart');% no seizures in the signal
        continue
    end
    if isempty(d.seizureStart)
        continue
    end
    
    S=length(d.seizureStart);% number of seizures
    for s=1:S; % for every seizure in the signal
        disp(['Processing seizure ',num2str(s), ' of ',num2str(S)])
        % calculation of indicies for seizures
        if S==1% single seizure
            s_tmp=find(d.time>=d.seizureStart(s));
            s_st=s_tmp(1);% start of current seizure (index)
            s_prev=1;% start of previous seizure (index) = start of record
            s_next=length(d.time);% start of next seizure (index) = end of record
            
            s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s));           
            s_st_2Hz=s_tmp_2Hz(1);% start of current seizure (index)
            s_prev_2Hz=1;% start of previous seizure (index) = start of record
            s_next_2Hz=length(d.time_2Hz);% start of next seizure (index) = end of record

        
        else % more than one seizure,S>1
            if s==1% first seizure
                s_tmp=find(d.time>=d.seizureStart(s));
                s_st=s_tmp(1);% start of current seizure (index)
                s_prev=1;% start of previous seizure (index) = start of recording
                s_tmp=find(d.time>=d.seizureStart(s+1));
                s_next=s_tmp(1);% start of current seizure (index)
                
                s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s));
                s_st_2Hz=s_tmp_2Hz(1);% start of current seizure (index)
                s_prev_2Hz=1;% start of previous seizure (index) = start of recording
                s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s+1));
                s_next_2Hz=s_tmp_2Hz(1);% start of current seizure (index)

            
            elseif s==S% last seizure
                  s_tmp=find(d.time>=d.seizureStart(s));
                  s_st=s_tmp(1);% start of current seizure (index)
                  s_tmp=find(d.time>=d.seizureStart(s-1));
                  s_prev=s_tmp(1);% start of previous seizure (index)
                  s_next=length(d.time);% start of next seizure (index) = end of signal
                  
                  s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s));
                  s_st_2Hz=s_tmp_2Hz(1);% start of current seizure (index)
                  s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s-1));
                  s_prev_2Hz=s_tmp_2Hz(1);% start of previous seizure (index)
                  s_next_2Hz=length(d.time_2Hz);% start of next seizure (index) = end of signal

                  
            else% middle seizure
                s_tmp=find(d.time>=d.seizureStart(s));
                s_st=s_tmp(1);% start of current seizure (index)
                s_tmp=find(d.time>=d.seizureStart(s-1));
                s_prev=s_tmp(1);% start of previous seizure (index)
                s_tmp=find(d.time>=d.seizureStart(s+1));
                s_next=s_tmp(1);% start of next seizure (index)
                
                
                s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s));
                s_st_2Hz=s_tmp_2Hz(1);% start of current seizure (index)
                s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s-1));
                s_prev_2Hz=s_tmp_2Hz(1);% start of previous seizure (index)
                s_tmp_2Hz=find(d.time_2Hz>=d.seizureStart(s+1));
                s_next_2Hz=s_tmp_2Hz(1);% start of next seizure (index)

            end
        end
        
        % generation of indexes for the parts of recording
        ind_before=s_prev:s_st-1;% indexes of the interval before siezure
        ind_after=s_st:s_next-1; % indexes of the interval after siezure
        
        ind_before_2Hz=s_prev_2Hz:s_st_2Hz-1;% indexes of the interval before siezure
        ind_after_2Hz=s_st_2Hz:s_next_2Hz-1; % indexes of the interval after siezure

        % extraction of data
        d.seizure(s).sigBefore=d.data(ind_before,:);
        d.seizure(s).sigAfter=d.data(ind_after,:);
        d.seizure(s).RRBefore=d.RR(ind_before);
        d.seizure(s).RRAfter=d.RR(ind_after);
        d.seizure(s).time_absBefore=d.time(ind_before);% absolute time
        d.seizure(s).time_absAfter=d.time(ind_after);% absolute time
        % relative  time, siezure onset corresponds to 0 sec.:
        d.seizure(s).time_relBefore=d.time(s_st-1:-1:s_prev)-d.time(s_prev);% reversed time!!!
        d.seizure(s).time_relAfter=d.time(ind_after)-d.time(s_st);
        
        d.seizure(s).RRBefore_2Hz=d.RR_2Hz(ind_before_2Hz);
        d.seizure(s).RRAfter_2Hz=d.RR_2Hz(ind_after_2Hz);
        d.seizure(s).time_absBefore_2Hz=d.time_2Hz(ind_before_2Hz);% absolute time
        d.seizure(s).time_absAfter_2Hz=d.time_2Hz(ind_after_2Hz);% absolute time
        % relative  time, siezure onset corresponds to 0 sec.:
        d.seizure(s).time_relBefore_2Hz=d.time_2Hz(s_st_2Hz-1:-1:s_prev_2Hz)...
            -d.time_2Hz(s_prev_2Hz);% reversed time!!!
        d.seizure(s).time_relAfter_2Hz=d.time_2Hz(ind_after_2Hz)-d.time_2Hz(s_st_2Hz);

        
    end
    d1=d;
    d1.data=[];% saving only seizures in the new structure
    d=d1;
    save([dir_out,'seizures_',fileStruct(i).name],'d','-v7.3');
end
