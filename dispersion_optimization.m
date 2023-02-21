function [a2, a3, a2_f, a3_f, COV_mat, t] = dispersion_optimization(data_int, a2_initial, a3_initial, title_)
% -------------------------------------------------------------------------
% Author: Raymart Jay E. Canoy
% Email: recanoy@alum.up.edu.ph
% Affiliation: Korea University Biomedical Optics Laboratory
% Revised Date: 21 February 2023
% -------------------------------------------------------------------------

% (01) Working on the GPU
tic
%data = gpuArray(data_int);
data = data_int;

% (02) Initialization
pixels = size(data, 1);
Ascans = size(data, 2) + 1;

% (03) Frequency
freq = -pixels/2 : 1 : (pixels/2 - 1);
freq_2D = repmat(freq', [1, (Ascans - 1)]);

% (04) Dispersion coefficients
% [a2, a3] = ndgrid(-2000e-8 : 1e-8 : 2000e-8, -2000e-11 : 1e-11 : 2000e-11);
a2_i = a2_initial;
a3_i = a3_initial;
a2_f = 0;
a3_f = 0;

% (05) Visualisation
itr = 1;

figure;
set(gca);
xlabel('Iteration Number', 'FontSize', 12);
ylabel('Coefficient of Variation (COV)', 'FontSize', 12);
title(title_, 'FontSize', 12);
while(1)
    inc_a2 = 20e-8;
    inc_a3 = 20e-11;
    [a2, a3] = ndgrid(a2_i - inc_a2: 1e-8 : a2_i + inc_a2, a3_i - inc_a3 : 1e-11 : a3_i + inc_a3);

    % Zero padding for Fourier transformation
    pad = 2;
    newN = 2*pixels;

    % This matrix will hold the COV values
    %COV_mat = gpuArray(zeros(size(a2, 1), size(a2, 2)));
    COV_mat = zeros(size(a2, 1), size(a2, 2));

    f = waitbar(0, sprintf('Analyzing %2.2f %% of the rows', 0), 'Name', sprintf('Iteration number %d', itr));
    setappdata(f, 'canceling', 0)
    for row = 1 : size(a2, 1)
        for col = 1 : size(a2, 2)
            phase = atan2(imag(data), real(data)) - a2(row, col)*freq_2D.^2 - a3(row, col)*freq_2D.^3;
            disp_hann_2D = (abs(data).*(cos(phase) + j*sin(phase))).*repmat(hann(2048, 'periodic'), [1, Ascans-1]);
            
            dataSet_FFTz = fftshift(fft(disp_hann_2D, newN, 1), 1);
            norm_amplitude = abs(dataSet_FFTz)/newN;
            
            brightness = 10;
            contrast = 5;

            amp_z_log = 20*log10(norm_amplitude);
            image_z = (amp_z_log + brightness)*contrast;
            image_z = image_z.*(image_z>0);

            COV_mat(row, col) = sharpness_metric(image_z(end/2+1:end/2+1024, :));
           
        end
    waitbar(row/size(a2, 1), f, sprintf('Analyzing %2.2f %% of the rows',(row/size(a2,1))*100), 'Name', sprintf('Iteration number %d', itr))
    end
    delete(f)
    
    maxel = max(COV_mat, [], 'all');
    [x, y] = find(COV_mat == maxel);
    
    a2_f = a2(x, y);
    a3_f = a3(x, y);
    
    if a2_i == a2_f & a3_i == a3_f
        break
    else
        a2_i = a2_f;
        a3_i = a3_f;
    end
    hold on; plot(itr, COV_mat(x, y), 'k.', 'MarkerSize', 12); pause(0.05);
    itr = itr + 1;
end

t = toc;
end

% (06) Function that calculates the coefficient of variation of an OCM
% cross-sectional image
function COV = sharpness_metric(gray_scaled_data)

mu = mean(mean(gray_scaled_data, 1), 2);

COV = sqrt((1/size(gray_scaled_data, 1))*sum(sum((gray_scaled_data - mu).^2, 1), 2))/mu;

end