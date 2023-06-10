function results=GLM(data_dir, glm_dir)

%function performs specification and estimation for first level GLM

%data_dir='C:\data\auditory\';
%output_dir='C:\data\auditory\classical';


if ~exist('glm_dir', 'var')
    glm_dir=pwd;
end

if ~exist('data_dir', 'var')
    data_dir=pwd;
end


%perform specification

matlabbatch{1}.spm.stats.fmri_spec.dir = {glm_dir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 7;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
%%
files = spm_select('FPList', fullfile(data_dir,'fM00223\'), '^swr.*\.img$');
matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(files);
%%
matlabbatch{1}.spm.stats.fmri_spec.sess.cond.name = 'listening';
matlabbatch{1}.spm.stats.fmri_spec.sess.cond.onset = [6
                                                      18
                                                      30
                                                      42
                                                      54
                                                      66
                                                      78];
matlabbatch{1}.spm.stats.fmri_spec.sess.cond.duration = 6;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond.tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess.cond.pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.cond.orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


%perform estimation

matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(glm_dir,'\SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%perform contrast
matlabbatch{3}.spm.stats.con.spmmat = {fullfile(glm_dir,'\SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Listening > Rest';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Rest > Listening';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 0];


spm_jobman('run', matlabbatch);
