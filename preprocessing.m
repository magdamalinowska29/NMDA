function results=preprocessing(data_path,tpm_path)

%function that takes as arguments path to  data folder and a path to tpm
%file. Performs all preprocessing steps (realignment, coregistration, segmentation, ormalisation and smoothing) and writes result files

if ~exist('data_path','var')
    data_path = pwd;
   
end

cd(data_path)

spm('Defaults','fMRI');
spm_jobman('initcfg');

functional_images = spm_select('FPList', fullfile(data_path,'fM00223'), '^f.*\.img$') ;
structural_images = spm_select('FPList', fullfile(data_path,'sM00223'), '^s.*\.img$');

clear matlabbatch

% REALIGNMENT
%This will run the realign job which will estimate the 6 parameter (rigid body) spatial transformation 
%that will align the times series of images and will modify the header of the input images 
%such that they reflect the relative orientation of the data after correction for movement artefacts.

matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(functional_images)};
%%
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';

% COREGISTRATION
% A coregistration between the structural and functional data is implemeted that maximises the mutual information.

matlabbatch{2}.spm.spatial.coreg.estimate.ref = cellstr(spm_file(functional_images(1,:),'prefix','mean'));
matlabbatch{2}.spm.spatial.coreg.estimate.source = cellstr(structural_images);
matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

% SEGMENTATION
% Another operation that is applied to anatomical images in preprocessing
% is the segmentation of brain tissue into separate tissue compartments (gray
% matter, white matter, and CSF).

% Remember to update the file paths (tpm_path) at the beginning of the script for tissue segmentation
matlabbatch{3}.spm.spatial.preproc.channel.vols = cellstr(structural_images);
matlabbatch{3}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{3}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
matlabbatch{3}.spm.spatial.preproc.tissue(1).tpm = {tpm_path};
matlabbatch{3}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{3}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(2).tpm = {tpm_path};
matlabbatch{3}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{3}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(3).tpm = {tpm_path};
matlabbatch{3}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(4).tpm = {tpm_path};
matlabbatch{3}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{3}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).tpm = {tpm_path};
matlabbatch{3}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{3}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).tpm = {tpm_path};
matlabbatch{3}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{3}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{3}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{3}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{3}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{3}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{3}.spm.spatial.preproc.warp.write = [0 1];
matlabbatch{3}.spm.spatial.preproc.warp.vox = NaN;
matlabbatch{3}.spm.spatial.preproc.warp.bb = [NaN NaN NaN
                                              NaN NaN NaN];

% NORMALIZATION-FUNCTIONAL DATA
% Functional data normalization, aligns functional brain images from different individuals 
% or sessions to a common reference space.

matlabbatch{4}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(structural_images,'prefix','y_','ext','nii')); 
matlabbatch{4}.spm.spatial.normalise.write.subj.resample = cellstr(functional_images);
matlabbatch{4}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];

matlabbatch{4}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{4}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{4}.spm.spatial.normalise.write.woptions.prefix = 'w';

% NORMALIZATION-STRUCTURAL DATA
%Structural normalization, on the other hand, aligns structural brain images 
% to a standardized anatomical template. 

matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(structural_images,'prefix','y_','ext','nii'));
matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(structural_images,'prefix','m','ext','nii'));
matlabbatch{5}.spm.spatial.normalise.write.woptions.vox = [1 1 3];

% SMOOTHING
% This function takes as input the path to the folder with the normalized images (functional).
% It performs spatial smoothing on the data using a Gaussian kernel with a FWHM of 6 mm.
% The smoothed images are saved with the prefix 's'

matlabbatch{6}.spm.spatial.smooth.data = cellstr(spm_file(functional_images,'prefix','w'));  % Specify the file names of the normalized images to be smoothed.
matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6]; % Set the Full Width at Half Maximum (FWHM) of the Gaussian smoothing kernel to 6 mm in each dimension.
matlabbatch{6}.spm.spatial.smooth.dtype = 0; % Set the data type of the smoothed images to the same as the input.
matlabbatch{6}.spm.spatial.smooth.im = 0;% Perform implicit masking during smoothing, where zero values are excluded from the smoothing.
matlabbatch{6}.spm.spatial.smooth.prefix = 's'; % Set the prefix for the smoothed images to 's'.

spm_jobman('run',matlabbatch);