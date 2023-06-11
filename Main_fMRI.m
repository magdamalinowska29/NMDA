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
    data_path='C:\data\auditory\'; % We specify only one data_path where fM00223 and sM00223 are located, no need two write separately
    tpm_path = 'C:\Users\Marida\Documents\MATLAB\spm12\tpm\TPM.nii'; 
    glm_dir='C:\data\auditory\GLM1';
    glm2_dir='C:\data\SomaTI-Example\RFX1';
    glm2_sub_folders='C:\data\SomaTI-Example';
    one_sample_ttest_input_pattern= '^con_0009\.img$';
    Anova_2x4_file_patterns={'^con_0009\.img$', '^con_0010\.img$', '^con_0011\.img$', '^con_0012\.img$', '^con_0013\.img$', '^con_0014\.img$', '^con_0015\.img$', '^con_0016\.img$'};

% By providing the tpm_path,we ensure that the script can locate the necessary file for segmentation step
% regardless of the user running the code, without requiring manual modification of the file path. 
    
elseif whichComp==2
    spmPath='C:\';
    data_path='C:\data\';
    tpm_path='C:\spm12\tpm\TPM.nii';
    glm_dir='C:\data\auditory\classical';
    glm2_dir='C:\data\SomaTI-Example\RFX1';
    glm2_sub_folders='C:\data\SomaTI-Example';
    one_sample_ttest_input_pattern= '^con_0009\.img$';
    Anova_2x4_file_patterns={'^con_0009\.img$', '^con_0010\.img$', '^con_0011\.img$', '^con_0012\.img$', '^con_0013\.img$', '^con_0014\.img$', '^con_0015\.img$', '^con_0016\.img$'};

elseif whichComp==3 
    spmPath='C:\Program Files\Matlab\spm12';
    data_path='C:\Users\Androro\Documents\Università\Methods and Data Analysis II\2023\Resources\Example data\MoAEpilot';
    tpm_path='C:\Program Files\Matlab\spm12\spm12\TPM.nii';
    glm_dir='ADD';
    one_sample_ttest_input_pattern= '^con_0009\.img$';
    Anova_2x4_file_patterns={'^con_0009\.img$', '^con_0010\.img$', '^con_0011\.img$', '^con_0012\.img$', '^con_0013\.img$', '^con_0014\.img$', '^con_0015\.img$', '^con_0016\.img$'};
else
    spmPath='/Users/USERNAME/WHERE/spm12';
    data_path='ADD';
    tpm_path='Add';
    glm_dir='ADD';
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

preprocessing(data_path,tpm_path);

%run first level GLM
GLM(data_path,glm_dir);

%run 2nd level GLM, one-sample t-test

One_sample_ttest_2nd_level(glm2_dir,glm2_sub_folders,one_sample_ttest_input_pattern)

% Anova 2x4 Mains+interaction

anova_2x4_Main_Interaction(glm2_dir, glm2_sub_folders, Anova_2x4_file_patterns)


