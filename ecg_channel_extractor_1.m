%%% extraction of only ECG channels from *.mat files
close all;
clear all;
clc;

dirMat = 'M:\EEG_ECG Haritonov\MAT\FocalSeizures\';
dirOutput='M:\EEG_ECG Haritonov\MAT\FocalSeizures\focal_seizures_ECG\';

fileStruct=dir(strcat(dirMat,'*.mat'));
chNames={'ECG'};

for i=1:length(fileStruct)
    d=load([dirMat,fileStruct(i).name]);
    d_out=channelExtraction(d,chNames);
    isempty(d_out.data)% 1 if no ECG in the records
    save([dirOutput,'ECG_only_',fileStruct(i).name],'d_out')   
end