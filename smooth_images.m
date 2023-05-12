function results = smooth_images(data_dir)
% This function takes as input the path to the folder with the normalized images (functional or structural).
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

% Find the normalized images
data_dir = strcat(data_dir, 'w*'); % here we specify to only smooth normalized data files that start with 'w'.

file_list = dir(data_dir); % get a structure of image files in the directory

file_names = strcat({file_list.folder}', filesep, {file_list.name}');

% Set spm parameters
matlabbatch{1}.spm.spatial.smooth.data = {file_names}';
matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';

matlabbatches = repmat(matlabbatch, 1, nrun); 

% Run smoothing
spm_jobman('run', matlabbatches, inputs{:});

end