function exportEdfToMatEdfPlus_new(dirEdf, dirMat, seiz_end_code);
% Reads all *.EDF files from current folder DIREDF and transforms them into
% MAT-files. Name of each file shold end with "-NN" where NN is the number
% of seizure mark, i.e. "name-14", "name-18" etc.
% Resulting MAT files are stored in DIRMAT folder.

% 20.02.2015 -- all data is saved in the fields of structure D.
% 21.02.2015 -- start of finding Seizure Ends (unfinished!!!)
% 03.03.2015 -- more than one seizure marker can be extracted



% 1. Export EDFs to MAT files one by one
fileStruct=dir(strcat(dirEdf,'*.edf'));

for i=1:length(fileStruct)% for each file in the input folder
    fileStruct(i).name;
    fprintf('%s\n',fileStruct(i).name);
    split=strsplit(fileStruct(i).name,'.');
    name=split{1};% extraction of file name
    split=strsplit(name,'-');% cell arrays of name parts between '-' sign
    SN=size(split,2)-1;% number of seizure markers in the record
    
    
    d.seizureStart=[];% empty array for seizure starts
    for sn=1:SN% for each seizure marker
        seizureCode = str2num(split{sn+1})% extracting the appropriate code
        fullPath = strcat(dirEdf,name,'.edf');
        % Extract data and meta info
        [d.data, header] = mexSLOAD(fullPath);
        % finding Seizure Starts
        for code=1:length(header.EVENT.CodeDesc)
            seizureCodeEdf = strsplit(header.EVENT.CodeDesc{code},' ');
            seizureCodeEdf = str2num(seizureCodeEdf{end}(2:end));
            if seizureCode == seizureCodeEdf
                seizureType = code;
                break;
            end
        end
        
        % finding Seizure Ends
        seizureEndCode=seiz_end_code;
        for code=1:length(header.EVENT.CodeDesc)
            seizureEndCodeEdf = strsplit(header.EVENT.CodeDesc{code},' ');
            seizureEndCodeEdf = str2num(seizureEndCodeEdf{end}(2:end));
            if seizureEndCode == seizureEndCodeEdf
                seizureEndType = code;
                %disp('Found one Seizure end!')
                break;
            else
                seizureEndType=[];
            end
        end
        
        %%%%%%%%%%%
        %%% filling the structure
        if 0 ~= exist('seizureType','var')
            % astr time +3h
            d.Fs = header.SampleRate;
            d.filter = header.Filter;
            d.labels = header.Label';
            d.N = size(d.data,1);
            d.time = linspace(0, (d.N-1)/d.Fs  ,d.N);
            
            % saving seizure starts
            d.seizureStart = [d.seizureStart;  header.EVENT.POS( find...
                (header.EVENT.TYP==seizureType) ) / d.Fs];
            % seizure ends
            if ~isempty(seizureEndType)
                d.seizureEnd = header.EVENT.POS( find...
                    (header.EVENT.TYP==seizureEndType) ) / d.Fs;
            else
                d.seizureEnd=[];
            end
            save(strcat(dirMat,name,'.mat'),'d','-v7.3');
            
            % printing info
            fprintf('Seizure starts:\n');
            datestr(d.seizureStart/3600/24, 'HH:MM:SS.FFF')
            fprintf('Seizure Ends:\n');
            datestr(d.seizureEnd/3600/24, 'HH:MM:SS.FFF')
        end
        fprintf('\n-----------------\n');
    end
end
end