function [ind] = findChannelIndex(all_labels,channels)
% Finds indicies of channels with specified names. ALL_LABELS is a cell
% array of strings with names of existing channels. CHANNELS is a cell
% array of strings with names of desired channels.
% Anton, 24.01.2015

ind = [];% empty array for future indicies
for num=1:length(channels)% for each desired channel name to be found
    for ch=1:length(all_labels)% for each channel name in the list of existing channel names
        if ~isempty( strfind(all_labels{ch},channels{num}));
            ind = [ind ch];% collection of numbers of desired channels
        end
    end
end

end