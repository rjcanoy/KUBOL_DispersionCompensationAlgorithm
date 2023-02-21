function dataSet = bin2mat(fileInitial, precededByZero, type, pixels, Ascans, Bscans)
% Coverts *.bin files into *.mat files
% Syntax: bin2mat_FinalVersion(fileInitial, precededByZero, type)
%
% Input:
% fileInitial = Initial name of the file,
% precededByZero = 'Yes' or 'No' or '',
% type = 'RAW' or 'BG'
%
% Output:
% fileInitial.mat
%
% -------------------------------------------------------------------------
% Author: Raymart Jay E. Canoy
% Affiliation: Korea University Biomedical Optics Laboratory
% email: recanoy@alum.up.edu.ph
% Last updated: 08 January 2021
% Latest revision: 21 February 2023
% -------------------------------------------------------------------------

%%%%%%%%%%%%%%% 01_Goes to the folder directory %%%%%%%%%%%%%%%%%%
% path = uigetdir();
% cd(path)

%%%%%%%%%%%%%%% 02_Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pixels = input('Number of pixels: '); %pixels in the spectrometer
% Ascans = input('Number of A-scans: '); %number of A-scans
% Bscans = input('Number of B-scans: '); %number of B-scans

%%%%%%%%%%%%%% 03_Putting the .bin files data into a vector
f=waitbar(0,sprintf('Reading %2.2f %% of B-scans', 0)); % wait bar

if (Bscans > 0 && Bscans > 1)
    switch type
        case 'RAW'
            dataSet = zeros(pixels, Ascans, Bscans);
            
            switch precededByZero
                case 'Yes'
                    for ind = 1 : Bscans
                        dataSet(:, :, ind) = read_file(sprintf('%s_%04d.bin', fileInitial, ind));
                        waitbar(ind/Bscans,f,sprintf('Reading %2.2f %% of B-scans',100*ind/Bscans));
                    end
                case 'No'
                    for ind = 1 : Bscans
                        dataSet(:, :, ind) = read_file(sprintf('%s_%d.bin', fileInitial, ind));
                        waitbar(ind/Bscans,f,sprintf('Reading %2.2f %% of B-scans',100*ind/Bscans));
                    end
                otherwise
                    for ind = 1 : Bscans
                        dataSet(:, :, ind) = read_file(sprintf('%s_%05.bin', fileInitial, ind));
                        waitbar(ind/Bscans,f,sprintf('Reading %2.2f %% of B-scans',100*ind/Bscans));
                    end
            end
            
            delete(f)
            
            %%%%%%%%%%%%% 04_Saving the file as a .mat file %%%%%%%%%%%%%%%%%%
%             save(sprintf('%s.mat', fileInitial), 'dataSet', '-v7.3')
            
        case 'BG'
            dataSet = zeros(pixels, Ascans, Bscans);
            
            switch precededByZero
                case 'Yes'
                    for ind = 1 : Bscans
                        dataSet(:, :, ind) = read_file(sprintf('%s_%04d.bin', fileInitial, ind));
                        waitbar(ind/Bscans,f,sprintf('Reading %2.2f %% of B-scans',100*ind/Bscans));
                    end
                case 'No'
                    for ind = 1 : Bscans
                        dataSet(:, :, ind) = read_file(sprintf('%s_%d.bin', fileInitial, ind));
                        waitbar(ind/Bscans,f,sprintf('Reading %2.2f %% of B-scans',100*ind/Bscans));
                    end
                otherwise
                    for ind = 1 : Bscans
                        dataSet(:, :, ind) = read_file(sprintf('%s_%05.bin', fileInitial, ind));
                        waitbar(ind/Bscans,f,sprintf('Reading %2.2f %% of B-scans',100*ind/Bscans));
                    end
            end
            
            delete(f)
            
            %%%%%%%%%%%%% 04_Saving the file as a .mat file %%%%%%%%%%%%%%%%%%
%             save(sprintf('%s.mat', fileInitial), 'background', '-v7.3')
    end
    
else
    dataSet = zeros(pixels, Ascans, Bscans);
    
    dataSet(:, :, Bscans) = read_file(sprintf('%s.bin', fileInitial));
    
    delete(f)
    
    %%%%%%%%%%%%% 04_Saving the file as a .mat file %%%%%%%%%%%%%%%%%%
%     save(sprintf('%s.mat', fileInitial), 'background', '-v7.3')
end
end

function dataa = read_file(filename)
%%%%%%%%%%%%%%% 01_Reads the files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(filename, 'r');
data = fread(fid, 'ubit16');
fclose(fid);

%%%%%%%%%%%%%% 02_A-scans %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 2048; %specification of the spectrometer used
dataa = reshape(data, N, []); % creates an N by (row(data)/N)
end
