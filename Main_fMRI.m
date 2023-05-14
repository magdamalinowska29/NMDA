%fMRI processing, main script

%preparation
close all; %close figures
clear; %clear the workspace 


%specify th edirectory of the data

%To run this script you have to specify the directories of the folders in
%your computer where functional and structural data are stored. When
%providing your path, keep in mind that processing functions search for
%proper files by concatenating the path with name patter e.g 'C:\data\r*'


whichComp=2;

if whichComp==1
    spmPath='C:\Users\Marida\Documents\MATLAB\spm12';
    data_dir_functional='C:\Users\Marida\Documents\MATLAB\spm12';
    %data_dir_structural=
elseif whichComp==2
    spmPath='C:\';
    data_dir_functional='C:\data\fM00223\'; %directory of functional files
    data_dir_structural='C:\data\sM00223\';%directory of structural files
%add two more options
end

%This script relies heavily on the default naming pattern of spm. If files
%you want to use have different names, you'll have to change the function
%files directly. The naming patterns used: raw data 'f*', realigned data
%'r*', normalised data 'w*', deformation field file 'y*', bias corrected
%structural image 'm*'

% open spm
spm('defaults', 'FMRI');

%run preprocessing

%run realignment

realignment(data_dir_functional); 

%coreagistration


%normalisation

normalise_functional(data_dir_structural,data_dir_functional); 

normalise_structural(data_dir_structural);

%smooting
smoothing(data_dir_functional);

