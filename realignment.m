function results = realignment(data_dir)

% List of open inputs
nrun=1; %choose how many times to run the realignment
inputs=cell(0, nrun);
for crun=1:nrun
end

if ~data_dir

   data_dir=pwd;
    %data_dir='C:\data\fM00223\fM00223*';% chooses only files that start with fM00223
    %data_dir='C:\data\fM00223\'; %chooses all files in the folder
end

data_dir=strcat(data_dir, 'f*'); %here we specify, to only realign data files that start with f, it might be different for different datasets

file_list=dir(data_dir); %get a structure of files in directory

file_names=strcat({file_list.folder}', filesep, {file_list.name}');

%spm('defaults', 'FMRI');

%set spm parameters
matlabbatch{1}.spm.spatial.realign.estwrite.data = {file_names}';
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

matlabbatches= repmat(matlabbatch, 1, nrun); 

%run realignment
spm_jobman('run', matlabbatches, inputs{:});
