function [background_klinearized]  = kLinearization(background)
% -------------------------------------------------------------------------
% Author: Raymart Jay E. Canoy and Yong Guk Kang
% Email: recanoy@alum.up.edu.ph
% Latest Revision: 21 February 2023
% -------------------------------------------------------------------------

% Initialization
z = 2048;
pixels = 0 : z - 1;

% Cobra-S Specifications
lambda = 749.982 + 0.0976439.*pixels - 0.00000476162.*pixels.^2 - 0.000000000245623.*pixels.^3;

kwidth = 1/lambda(end) - 1/lambda(1);
wavenumber = 1./lambda;
klambda = 1./linspace(wavenumber(1), wavenumber(end), z);


kindex = zeros(1, z);
for index1 = 1 : z
    for index2 = 1 : z
        if lambda(index2) <= klambda(index1)
            kindex(index1) = index2;
        end
    end
end


% average background
background_ave = mean(background(:,1:end-1), 2);

% k-linearized background
background_klinearized = repmat(background_ave(kindex), 1, size(background(:, 1:end-1), 2));
end