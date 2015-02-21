function [S,n]=get_signal_parts(sig,win,ovr)
% Function S=getsignalpart(sig,win,ovr) returns matrix S with the parts of
% the signal SIG of WIN samples diration arranged columnwise, taken with the overlap
% OVR samples. N is the number of obtained signal parts.

N=length(sig);
n=floor((N-win)/(win-ovr));
S=zeros(win,n);
row=1;
for k=1:win-ovr:N-win%signal samples
    S(:,row)=sig(k:k+win-1);
    row=row+1;
end


