function results= normalise_structural(data_dir)

%takes as input a path to the folder with structural data

% List of open inputs
nrun=1; %choose how many times to run the normalisation
inputs=cell(0, nrun);
for crun=1:nrun
end

%if there's no sepcified path, take data from the current directory
if ~exist('data_dir','var')
   data_dir=pwd;
    
end

%find the deformation field file

data_dir_field=strcat(data_dir, 'y*'); %here we specify to only take the file that starts with y

file_list_field=dir(data_dir_field); %get a structure of image files in directory

file_names_field=strcat({file_list_field.folder}', filesep, {file_list_field.name}');


%find the bias corrected structural image

data_dir_struct=strcat(data_dir, 'm*'); %here we specify to only take the file that starts with m

file_list_struct=dir(data_dir_struct); %get a structure of image files in directory

file_names_struct=strcat({file_list_struct.folder}', filesep, {file_list_struct.name}');

matlabbatch{1}.spm.spatial.normalise.write.subj.def = {file_names_field{1}};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {file_names_struct{1}};
matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1 1 3];
matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';


% run normalisation 

matlabbatches= repmat(matlabbatch, 1, nrun); 

spm_jobman('run', matlabbatches, inputs{:});


