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
    data_path='C:\data\auditory' % We specify only one data_path where fM00223 and sM00223 are located, no need two write separately
    tpm_path = 'C:\Users\Marida\Documents\MATLAB\spm12\tpm\TPM.nii' 

% By providing the tpm_path,we ensure that the script can locate the necessary file for segmentation step
% regardless of the user running the code, without requiring manual modification of the file path. 
    
elseif whichComp==2
    spmPath='C:\';
    data_path='C:\data\';
    tpm_path='C:\spm12\tpm\TPM.nii';
elseif whichComp==3 
    spmPath='/Users/USERNAME/WHERE/spm12';
    data_path='ADD';
    tpm_path='Add';
else
    spmPath='/Users/USERNAME/WHERE/spm12';
    data_path='ADD';
    tpm_path='Add';
end

addpath(spmPath)

%This script relies heavily on the default naming pattern of spm. If files
%you want to use have different names, you'll have to change the function
%files directly. The naming patterns used: raw data 'f*', realigned data
%'r*', normalised data 'w*', deformation field file 'y*', bias corrected
%structural image 'm*'

% open spm
spm('defaults', 'FMRI');

%run preprocessing

preprocessing(data_path,tpm_path)