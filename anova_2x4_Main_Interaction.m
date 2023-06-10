function results=anova_2x4_Main_Interaction(glm2_dir, glm2_sub_folders, file_patterns)

%takes as arguments: output directory of 2nd level glm (glm2_dir, defaults
%to pwd), directory of subject folders (glm2_sub_folders, defaults to pwd),
%pattern of naming images files (file_patterns, defaults to (see line 21)

%performs 2x4 factorial analysis with factor matrix [1 1; 1 2; 1 3; 1 4; 2
%1; 2 2; 2 3; 2 4]

clear matlabbatch

if ~exist('glm2_dir','var') %directory in which we save the glm specification and estimation results
    glm2_dir = pwd;
end

if ~exist('glm2_sub_folders','var') %directory of subject folders
    glm2_sub_folders = pwd;
end

if ~exist('file_patterns','var')
    file_patterns = {'^con_0009\.img$', '^con_0010\.img$', '^con_0011\.img$', '^con_0012\.img$', '^con_0013\.img$', '^con_0014\.img$', '^con_0015\.img$', '^con_0016\.img$'};
   
end


cd(glm2_sub_folders);

subjects=cellstr(ls); % get the list of subject folders

%loop over participants and get cell arrays of contrast images
contrast_images = cell(length(subjects),8); % 8 images for each subject (2x4)
for i = 1:length(subjects)
    for j=1:8

        contrast_images{i, j} = spm_select('FPList', fullfile(glm2_sub_folders, subjects{i}), file_patterns{j});
    end

end

%delete rows that contain empty cells from contrast_image array
empty = cellfun('isempty',contrast_images);
contrast_images(any(empty,2),:) = [];

%delete folder names from subject list if they don't contain the contrast
%files
subjects(any(empty,2),:) = [];


matlabbatch{1}.spm.stats.factorial_design.dir = {glm2_dir};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'CONDITION';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'LOCATION';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;


for k=1:length(subjects)

    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(k).scans= cellstr(spm_select('FPList', fullfile(glm2_sub_folders, subjects{k}), file_patterns));
    matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(k).conds = [1 1
                                                                                  1 2
                                                                                  1 3
                                                                                  1 4
                                                                                  2 1
                                                                                  2 2
                                                                                  2 3
                                                                                  2 4];

end


matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [1
                                                                                  2];
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr(fullfile(glm2_dir,"\SPM.mat"));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat = cellstr(fullfile(glm2_dir,"\SPM.mat"));
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Condition';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [1 -1 0 0 0 0 0.25 0.25 0.25 0.25 -0.25 -0.25 -0.25 -0.25];
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.name = 'Location';
matlabbatch{3}.spm.stats.con.consess{2}.fcon.weights = [0 0 1 -0.333333333333333 -0.333333333333333 -0.333333333333333 0.5 -0.166666666666667 -0.166666666666667 -0.166666666666667 0.5 -0.166666666666667 -0.166666666666667 -0.166666666666667
                                                        0 0 -0.333333333333333 1 -0.333333333333333 -0.333333333333333 -0.166666666666667 0.5 -0.166666666666667 -0.166666666666667 -0.166666666666667 0.5 -0.166666666666667 -0.166666666666667
                                                        0 0 -0.333333333333333 -0.333333333333333 1 -0.333333333333333 -0.166666666666667 -0.166666666666667 0.5 -0.166666666666667 -0.166666666666667 -0.166666666666667 0.5 -0.166666666666667
                                                        0 0 -0.333333333333333 -0.333333333333333 -0.333333333333333 1 -0.166666666666667 -0.166666666666667 -0.166666666666667 0.5 -0.166666666666667 -0.166666666666667 -0.166666666666667 0.5];
matlabbatch{3}.spm.stats.con.consess{2}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.name = 'Interaction';
matlabbatch{3}.spm.stats.con.consess{3}.fcon.weights = [0 0 0 0 0 0 1 -0.333333333333333 -0.333333333333333 -0.333333333333333 -1 0.333333333333333 0.333333333333333 0.333333333333333
                                                        0 0 0 0 0 0 -0.333333333333333 1 -0.333333333333333 -0.333333333333333 0.333333333333333 -1 0.333333333333333 0.333333333333333
                                                        0 0 0 0 0 0 -0.333333333333333 -0.333333333333333 1 -0.333333333333333 0.333333333333333 0.333333333333333 -1 0.333333333333333
                                                        0 0 0 0 0 0 -0.333333333333333 -0.333333333333333 -0.333333333333333 1 0.333333333333333 0.333333333333333 0.333333333333333 -1];
matlabbatch{3}.spm.stats.con.consess{3}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

spm_jobman('run', matlabbatch);
