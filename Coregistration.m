function Coregisteration(data_dir_field, data_dir_images)
%takes as input paths to the folder with functional data (data_dir_images)
%and structural data (data_dir_field). Implements a coregistration between 
%the structural and functional data that maximises the mutual information.
%As result, the header of the source file will be changed

% List of open inputs
nrun = 1; % choose how many times to run the coregistration
inputs = cell(0, nrun);
for crun = 1:nrun
end

%if there are no specified paths, get the current folder
if ~exist('data_dir_field','var')

   data_dir_field = pwd;
    
end

if ~exist('data_dir_images','var')
    data_dir_images = pwd;
end

%get the file names
refimage_filename = strcat(data_dir_images, "meanfM00223_004.img,1"); %get the name of the reference image file
sourimage_filanme = strcat(data_dir_field, "sM00223_002.img,1'"); %get the name of the source image file

% Set spm parameters
matlabbatch{1}.spm.spatial.coreg.estimate.ref = refimage_filename;
matlabbatch{1}.spm.spatial.coreg.estimate.source = sourimage_filanme;
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

% run coregistration
matlabbatches = repmat(matlabbatch, 1, nrun);

spm_jobman('run', matlabbatches, inputs{:});
disp('Coregistration completed.');
