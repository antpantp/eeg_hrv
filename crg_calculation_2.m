% Calculating RR-intervals.
% This script takes all *.mat files from the folder specified in DIRMAT, finds ECG channel
% there, and if sucessful then it finds RRs, interpolates them and saves in
% the file with the same name in folder DIROUTPUT. Interpolated CRG has
% same sampling rate and same duration as initial ECG. Linear interpolation
% is used.
% 
% Zhenia -- extration of RR
% 24.01.2015 -- start
% 20.02.2015 -- minor corrections, verification
% 21.02.2015 -- field added with RR intervals interpolated with Fs=2 Hz

close all;
clear;
clc;

% dir_in = 'M:\EEG_ECG Haritonov\MAT\FocalSeizures\';
% dir_out='M:\EEG_ECG Haritonov\MAT\FocalSeizures\focal_seizures_ECG\';

% dir_in='D:\Dropbox\my_matlab_code\EEG_Pavlova\old_stuff\edf_files\';
% dir_out='D:\Dropbox\my_matlab_code\EEG_Pavlova\old_stuff\edf_files\';

% dir_in='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';
% dir_out='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';

dir_in='D:\DATA\ЭЭГ_от_Харитонова\temp\';
dir_out=dir_in;



fileStruct=dir(strcat(dir_in,'*.mat'));
for i=1:length(fileStruct)% all mat files
    load([dir_in,fileStruct(i).name]);
    disp(fileStruct(i).name);
    ind = findChannelIndex(d.labels,{'ECG'});% find index of ECG channel
    if isempty(ind); continue; end
    [rr,rr_t]=extract_rr_as_function(d.data(:,ind),d.Fs);% extraction of RR and corresponding time instants
    %%% interpolation with same Fs as in EEG and ECG
    RR_interp = interp1(rr_t,rr,d.time);% linear interpolation by default
    d.RR_raw=rr;% initial RR-intervals
    d.RR_pos=rr_t;% time positions of initial RR-intervals
    d.RR=RR_interp;% interpolated RR-intervals, CRG

    %%% interpolation with Fs=2 Hz
    Fs=2;% Hz
    time_2Hz=0:1/Fs:d.time(end);
    RR_interp = interp1(rr_t,rr,time_2Hz);% linear interpolation by default
    d.RR_2Hz=RR_interp;% interpolated RR-intervals, CRG
    d.time_2Hz=time_2Hz;
    
    %%%%%%%%%%%%
    %%%% saving structure with CRG
    save(strcat(dir_out, fileStruct(i).name),'d','-v7.3');
        
end
