% main program
% 26.01.2015
% 20.02.2015 -- adding some new stuff



close all;
clear;
clc;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 1. Export EDFs to MAT files one by one, extract seizure start labels from
% % EDF. This code should be run firstly, to create the structure fom EDF.
% 
% dir_in = 'M:\EEG_ECG Haritonov\EDF\FocalSeizures\';
% dir_out = 'M:\EEG_ECG Haritonov\MAT\FocalSeizures';
% dir_in='D:\Dropbox\my_matlab_code\EEG_Pavlova\old_stuff\edf_files\';
% dir_out='D:\Dropbox\my_matlab_code\EEG_Pavlova\old_stuff\edf_files\';

dir_in='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';
dir_out='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';

seiz_end_code=19;
exportEdfToMatEdfPlus(dir_in,dir_out, seiz_end_code);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 2. CRG calculation from WHOLE ECG channel in the structure D.
crg_calculation_2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HRV parameters calculation
%%% Use script    hrv_calculation_1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ECG channel extraction
%%%  Use script   ecg_channel_extractor_1
    
% %%%%%%%%%%%%%%%%%%%%%%%%
% %%% 4. Extract parts before and after each seizure, from MAT files =
% Signal partition into seizures

% % dir_in='M:\EEG_ECG Haritonov\MAT\FocalSeizures\focal_seizures_ECG\';
% % dir_out='M:\EEG_ECG Haritonov\MAT\FocalSeizures\focal_seizures_ECG\with_seizures_separated\';
% % dir_in='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\';
% % dir_out='D:\DATA\ЭЭГ_от_Харитонова\Focal Seizures\wit_seizures_separated\';
% dir_in='D:\Dropbox\my_matlab_code\EEG_Pavlova\old_stuff\edf_files\';
% dir_out='D:\Dropbox\my_matlab_code\EEG_Pavlova\old_stuff\edf_files\seizures_separated\';


signal_partition_into_seizures(dir_in, dir_out)





