%CREATE_ANDROID_IRS
%
%   CREATE_ANDROID_IRS creates a short version of the given irsset 
%   for the Android phone. Therefore the single IRs are stored as binary 
%   files using float32 in the corresponding directory.
%

% AUTHOR: Hagen Wierstorf, Sascha Spors


%% ===== Variables ======================================================

%irset = '~/data/ir_databases/Wittek_KEMAR/Wittek_KEMAR_studio_src1_0deg.mat';
irset = '~/svn/capture/data/ir_databases/Wittek_KEMAR/Wittek_KEMAR_studio_src1_0deg.mat';
fs = 22050;
nsamples = 128;
outdir = sprintf('~/data/measurements/BRIRs/android_%i_Wittek',nsamples);
if ~exist(outdir,'dir')
    mkdir(outdir);
end

irs = read_irs(irset);
angles = irs.apparent_azimuth;


%% ===== Configuration ==================================================
% Load default configuration values
conf = SFS_config;


%% ===== Computation ====================================================

irs = create_android_irs_mat(irs,nsamples,fs,conf);


%% ===== Save results ===================================================

% Write IRs to file
for ii = 1:length(angles)
    
    ir = get_ir(irs,angles(ii));
    
    % Left HRIR signal
    pstr = sprintf('%s/HRIR_left_%d.dat',outdir,round(angles(ii)/pi*180));
    fid=fopen(pstr,'w');
    %fprintf(fid,'%d\r\n',short_hrirs(1:nsamples,ii,1));
    fwrite(fid,ir(:,1),'float32');
    fclose(fid);
    
    % Right HRIR signal
    pstr = sprintf('%s/HRIR_right_%d.dat',outdir,round(angles(ii)/pi*180));
    fid=fopen(pstr,'w');
    %fprintf(fid,'%d\r\n',short_hrirs(1:nsamples,ii,2));
    fwrite(fid,ir(:,2),'float32');
    fclose(fid);
    
end
