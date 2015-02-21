close all;
clear all;
clc;

% 2. Correction for EDF-extracted seizure start times. Is performed for *.mat file 
% and allows to save user-defined, true/needed times of seizure starts. The new array
% seizureStartCorrected is added to existing file.

dirMatInit = 'D:\Dropbox\my_matlab_code\EEG_Pavlova\edf_files\';
fname='gudz_test-5';%

d=load ([dirMatInit, fname,'.mat']);
d.seizureStartCorrected=[...% time from the signal start in seconds (relative time)
415, 424, 602, 1181, 1343,...
        ]';
dirMatRes = 'D:\Dropbox\my_matlab_code\EEG_Pavlova\edf_files\';

%fname='bigariy1-14';
save(strcat(dirMatRes,fname,'.mat'),'d');
