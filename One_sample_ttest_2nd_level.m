function results=One_sample_ttest_2nd_level(glm2_dir,glm2_sub_folders,one_sample_ttest_input_pattern)

%function that takes as arguments: directory in which 2nd level glm files
%should be saved (glm2_dir, default: pwd), directory in which subjects' folders
%are saved (glm2_sub_folders, default: pwd), a pattern used in naming the files used in t-test
%(one_sample_ttest_input_pattern, default: '^con_0009\.img$')

%performs specification and estimation for 2nd level glm one sample t-test
%and safes results in glm2_dir

clear matlabbatch
spm('defaults', 'FMRI');

%set the variables if not specified 

if ~exist('glm2_dir','var') %directory in which we save the glm specification and estimation results
    glm2_dir = pwd;
end

if ~exist('glm2_sub_folders','var') %
    glm2_sub_folders = pwd;
end

if ~exist('one_sample_ttest_input_pattern','var')
    one_sample_ttest_input_pattern = '^con_0009\.img$';
   
end

cd(glm2_sub_folders);


% Specify the list of subject folders

subjects=cellstr(ls); % get a list of all folders in glm2_sub_folders directory


% Use a loop to select the contrast image for each subject
contrast_images = cell(length(subjects), 1);
for i = 1:length(subjects)
    contrast_images{i, 1} = spm_select('FPList', fullfile(glm2_sub_folders, subjects{i}), one_sample_ttest_input_pattern);
end


contrast_images=contrast_images(~cellfun('isempty',contrast_images)); %delete empty cells from contrast_images

% Specify the other parameters for the second-level analysis
matlabbatch{1}.spm.stats.factorial_design.dir = {glm2_dir}; %This command specifies the directory where the second-level analysis results will be saved.
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = contrast_images; % Specifies the input contrast images for the second-level analysis (one-sample T-test in this case).

matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {}); % no covariates are included.
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {}); % no multiple covariates are included.
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1; % no threshold masking should be applied.
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1; %  Implicit masking should be used, meaning that voxels with a value of zero in all images are treated as missing.
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''}; % No explicit mask image is used in the analysis.
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1; 
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1; 
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;% Indicates that the data should be normalized using proportional scaling.


%estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(fullfile(glm2_dir,"\SPM.mat")); %path to SPM file from 2nd level
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run', matlabbatch);

