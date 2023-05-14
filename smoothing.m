function results = smoothing(data_dir)
% This function takes as input the path to the folder with the normalized images (functional).
% It performs spatial smoothing on the data using a Gaussian kernel with a FWHM of 8 mm.
% The smoothed images are saved with the prefix 's'.

% List of open inputs
nrun = 1; % choose how many times to run the smoothing
inputs = cell(0, nrun);
for crun = 1:nrun
end

% If there's no specified path, take data from the current directory
if ~exist('data_dir','var')
   data_dir = pwd;
end

% get the normalised functional images
data_dir_norm = strcat(data_dir, 'w*'); %here we specify to only use normalised functional images that start with w
file_list_norm = dir(data_dir_norm); %get a structure of image files in directory
file_names_norm = strcat({file_list_norm.folder}', filesep, {file_list_norm.name}');

% Set spm parameters
matlabbatch{1}.spm.spatial.smooth.data = file_names_norm; % Specify the file names of the normalized images to be smoothed.
matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8]; % Set the Full Width at Half Maximum (FWHM) of the Gaussian smoothing kernel to 8 mm in each dimension.
matlabbatch{1}.spm.spatial.smooth.dtype = 0; % Set the data type of the smoothed images to the same as the input.
matlabbatch{1}.spm.spatial.smooth.im = 0; % Perform implicit masking during smoothing, where zero values are excluded from the smoothing.
matlabbatch{1}.spm.spatial.smooth.prefix = 's'; % Set the prefix for the smoothed images to 's'.

% run smoothing
matlabbatches = repmat(matlabbatch, 1, nrun);

spm_jobman('run', matlabbatches, inputs{:});
disp('Smoothing completed.');
