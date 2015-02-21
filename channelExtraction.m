function d_out=channelExtraction(d_in,chNames);
% Extracts channels from the recording saved in D_IN structure into new
% structure D_OUT. CHNAMES is a cell array with the names of channels (may not 
% be literally the same as in D_IN.LABELS, but should contain correct parts.
% 

numbers= findChannelIndex(d_in.labels,chNames);

d_out=d_in;
d_out.data=d_in.data(:,numbers);% keeping only selected channels
d_out.labels=chNames;% keeping names of selected channels (same as input)

end