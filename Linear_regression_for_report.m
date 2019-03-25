%% Linear regression for FSL output 
% 1. Load Raw data and Filtered data
% 2. plot timeseries
% 3. Compare Raw vs Filtered
% 4. Design Matrix
% 5. Linear Regression
% 6. Assessing the goodness of fit


%% Read file into matlab
hdr = niftiinfo('__WIP_fMRI_SENSE_20190215111734_401.nii');
data = niftiread('__WIP_fMRI_SENSE_20190215111734_401.nii');

% timeseries taken from fsl Feat log: Zstat...
ts = squeeze(data(19, 17, 9, :));

% plot timeseries
figure, plot(ts, 'black', 'linewidth', 2)
xlabel('Time(TR)')
ylabel('fMRI response')
title('Timeseries at location [19,17,9]')


%% The filtered data
% The data shown in the FSL/FEAT report has been filtered:
% motion/temporal/spatial
% the intermediated data will be saved as filtered_func_data

hdr_ff = niftiinfo('__WIP_fMRI_SENSE_20190215111734_401.feat/filtered_func_data.nii'); % ask about .gz
data_ff = niftiread('__WIP_fMRI_SENSE_20190215111734_401.feat/filtered_func_data.nii');
ts_ff = squeeze(data_ff(19, 17, 9, :));

% Plot intermediate data
figure, plot(ts_ff, 'r-', 'linewidth', 2)
xlabel('Time(TR)'); ylabel('fMRI response')
title('Filtered Response at [19,17,9]]')


%% look at both at the same time --> note different y axis!!

t = hdr_ff.PixelDimensions(4) .* (1:numel(ts_ff));  % TR (s)
figure
[AX,H1,H2] = plotyy(t, ts, t, ts_ff);
set(H1,'color', [1 0 0]);
set(H2,'color', [0 0.2 1]);
title('A TimeSeries plot of Raw (red) and Filtered (blue)')
xlabel('Time (s)')
ylabel('fMRI response (image intensity)')
 

%% Design Matrix

% convert design.mat from VEST fromat to .txt in FSL command line --> Vest2Text design.mat design.txt;

% load in converted version
% make sure the file is in the current folder!
X = load('__WIP_fMRI_SENSE_20190215111734_401.feat/design.txt'); 
% also add a column of ones!
X = [X, ones(size(X,1),1)];
% inspect
figure, imagesc(X), colormap(gray)
xlabel('Explanatory Variables (Faces/Objects/Scenes)')

 
%% Linear regression
 
% solve (for beta):
% data = X * \beta + \epsilon
 
% little gotcha... ts is INTEGERS --> use double... 
 
ts = double(ts); % turn into normal matlab numbers
beta = X\ts;
beta_ff = X\ts_ff; % the filtered version

% model fit is beta weights times the column of X
model = X*beta; % matrix multiply! dont need .*
model_ff = X*beta_ff;
 
residuals = ts - model;
residuals_ff = ts_ff - model_ff; % just with filtered data

%% Plot
figure
subplot(2,1,1)
plot(t,ts, 'k-', t, model, 'r-', 'linewidth', 2)
xlabel('Time (s)')
ylabel('fMRI image intensity')
title('Raw Data')

subplot(2,1,2)
plot(t,ts_ff, 'k-', t, model_ff, 'r-', 'linewidth', 2)
xlabel('Time (s)')
ylabel('fMRI  image intensity')
title('Timeseries for peak voxel location - Faces')
 
%% Calculate R2 to assess goodness of fit

% r^2 = 1 -var(e)./var(data);
% e = data - X*beta;

% One measure of goodness of fit
% "variance accounted for by model"
% where e is the vector of errors or residuals 
% e = ts_ff - X*beta_ff; e = residuals_ff


r2 = 1 - var(residuals_ff)./var(ts_ff);





