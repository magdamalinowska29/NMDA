function results= normalise_functional(data_dir_field, data_dir_images)

%takes as input paths to the folder with functional data (data_dir_images)
%and structural data (data_dir_field). Performs the normalisation of
%functional images. As a result creates normalised images files that start
%with 'w'


% List of open inputs
nrun=1; %choose how many times to run the normalisation
inputs=cell(0, nrun);
for crun=1:nrun
end

%spm('defaults', 'FMRI');

%if there are no specified paths, get the current folder
if ~exist('data_dir_field','var')

   data_dir_field=pwd;
    
end

if ~exist('data_dir_images','var')
    data_dir_images=pwd;
end

% get the image files
data_dir_images=strcat(data_dir_images, 'r*'); %here we specify, to only normalise data files that start with r, it might be different for different datasets

file_list_images=dir(data_dir_images); %get a structure of image files in directory

file_names_images=strcat({file_list_images.folder}', filesep, {file_list_images.name}');

%get the field file

data_dir_field=strcat(data_dir_field, 'y*'); % this is will find the field file named according to the previous steps from manual

file_list_field=dir(data_dir_field); %get a structure with the field file

file_name_field=strcat({file_list_field.folder}', filesep, {file_list_field.name}');

%set spm parameters

matlabbatch{1}.spm.spatial.normalise.write.subj.def = {file_name_field{1}}; %define the deformation field

matlabbatch{1}.spm.spatial.normalise.write.subj.resample = file_names_images; %define images to write

matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [3 3 3]; 
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w'; %save with w prefix

% run normalisation 

matlabbatches= repmat(matlabbatch, 1, nrun); 

spm_jobman('run', matlabbatches, inputs{:});


