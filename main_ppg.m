%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Project: Heart Rate Estimation from PPG Signals
%
% Author: Rajab Murtaja
% Contact: rajab_30@hotmail.com
%
% Description:
% This project implements a heart rate estimation from PPG signals using
% adaptive filtering and signal processing techniques for motion artifact
% reduction. Accelerometer signals are used as a noise reference to
% improve heart rate extraction performance.
%
% Dataset:
% This implementation uses/evaluates data from the TROIKA dataset:
% "TROIKA: A General Framework for Heart Rate Monitoring Using Wrist-Type
% Photoplethysmographic Signals During Intensive Physical Exercise"
%
% Citation:
% Z. Zhang, Z. Pi, and B. Liu,
% "TROIKA: A General Framework for Heart Rate Monitoring Using Wrist-Type
% Photoplethysmographic Signals During Intensive Physical Exercise,"
% IEEE Transactions on Biomedical Engineering, vol. 62, no. 2,
% pp. 522–531, 2015.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
fsize = 30;  %font size

algorithm='rls';     % choose between (rls, lms, Normalized_lms) to test the desired algorithm
filter_order = 64;   % 64 is filter order
delay_samples = filter_order/2;   % consider the delay caused by the filter
fs = 125;
delay_time = delay_samples / fs;
% we have 22 datasets, here for example we test only 3 but you can set the num. to 22
num_datasets = 5;
correlation=zeros(num_datasets,1);
mean_error=zeros(num_datasets,1);

for i=1:num_datasets
    if i<13

        load(sprintf('data/train%d.mat', i));
        load(sprintf('data/true_train%d.mat', i));
        [algorithm_hr,corrupted_hr]=hr_estimate(sig,BPM0,125,'train',algorithm, filter_order);
    else
        load(sprintf('data/test%d.mat',i-12));
        load(sprintf('data/true_test%d',i-12));
        [algorithm_hr,corrupted_hr]=hr_estimate(sig,BPM0,125,'test',algorithm);
    end
        c=corrcoef(algorithm_hr,BPM0);  % Pearson correlation
        correlation(i)=c(2);
        mean_error(i)=mean(abs(algorithm_hr-BPM0));   % mean error
        time=1:2:length(algorithm_hr)*2;
        figure('Unit', 'Normalized', 'Position', [0.2 0.4 0.6 0.4])
        plot(time, BPM0,'k','LineWidth', 3);   % the ground truth HR
        hold on;
        plot(time-delay_time, algorithm_hr , 'LineWidth', 3);  %algorithm HR
        plot(time, corrupted_hr, 'LineWidth', 3);   % corrupted ppg HR
        xlabel('Time (s)', 'FontSize', fsize)
        ylabel('BPM', 'FontSize', fsize)
        legend('ground truth', 'after', 'before')
        set(gca, 'FontSize', fsize)

end
fprintf('mean of error is: %0.4f\n', mean(mean_error));
fprintf('mean of correlation is: %0.4f\n', mean(correlation));
