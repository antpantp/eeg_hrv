function [S,n]=get_signal_parts_time(sig,win,ovr,Fs, flag)
% Function S=get_signal_parts_time(sig,win,ovrl) returns matrix S with the parts of
% the signal SIG of WIN sec. diration arranged columnwise, taken with the overlap
% OVR sec. Parts are extracted starting from the first sample.
% If flag ='R' is set, reversed sequence of parts are returned: last window 
% corresponds to the first column in the matrix S.
% N is the number of obtained signal parts. Fs is sampling rate.


N=length(sig);% number of samples in the signal
Nw=floor(win*Fs);% number of samples in the time window
No=floor(ovr*Fs);% number of samples in overlap

n=floor((N-Nw)/(Nw-No));% number of time windows
S=zeros(Nw,n);

if flag=='R';
    col=1;
    for k=N:-(Nw-No):Nw%signal samples
        S(:,col)=sig(k-(Nw-1):k);
        col=col+1;
    end
else
    col=1;
    for k=1:Nw-No:N-Nw%signal samples
        S(:,col)=sig(k:k+Nw-1);
        col=col+1;
    end    
end
n=size(S,2);% adjusting the magic to real-life



