%fMRI processing, main script

%preparation
close all; %close figures
clear; %clear the workspace 


%specify th edirectory of the data

whichComp=2;

if whichComp==1
    spmPath='C:\Users\Marida\Documents\MATLAB\spm12';
    data_dir='C:\Users\Marida\Documents\MATLAB\spm12';
elseif whichComp==2
    spmPath='C:\';
    data_dir='C:\data\fM00223\';
%add two more options
end


% open spm
spm('defaults', 'FMRI');

%run preprocessing

realignment(data_dir); %run realignment

%coreagistration


%normalisation


%smooting

