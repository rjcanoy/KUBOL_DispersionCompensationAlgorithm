%% Dispersion Compensation of the cross-sectional OCM images
%% =======================================================================
%
% Author: Raymart Jay E. Canoy
% Email: recanoy@alum.up.edu.ph
% Date: 21 February 2023
%
% ------------------------------------------------------------------------

% (01) Initialization
rootfolder = input("root_folder: ", "s");
RAWInitial = "RawData3D_[220718]_TapePhantom";
BGInitial = "BackData3D_[220718]_TapePhantom";
pixels = 2048;
Ascans = 1000;

% (02) Loading the RAW dataset
RAW_path = fullfile(rootfolder, 'RAW');
cd(RAW_path)
Bscans = 25;
RAW_dataset = bin2mat(RAWInitial, "Yes", "RAW", pixels, Ascans, Bscans);

% (03) Loading the BG dataset
BG_path = fullfile(rootfolder, 'BACKDATA');
cd(BG_path);
BG_dataset = bin2mat(BGInitial, "No", "BG", pixels, Ascans, 1);
BG_dataset_klinearized = kLinearization(BG_dataset);

% (04) Backsubtraction
data_backsub = RAW_dataset(:, 1:end-1, :)- BG_dataset_klinearized;

% (05) Dispersion Compensation
a2_initial = 7.416800e-5;
a3_initial = 1.164000e-8;
title_ = "Dispesion Compensation (Tape Phantom)";
[a2, a3, a2_f, a3_f, COV_mat, t] = dispersion_optimization(data_backsub(:,:, ceil(Bscans/2)), a2_initial, a3_initial, title_);